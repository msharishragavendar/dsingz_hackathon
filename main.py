"""
NL2SQL with AI/ML Analytics Engine
Complete pipeline: Natural Language → SQL → MySQL → Analytics → Response
"""

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

# --- NEW IMPORTS ---
try:
    from config import DB_CONFIG, OPENROUTER_API_KEY, OPENROUTER_URL, MODEL
except ImportError:
    # Fallback if config.py is missing (using your current settings)
    OPENROUTER_API_KEY = "sk-or-v1-"
    MODEL = "deepseek/deepseek-chat"
    OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"
    DB_CONFIG = {
        "host": "localhost",
        "user": "root",
        "password": "jinu", 
        "database": "dz"
    }

from analytics import AnalyticsProcessor
from analytics.nl_response_generator import NLResponseGenerator
from analytics.email_notifier import EmailNotifier  # <--- NEW FEATURE
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
        # 1. Hash Standard Sensitive Fields
        for field in SENSITIVE_FIELDS:
            if field in row and row[field]:
                original = str(row[field])
                token = generate_hash(original)
                row[field] = token
                mapping[token] = original

        # 2. Hash Email Fields (Masking user part)
        for field in EMAIL_FIELDS:
            if field in row and row[field]:
                original = str(row[field])
                if '@' in original:
                    user_part, domain = original.split('@', 1)
                    token_user = generate_hash(user_part)
                    row[field] = f"{token_user}@{domain}"
                    mapping[token_user] = user_part
                else:
                    token = generate_hash(original)
                    row[field] = token
                    mapping[token] = original
    return anonymized_data, mapping

def deanonymize_text(text: str, mapping: Dict[str, str]) -> str:
    if not text: return ""
    # Sort keys by length desc to avoid partial replacements
    sorted_tokens = sorted(mapping.keys(), key=len, reverse=True)
    for token in sorted_tokens:
        text = text.replace(token, mapping[token])
    return text


# =========================
# SQL SAFETY & EXECUTION
# =========================
def validate_sql(sql: str) -> str:
    """Block dangerous SQL operations."""
    forbidden = ["delete", "drop", "truncate", "update", "alter", "insert"]
    sql_lower = sql.lower()
    for word in forbidden:
        if word in sql_lower:
            raise ValueError(f"❌ Dangerous SQL blocked: {word}")
    return sql

def execute_sql(sql_query: str) -> List[Dict[str, Any]]:
    conn = None
    cursor = None
    try:
        validate_sql(sql_query)
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor(dictionary=True)
        cursor.execute(sql_query)
        rows = cursor.fetchall()
        
        cleaned_rows = []
        for row in rows:
            cleaned_row = {}
            for key, value in row.items():
                if isinstance(value, datetime):
                    cleaned_row[key] = value.isoformat()
                elif hasattr(value, 'total_seconds'):
                    cleaned_row[key] = value.total_seconds() / 3600
                else:
                    cleaned_row[key] = value
            cleaned_rows.append(cleaned_row)
        return cleaned_rows
    except Exception as err:
        print(f"❌ SQL Error: {err}")
        return []
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

def get_employee_names() -> List[str]:
    """Fetch names from Employees and Interns (Preserving your existing logic)."""
    try:
        sql = """
        SELECT first_name, last_name FROM employees WHERE first_name IS NOT NULL
        UNION
        SELECT first_name, last_name FROM interns WHERE first_name IS NOT NULL
        """
        rows = execute_sql(sql)
        names = [f"{r.get('first_name','')} {r.get('last_name','')}".strip() for r in rows]
        return sorted(list(set(filter(None, names))))
    except:
        return []


# =========================
# LLM: SENTENCE → SQL
# =========================
def extract_query_info(raw_output: str) -> Dict[str, Any]:
    raw_output = re.sub(r'^```\w*\n?', '', raw_output.strip())
    raw_output = re.sub(r'\n?```$', '', raw_output)
    try:
        return json.loads(raw_output)
    except:
        # Fallback regex extraction
        match = re.search(r'\{[\s\S]*\}', raw_output)
        if match: return json.loads(match.group())
    
    # Default fallback
    return {"query_type": "DIRECT_SQL", "sql_query": raw_output}

def sentence_to_sql(sentence: str) -> Dict[str, Any]:
    prompt = f"""
You are an expert MySQL query generator with intelligent query classification capabilities.

TASK 1: CLASSIFY THE USER INTENT
Analyze the user's question and determine the specific action required:
1. DIRECT_SQL: Simple data retrieval (e.g., "List all employees", "Show attendance").
2. SQL_WITH_STATS: Requires statistical analysis (variance, averages, consistency).
3. PATTERN_DETECTION: Behavioral pattern recognition (seasonal leaves, late arrival habits).
4. ANOMALY_DETECTION: Identifying unusual behavior or outliers.
5. TREND_ANALYSIS: Time-based trends (e.g., "Is attendance improving?").
6. COMPARISON: Comparing multiple entities (e.g., "Compare Rajesh and Suresh").
7. CALCULATE_SALARY: User asks to calculate salary/pay.
   - Triggers: "Calculate salary for X", "Payroll for X", "How much pay for X".
   - Constraint: Do NOT generate SQL for salary calculation. Only extract 'target_name' and 'target_month'.
8. SEND_EMAIL: User wants to send an email notification.
   - Triggers: "Send email to...", "Notify X that...".
   - Action: Generate SQL to fetch the email address of the target.

TASK 2: GENERATE SQL
- If the query needs database data, generate VALID MySQL 8.0+ SQL.
- CRITICAL: All non-aggregated columns in SELECT must be included in GROUP BY.
- **Handling Names (CRITICAL):** People can be in the `employees` OR `interns` table.
  - When querying by name, you MUST use `UNION ALL` to check both tables unless the user explicitly specifies "Intern" or "Employee".
  - Example Pattern:
    ```sql
    SELECT first_name, date, status FROM employees e JOIN attendance_records ar ON e.uuid = ar.employee_id WHERE first_name='X'
    UNION ALL
    SELECT first_name, date, status FROM interns i JOIN intern_attendance_records iar ON i.uuid = iar.intern_id WHERE first_name='X'
    ```
- Use `LOWER(first_name) LIKE LOWER('%name%')` for case-insensitive matching.

DATABASE SCHEMA:
attendance_records(uuid, employee_id, date, check_in_time, check_out_time, status, leave_deducted)
employees(uuid, employee_id, profile_image, first_name, last_name, official_email, job_role, contact_no)
interns(uuid, intern_id, profile_image, first_name, last_name, personal_email, role, contact_no)
intern_attendance_records(uuid, intern_id, date, check_in_time, check_out_time, status, leave_deducted)
leaves(uuid, employee_id, request_type, type, start_date, end_date, days, status)
intern_leaves(uuid, intern_id, request_type, type, start_date, end_date, days, status)

OUTPUT JSON FORMAT:
{{
  "query_type": "DIRECT_SQL|SQL_WITH_STATS|PATTERN_DETECTION|ANOMALY_DETECTION|TREND_ANALYSIS|COMPARISON|CALCULATE_SALARY|SEND_EMAIL",
  "sql_query": "SELECT ... (or null)",
  "analysis_required": ["variance", "trend", "anomaly", "consistency", "pattern"],
  "visualization": "line_chart|bar_chart|pie_chart|null",
  
  // FOR SALARY ONLY:
  "target_name": "Rajesh",
  "target_month": "2023-10",

  // FOR EMAIL ONLY:
  "email_subject": "Warning",
  "email_body": "Your attendance is low..."
}}

QUESTION: {sentence}
"""
    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "Content-Type": "application/json",
        "HTTP-Referer": "http://localhost",
    }
    payload = {
        "model": MODEL,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0
    }
    try:
        response = requests.post(OPENROUTER_URL, headers=headers, json=payload)
        response.raise_for_status()
        return extract_query_info(response.json()["choices"][0]["message"]["content"])
    except Exception as e:
        print(f"LLM Error: {e}")
        return {"sql_query": None}
    

# =========================
# MAIN PIPELINE
# =========================
""" 
def process_query(question: str) -> Dict[str, Any]:
    result = {
        "question": question, "query_info": None, "sql_query": None,
        "sql_data": [], "analytics": None, "response": "", "visualization": None
    }
    
    try:
        print("🔄 Processing...")
        
        # 1. Generate SQL & Intent
        query_info = sentence_to_sql(question)
        result["query_info"] = query_info
        sql_query = query_info.get("sql_query")
        query_type = query_info.get("query_type")
        
        if not sql_query:
            result["response"] = "Could not understand the query."
            return result

        print(f"✅ Type: {query_type} | SQL: {sql_query}")
        
        # --- PATH A: SEND EMAIL (No Hashing) ---
        if query_type == "SEND_EMAIL":
            # Execute to find recipients
            raw_data = execute_sql(sql_query)
            
            # Extract emails
            recipients = []
            for row in raw_data:
                # Check for various email column names
                email = row.get("official_email") or row.get("personal_email") or row.get("email")
                if email: recipients.append(email)
            
            if not recipients:
                result["response"] = "No email addresses found for those employees."
                return result

            # Send Email
            subject = query_info.get("email_subject", "Notification from HR Bot")
            body = query_info.get("email_body", "Please check your HR portal.")
            
            print(f"📧 Sending to {len(recipients)} recipients...")
            notifier = EmailNotifier()
            send_res = notifier.send_batch(recipients, subject, body)
            
            # Formulate Response
            if send_res["sent"] > 0:
                result["response"] = f"✅ Email sent successfully to {send_res['sent']} recipient(s)."
                if send_res["failed"] > 0:
                    result["response"] += f" (Failed: {send_res['failed']})"
            else:
                result["response"] = f"❌ Failed to send emails. Error: {send_res['errors']}"
                
            return result
        
        # --- PATH B: SALARY CALCULATION (No Hashing) ---
        if query_type == "CALCULATE_SALARY":
            target_name = query_info.get("target_name")
            target_month = query_info.get("target_month")
            
            if not target_name:
                result["response"] = "Please specify the employee name for salary calculation."
                return result

            calc = SalaryCalculator(DB_CONFIG)
            salary_res = calc.calculate(target_name, target_month)
            
            if salary_res["status"] == "success":
                d = salary_res["data"]
                # Formulate a nice response
                resp = (f"💰 **Salary Calculation for {d['name']} ({d['type'].title()})**\n"
                        f"**Role:** {d['role']} | **Rate:** {d['currency']}{d['hourly_rate']}/hr\n"
                        f"**Worked:** {d['worked_hours']} hrs | **Paid Leave:** {d['paid_leave_hours']} hrs\n"
                        f"**Deficit:** {d['deficit']} hrs ({'Forgiven ✅' if d['deficit_forgiven'] else 'Deducted ❌'})\n"
                        f"**Total Payable:** {d['payable_hours']} hrs\n"
                        f"**Final Salary:** {d['currency']} {d['final_salary']:,}")
                result["response"] = resp
                # We can also pass raw data if we want to show a table
                result["sql_data"] = [d] 
            else:
                result["response"] = f"❌ {salary_res['message']}"
            
            return result

        # --- PATH B: ANALYTICS (With Hashing) ---
        else:
            # Execute SQL
            raw_data = execute_sql(sql_query)
            
            # 1. Anonymize
            anon_data, hash_map = anonymize_dataset(raw_data)
            if hash_map:
                print(f"🔐 [SECURITY] Masked {len(hash_map)} sensitive values.")
            
            result["sql_data"] = raw_data
            if not raw_data:
                result["response"] = "No data found."
                return result
            
            # 2. Analyze (Pass Hash Map for Charts)
            processor = AnalyticsProcessor(chart_output_dir="./charts")
            analytics_result = processor.process(query_info, anon_data, hash_map)
            
            result["analytics"] = analytics_result.get("analysis")
            result["visualization"] = analytics_result.get("visualization")
            
            # 3. De-anonymize Response
            hashed_response = analytics_result.get("natural_language_response", "")
            result["response"] = deanonymize_text(hashed_response, hash_map)
            
            return result
        
    
    except Exception as e:
        print(f"Pipeline Error: {e}")
        result["response"] = f"Error: {e}"
    
    return result
 """
def process_query(question: str) -> Dict[str, Any]:
    result = {
        "question": question, "query_info": None, "sql_query": None,
        "sql_data": [], "analytics": None, "response": "", "visualization": None
    }
    
    try:
        print("🔄 Processing...")
        query_info = sentence_to_sql(question)
        result["query_info"] = query_info
        q_type = query_info.get("query_type")
        
        # --- PATH C: SALARY CALCULATION ---
        if q_type == "CALCULATE_SALARY":
            target = query_info.get("target_name", "").replace("@", "").strip()
            target_upper = target.upper() # Normalize for checking
            month = query_info.get("target_month")
            calc = SalaryCalculator(DB_CONFIG)
            
            # --- FIX: ROBUST BULK DETECTION ---
            if target_upper in ["ALL_EMPLOYEES", "EMPLOYEES", "ALL EMPLOYEES"]:
                print("Calculating: Employees")
                res = calc.calculate_all('employee', month)
                
            elif target_upper in ["ALL_INTERNS", "INTERNS", "ALL INTERNS"]:
                print("Calculating: Interns")
                res = calc.calculate_all('intern', month)
                
            else:
                if not target:
                    result["response"] = "Please specify a name."
                    return result
                print(f"Calculating: {target}")
                res = calc.calculate(target, month)
                # Normalize single result to list for unified processing
                if res["status"] == "success":
                    res["data"] = [res["data"]]

            if res["status"] == "success":
                data_list = res["data"]
                if not data_list:
                    result["response"] = "No matching records found to calculate salary."
                else:
                    # Generate Summary Table
                    period = data_list[0]['month']
                    header = f"### Salary Report ({period})\n\n"
                    table = "| Name | Role | Worked | Payable | Final Salary |\n|---|---|---|---|---|\n"
                    

                    for d in data_list:
                        table += f"| {d['name']} | {d['role']} | {d['worked_hours']}h | {d['payable_hours']}h | **{d['currency']} {d['final_salary']:,}** |\n"
                    
                    result["response"] = header + table
                    result["sql_data"] = data_list # For frontend table
            else:
                result["response"] = f"❌ {res['message']}"
            
            return result

        # --- OTHER PATHS ---
        sql_query = query_info.get("sql_query")
        if not sql_query:
            result["response"] = "Could not understand the query."
            return result

        print(f"✅ Type: {q_type} | SQL: {sql_query}")
        
        # --- PATH A: SEND EMAIL (No Hashing) ---
        if q_type == "SEND_EMAIL":
            raw_data = execute_sql(sql_query)
            recipients = []
            for row in raw_data:
                email = row.get("official_email") or row.get("personal_email") or row.get("email")
                if email: recipients.append(email)
            
            if not recipients:
                result["response"] = "No email addresses found for those employees."
                return result

            subject = query_info.get("email_subject", "Notification from HR Bot")
            body = query_info.get("email_body", "Please check your HR portal.")
            
            print(f"📧 Sending to {len(recipients)} recipients...")
            notifier = EmailNotifier()
            send_res = notifier.send_batch(recipients, subject, body)
            
            if send_res["sent"] > 0:
                result["response"] = f"✅ Email sent successfully to {send_res['sent']} recipient(s)."
                if send_res["failed"] > 0:
                    result["response"] += f" (Failed: {send_res['failed']})"
            else:
                result["response"] = f"❌ Failed to send emails. Error: {send_res['errors']}"
            return result

        # --- PATH B: ANALYTICS (With Hashing) ---
        else:
            raw_data = execute_sql(sql_query)
            
            # 1. Anonymize
            anon_data, hash_map = anonymize_dataset(raw_data)
            if hash_map:
                print(f"🔐 [SECURITY] Masked {len(hash_map)} sensitive values.")
            
            result["sql_data"] = raw_data
            if not raw_data:
                result["response"] = "No data found."
                return result
            
            # 2. Analyze
            processor = AnalyticsProcessor(chart_output_dir="./charts")
            analytics_result = processor.process(query_info, anon_data, hash_map)
            
            result["analytics"] = analytics_result.get("analysis")
            result["visualization"] = analytics_result.get("visualization")
            
            # 3. De-anonymize Response
            hashed_response = analytics_result.get("natural_language_response", "")
            result["response"] = deanonymize_text(hashed_response, hash_map)
            
            return result
    
    except Exception as e:
        print(f"Pipeline Error: {e}")
        result["response"] = f"Error: {e}"
    
    return result
if __name__ == "__main__":
    q = input("Question: ")
    print(process_query(q)["response"])
