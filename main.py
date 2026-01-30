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
    # --- UPDATED PROMPT FOR EMAIL INTENT ---
    prompt = f"""
You are an expert MySQL query generator with intelligent query classification capabilities.

TASK 1: CLASSIFY THE QUERY TYPE
Analyze the user's question and determine if it requires:
1. DIRECT_SQL - Simple SQL query only
2. SQL_WITH_STATS - SQL + statistical analysis (variance, averages, consistency)
3. PATTERN_DETECTION - Pattern recognition (seasonal, behavioral)
4. ANOMALY_DETECTION - Unusual behavior detection
5. TREND_ANALYSIS - Time-based trends (improving/declining)
6. COMPARISON - Employee vs employee or entity comparison

TASK 2: GENERATE SQL (if applicable)
If the query needs data from database, generate ONLY valid MySQL 8+ SQL.

TASK 3: SPECIFY ADDITIONAL ANALYSIS (if needed)
List what post-SQL processing is required.

OUTPUT FORMAT (JSON):
{{
  "query_type": "DIRECT_SQL|SQL_WITH_STATS|PATTERN_DETECTION|ANOMALY_DETECTION|TREND_ANALYSIS|COMPARISON",
  "sql_query": "SELECT ... (or null if no SQL needed)",
  "analysis_required": ["variance", "trend", "anomaly", "consistency", "pattern", "seasonal_pattern"],
  "metric": "attendance|punctuality|work_hours|leaves",
  "time_period": "last_month|last_quarter|last_year",
  "employee_ids": [],
  "visualization": "line_chart|bar_chart|heatmap|pie_chart|null"
}}

STRICT RULES:
- Output ONLY valid JSON
- SQL must be valid MySQL 8+ syntax
- No markdown, no comments, no explanations
- CRITICAL: All non-aggregated columns in SELECT must be included in GROUP BY (MySQL ONLY_FULL_GROUP_BY mode)
- When looking up a person by name, use LOWER(first_name) = LOWER('name') for case-insensitive matching
- attendance_records.employee_id references employees.uuid (NOT employees.employee_id)
- intern_attendance_records.intern_id references interns.uuid (NOT interns.intern_id)
- Use: (SELECT uuid FROM employees WHERE LOWER(first_name) = LOWER('name')) for employee lookups
- Use: (SELECT uuid FROM interns WHERE LOWER(first_name) = LOWER('name')) for intern lookups

DATABASE SCHEMA:

attendance_records(
  uuid, employee_id, date,
  check_in_time, check_out_time,
  status, leave_deducted
)

categories(
  uuid, name, description
)

designation(
  uuid, designation, employee_id
)

employees(
  uuid, employee_id, profile_image,
  first_name, last_name,
  official_email, password,
  is_mfa_enabled, contact_no,
  personal_email, pan_number,
  date_of_joining,
  system_role, job_role,
  date_of_relieving
)

employees_skills(
  uuid, employee_id,
  technology_ids, level
)

employee_designation(
  id
)

employee_skill_technologies(
  id, employee_skill_id,
  technology_id
)

holidays(
  uuid, name, date, description
)

interns(
  uuid, intern_id, profile_image,
  first_name, last_name,
  personal_email, contact_no,
  role, status,
  university_name, department,
  date_of_joining, date_of_relieving
)

interns_skills(
  uuid, intern_id,
  technology_ids, level
)

intern_attendance_records(
  uuid, intern_id, date,
  check_in_time, check_out_time,
  status, leave_deducted
)

intern_leaves(
  uuid, intern_id,
  request_type, type,
  start_date, end_date,
  days, status
)

intern_projects(
  uuid, intern_uuid,
  project_uuid, project_features
)

leaves(
  uuid, employee_id,
  request_type, type,
  start_date, end_date,
  days, status
)

notice_boards(
  uuid, description, created_by
)

projects(
  uuid, employee_id,
  name, market,
  description,
  project_status,
  billing_or_buffer
)

technologies(
  uuid, technology_name,
  category_id
)

QUESTION: {sentence}

OUTPUT JSON FORMAT:
{{
  "query_type": "SEND_EMAIL" | "DIRECT_SQL" | "TREND_ANALYSIS",
  "sql_query": "SELECT official_email FROM ...",
  "email_subject": "Warning" (Only for email type),
  "email_body": "Your attendance is low..." (Only for email type)
}}
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
def process_query(question: str) -> Dict[str, Any]:
    result = {
        "question": question, "query_info": None, "sql_query": None,
        "sql_data": [], "analytics": None, "response": "", "visualization": None
    }
    
    try:
        print("🔄 Processing question...")
        
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

if __name__ == "__main__":
    q = input("Question: ")
    print(process_query(q)["response"])
