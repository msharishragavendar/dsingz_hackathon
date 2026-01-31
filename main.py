"""
NL2SQL with AI/ML Analytics Engine
Complete pipeline: Natural Language → SQL → MySQL → Analytics → Response
"""

import requests
import json
import re
import mysql.connector
import hashlib
import copy
from typing import Dict, Any, List, Tuple, Optional
from datetime import datetime

# --- CONFIG IMPORTS ---
try:
    from config import DB_CONFIG, OPENROUTER_API_KEY, OPENROUTER_URL, MODEL
except ImportError:
    # Fallback
    OPENROUTER_API_KEY = "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"
    MODEL = "deepseek/deepseek-chat"
    OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"
    DB_CONFIG = {"host": "localhost", "user": "root", "password": "jinu", "database": "dz"}

from analytics import AnalyticsProcessor
from analytics.nl_response_generator import NLResponseGenerator
from analytics.email_notifier import EmailNotifier
from analytics.salary_calculator import SalaryCalculator


# =========================
# SECURITY: ANONYMIZATION
# =========================
SENSITIVE_FIELDS = ['first_name', 'last_name', 'contact_no', 'pan_number', 'emergency_contact_number']
EMAIL_FIELDS = ['official_email', 'personal_email']

def generate_hash(value: str) -> str:
    if not value: return value
    hash_obj = hashlib.sha256(str(value).encode())
    return f"EMP_{hash_obj.hexdigest()[:8]}"

def anonymize_dataset(data: List[Dict]) -> Tuple[List[Dict], Dict[str, str]]:
    if not data: return [], {}
    anonymized_data = copy.deepcopy(data)
    mapping = {}
    
    for row in anonymized_data:
        for field in SENSITIVE_FIELDS:
            if field in row and row[field]:
                t = generate_hash(str(row[field]))
                row[field] = t
                mapping[t] = str(row[field])
        for field in EMAIL_FIELDS:
            if field in row and row[field]:
                orig = str(row[field])
                if '@' in orig:
                    u, d = orig.split('@', 1)
                    t = generate_hash(u)
                    row[field] = f"{t}@{d}"
                    mapping[t] = u
                else:
                    t = generate_hash(orig)
                    row[field] = t
                    mapping[t] = orig
    return anonymized_data, mapping

def deanonymize_text(text: str, mapping: Dict[str, str]) -> str:
    if not text: return ""
    for token in sorted(mapping.keys(), key=len, reverse=True):
        text = text.replace(token, mapping[token])
    return text

# =========================
# SQL SAFETY
# =========================
def execute_sql(sql_query: str) -> List[Dict[str, Any]]:
    conn = None
    try:
        if any(x in sql_query.lower() for x in ["delete", "drop", "update", "insert", "alter"]):
            return []
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor(dictionary=True)
        cursor.execute(sql_query)
        rows = cursor.fetchall()
        for row in rows:
            for k, v in row.items():
                if isinstance(v, datetime): row[k] = v.isoformat()
                elif hasattr(v, 'total_seconds'): row[k] = v.total_seconds() / 3600
        return rows
    except Exception as e:
        print(f"❌ SQL Error: {e}")
        return []
    finally:
        if conn: conn.close()

def get_employee_names() -> List[str]:
    try:
        sql = "SELECT first_name, last_name FROM employees UNION SELECT first_name, last_name FROM interns"
        rows = execute_sql(sql)
        return sorted(list(set([f"{r.get('first_name','')} {r.get('last_name','')}".strip() for r in rows if r.get('first_name')])))
    except: return []

# =========================
# LLM
# =========================
def extract_query_info(raw_output: str) -> Dict[str, Any]:
    raw = re.sub(r'^```\w*\n?|\n?```$', '', raw_output.strip())
    try: return json.loads(raw)
    except:
        match = re.search(r'\{[\s\S]*\}', raw)
        return json.loads(match.group()) if match else {"query_type": "DIRECT_SQL", "sql_query": raw}

def sentence_to_sql(sentence: str) -> Dict[str, Any]:
    prompt = f"""
You are an expert MySQL query generator.
TASK: Classify intent and Generate JSON.

SCHEMA:
attendance_records(uuid, employee_id, date, check_in_time, check_out_time, status)
employees(uuid, first_name, last_name, official_email, job_role)
interns(uuid, first_name, last_name, personal_email, role, status)
intern_attendance_records(uuid, intern_id, date, check_in_time, check_out_time, status)
employees_skills(employee_id, technology_ids, level)
technologies(uuid, technology_name, category_id)
categories(uuid, name)

QUERY TYPES:
1. SEND_EMAIL: User wants to send email.
2. DIRECT_SQL: General data retrieval.
3. TREND_ANALYSIS: Trends over time (attendance, leaves).
4. CALCULATE_SALARY: If user asks for salary/pay.
   - Set target_name="ALL_EMPLOYEES" if "all employees".
   - Set target_name="ALL_INTERNS" if "all interns".
   - Else extract name.
5. SKILL_ANALYSIS: User asks about skills/competence.
   - VISUALIZATION: "radar_chart"

CRITICAL SQL RULES:
1. AMBIGUITY: When joining tables, ALWAYS use table aliases for columns like 'status', 'uuid', 'created_at'.
   - WRONG: SELECT status FROM employees e JOIN attendance_records ar...
   - RIGHT: SELECT ar.status FROM employees e JOIN attendance_records ar...
2. SKILL JOINS: To get skill categories, you MUST join 4 tables:
   - employees e JOIN employees_skills es ON e.uuid=es.employee_id
   - JOIN technologies t ON es.technology_ids=t.uuid
   - JOIN categories c ON t.category_id=c.uuid
   - Use: AVG(CASE es.level WHEN 'expert' THEN 4 WHEN 'intermediate' THEN 3 WHEN 'beginner' THEN 2 ELSE 1 END) as avg_skill_score
   - Select: c.name as category_name

QUESTION: {sentence}

OUTPUT JSON:
{{
  "query_type": "SEND_EMAIL" | "DIRECT_SQL" | "TREND_ANALYSIS" | "CALCULATE_SALARY" | "SKILL_ANALYSIS",
  "sql_query": "SELECT ...",
  "visualization": "line_chart|bar_chart|pie_chart|radar_chart|null",
  "target_name": "...",
  "target_month": "YYYY-MM",
  "email_subject": "...",
  "email_body": "..."
}}
"""
    headers = {"Authorization": f"Bearer {OPENROUTER_API_KEY}", "Content-Type": "application/json", "HTTP-Referer": "http://localhost"}
    payload = {"model": MODEL, "messages": [{"role": "user", "content": prompt}], "temperature": 0}
    try:
        response = requests.post(OPENROUTER_URL, headers=headers, json=payload)
        return extract_query_info(response.json()["choices"][0]["message"]["content"])
    except Exception as e:
        print(f"LLM Error: {e}")
        return {"sql_query": None}

# =========================
# MAIN PIPELINE
# =========================
def process_query(question: str, force_graph: bool = False) -> Dict[str, Any]:
    result = {"question": question, "query_info": None, "sql_query": None, "sql_data": [], "analytics": None, "response": "", "visualization": None}
    
    try:
        print("🔄 Processing...")
        final_question = question + " (Generate a visualization)" if force_graph else question
        query_info = sentence_to_sql(final_question)
        result["query_info"] = query_info
        q_type = query_info.get("query_type")
        
        # --- PATH C: SALARY ---
        if q_type == "CALCULATE_SALARY":
            target = query_info.get("target_name", "").replace("@", "").strip().upper()
            month = query_info.get("target_month")
            calc = SalaryCalculator(DB_CONFIG)
            
            if target in ["ALL_EMPLOYEES", "EMPLOYEES", "ALL EMPLOYEES"]:
                print("Calculating: Employees")
                res = calc.calculate_all('employee', month)
            elif target in ["ALL_INTERNS", "INTERNS", "ALL INTERNS"]:
                print("Calculating: Interns")
                res = calc.calculate_all('intern', month)
            else:
                raw_target = query_info.get("target_name", "").replace("@", "").strip()
                if not raw_target:
                    result["response"] = "Please specify a name."
                    return result
                print(f"Calculating: {raw_target}")
                res = calc.calculate(raw_target, month)
                if res["status"] == "success": res["data"] = [res["data"]]

            if res["status"] == "success":
                data = res["data"]
                if not data:
                    result["response"] = "No records found."
                else:
                    period = data[0]['month']
                    header = f"### Salary Report ({period})\n\n"
                    table = "| Name | Role | Worked | Payable | Final Salary |\n|---|---|---|---|---|\n"
                    for d in data:
                        table += f"| {d['name']} | {d['role']} | {d['worked_hours']}h | {d['payable_hours']}h | **{d['currency']} {d['final_salary']:,}** |\n"
                    result["response"] = header + table
                    result["sql_data"] = data
            else:
                result["response"] = f"❌ {res['message']}"
            return result

        # --- OTHER PATHS ---
        sql = query_info.get("sql_query")
        if not sql:
            result["response"] = "Could not understand query."
            return result
        print(f"✅ Type: {q_type} | SQL: {sql}")

        if q_type == "SEND_EMAIL":
            rows = execute_sql(sql)
            recipients = [r.get("official_email") or r.get("personal_email") for r in rows if r.get("official_email") or r.get("personal_email")]
            if not recipients:
                result["response"] = "No emails found."
            else:
                notifier = EmailNotifier()
                res = notifier.send_batch(recipients, query_info.get("email_subject", "Notification"), query_info.get("email_body", "Alert"))
                result["response"] = f"✅ Sent to {res['sent']} recipient(s)."
            return result

        rows = execute_sql(sql)
        anon, mapping = anonymize_dataset(rows)
        if mapping: print(f"🔐 Masked {len(mapping)} values.")
        
        result["sql_data"] = rows
        if not rows:
            result["response"] = "No data found."
            return result
            
        proc = AnalyticsProcessor("./charts")
        ana_res = proc.process(query_info, anon, mapping)
        
        result["analytics"] = ana_res.get("analysis")
        result["visualization"] = ana_res.get("visualization")
        result["response"] = deanonymize_text(ana_res.get("natural_language_response", ""), mapping)
        
    except Exception as e:
        print(f"Error: {e}")
        result["response"] = f"Error: {e}"
        
    return result

if __name__ == "__main__":
    print(process_query(input("Question: "))["response"])