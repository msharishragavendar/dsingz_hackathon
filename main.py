"""
NL2SQL with AI/ML Analytics Engine
Complete pipeline: Natural Language → SQL → MySQL → Analytics → Response
"""

import requests
import json
import re
import mysql.connector
from typing import Dict, Any, List, Optional
from datetime import datetime

from analytics import AnalyticsProcessor
from analytics.nl_response_generator import NLResponseGenerator
from analytics.profile_engine import ProfileEngine


# =========================
# CONFIG
# =========================
OPENROUTER_API_KEY = "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"  # Replace with your key
MODEL = "deepseek/deepseek-chat"
OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"

DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "kavin@123",
    "database": "dsingz"
}


# =========================
# SQL SAFETY VALIDATION
# =========================
def validate_sql(sql: str) -> str:
    """Block dangerous SQL operations."""
    forbidden = ["delete", "drop", "truncate", "update", "alter", "insert"]
    sql_lower = sql.lower()
    for word in forbidden:
        if word in sql_lower:
            raise ValueError(f"❌ Dangerous SQL blocked: {word}")
    return sql


# =========================
# EXTRACT SQL FROM LLM OUTPUT
# =========================
def extract_query_info(raw_output: str) -> Dict[str, Any]:
    """
    Extract query information from LLM output.
    Returns dict with query_type, sql_query, analysis_required, etc.
    """
    raw_output = raw_output.strip()
    
    # Remove markdown code blocks if present
    if raw_output.startswith("```"):
        raw_output = re.sub(r'^```\w*\n?', '', raw_output)
        raw_output = re.sub(r'\n?```$', '', raw_output)
    
    # Try direct JSON parsing
    try:
        return json.loads(raw_output)
    except json.JSONDecodeError:
        pass
    
    # Try extracting JSON block
    match = re.search(r'\{[\s\S]*\}', raw_output)
    if match:
        try:
            return json.loads(match.group())
        except json.JSONDecodeError:
            pass
    
    # Fallback - return as direct SQL
    return {
        "query_type": "DIRECT_SQL",
        "sql_query": raw_output,
        "analysis_required": [],
        "visualization": None
    }


# =========================
# SENTENCE → SQL (LLM)
# =========================
def sentence_to_sql(sentence: str) -> Dict[str, Any]:
    """
    Convert natural language to SQL with query classification.
    Returns structured query info including analysis requirements.
    """
    prompt = f"""
You are an expert MySQL query generator with intelligent query classification capabilities.

TASK 1: CLASSIFY THE QUERY TYPE
Analyze the user's question and determine if it requires:
1. DIRECT_SQL - Simple SQL query only
2. SQL_WITH_STATS - SQL + statistical analysis (variance, averages, consistency)
3. PATTERN_DETECTION - Pattern recognition (seasonal, behavioral)
4. ANOMALY_DETECTION - Unusual behavior detection
5. TREND_ANALYSIS - Time-based trends (improving/declining)
5. TREND_ANALYSIS - Time-based trends (improving/declining)
6. COMPARISON - Employee vs employee or entity comparison
7. PERSON_PROFILE - specific questions about a person's details, skills, or history

TASK 2: GENERATE SQL (if applicable)
If the query needs data from database, generate ONLY valid MySQL 8+ SQL.

TASK 3: SPECIFY ADDITIONAL ANALYSIS (if needed)
List what post-SQL processing is required.

OUTPUT FORMAT (JSON):
{{
  "query_type": "DIRECT_SQL|SQL_WITH_STATS|PATTERN_DETECTION|ANOMALY_DETECTION|TREND_ANALYSIS|COMPARISON|PERSON_PROFILE",
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
- Use: (SELECT uuid FROM employees WHERE LOWER(first_name) = LOWER('name')) for employee lookups
- Use: (SELECT uuid FROM interns WHERE LOWER(first_name) = LOWER('name')) for intern lookups
- For PERSON_PROFILE: Generate SQL to fetch ONLY the uuid of the person (e.g. SELECT uuid FROM employees WHERE first_name... LIMIT 1)

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

QUESTION:
{sentence}
"""

    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "Content-Type": "application/json",
        "HTTP-Referer": "http://localhost",
        "X-Title": "NL2SQL Analytics"
    }

    payload = {
        "model": MODEL,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0
    }

    response = requests.post(OPENROUTER_URL, headers=headers, json=payload)
    response.raise_for_status()

    raw_output = response.json()["choices"][0]["message"]["content"]
    return extract_query_info(raw_output)


# =========================
# EXECUTE SQL
# =========================
def execute_sql(sql_query: str) -> List[Dict[str, Any]]:
    """Execute SQL query and return results."""
    conn = None
    cursor = None
    try:
        validate_sql(sql_query)
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor(dictionary=True)
        cursor.execute(sql_query)
        rows = cursor.fetchall()
        
        # Convert any non-serializable types
        cleaned_rows = []
        for row in rows:
            cleaned_row = {}
            for key, value in row.items():
                if isinstance(value, datetime):
                    cleaned_row[key] = value.isoformat()
                elif hasattr(value, 'total_seconds'):  # timedelta
                    cleaned_row[key] = value.total_seconds() / 3600  # Convert to hours
                else:
                    cleaned_row[key] = value
            cleaned_rows.append(cleaned_row)
        
        return cleaned_rows

    except mysql.connector.Error as err:
        print(f"❌ MySQL Error: {err}")
        return []
    except ValueError as err:
        print(str(err))
        return []
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()


# =========================
# MAIN PIPELINE
# =========================
def process_query(question: str) -> Dict[str, Any]:
    """
    Complete pipeline: NL → SQL → Execute → Analytics → Response
    """
    result = {
        "question": question,
        "query_info": None,
        "sql_query": None,
        "sql_data": [],
        "analytics": None,
        "response": "",
        "visualization": None
    }
    
    try:
        # Step 1: Convert NL to SQL with classification
        print("🔄 Processing your question...")
        query_info = sentence_to_sql(question)
        result["query_info"] = query_info
        
        sql_query = query_info.get("sql_query")
        if sql_query:
            result["sql_query"] = sql_query
            print(f"✅ GENERATED SQL:\n {sql_query}")
            
            # Step 2: Execute SQL
            sql_data = execute_sql(sql_query)
            result["sql_data"] = sql_data
            
            # Special handling for PERSON_PROFILE
            if query_info.get("query_type") == "PERSON_PROFILE" and sql_data:
                person_uuid = sql_data[0].get("uuid")
                if person_uuid:
                    print(f"👤 Generating profile for UUID: {person_uuid}")
                    
                    # Initialize engines
                    prof_engine = ProfileEngine(DB_CONFIG)
                    profile_data = prof_engine.get_profile_data(person_uuid)
                    
                    # Generate dashboard
                    processor = AnalyticsProcessor(chart_output_dir="./charts") # Reuse/New instance
                    viz_result = processor.visualizer.create_profile_dashboard(profile_data)
                    result["visualization"] = viz_result
                    result["profile_data"] = profile_data
                    
                    # Generate text response
                    basic = profile_data.get("basic_info", {})
                    stats = profile_data.get("attendance_stats", {})
                    
                    result["response"] = (
                        f"Here is the profile for {basic.get('first_name')} {basic.get('last_name')}. "
                        f"They work as a {basic.get('job_role')} and joined on {basic.get('date_of_joining')}. "
                        f"Their current attendance rate is {stats.get('attendance_rate')}% with {stats.get('present')} present days. "
                        f"I've generated a visual dashboard with more details."
                    )
                    return result
            
            if not sql_data:
                result["response"] = "No data found for your query."
                return result
            
            # Step 3: Run analytics
            processor = AnalyticsProcessor(chart_output_dir="./charts")
            analytics_result = processor.process(query_info, sql_data)
            
            result["analytics"] = analytics_result.get("analysis")
            result["visualization"] = analytics_result.get("visualization")
            
            # Step 4: Generate natural language response
            nl_generator = NLResponseGenerator(OPENROUTER_API_KEY, OPENROUTER_URL)
            result["response"] = nl_generator.generate(
                query_info, sql_data, result["analytics"]
            )
        else:
            result["response"] = "Could not generate SQL for your question."
    
    except requests.exceptions.HTTPError as e:
        result["response"] = f"❌ API Error: {e}"
    except Exception as e:
        result["response"] = f"❌ Error: {e}"
    
    return result


# =========================
# CLI INTERFACE
# =========================
def main():
    """Interactive CLI for testing."""
    print("=" * 50)
    print("🧠 NL2SQL with AI/ML Analytics Engine")
    print("=" * 50)
    print("\nType your question (or 'quit' to exit)\n")
    
    while True:
        try:
            question = input("📝 Question: ").strip()
            
            if not question:
                continue
            if question.lower() in ['quit', 'exit', 'q']:
                print("👋 Goodbye!")
                break
            
            result = process_query(question)
            
            print("\n" + "-" * 40)
            
            # Handle case where query_info might be None
            query_info = result.get('query_info') or {}
            print(f"📊 QUERY TYPE: {query_info.get('query_type', 'N/A')}")
            
            if result['sql_data']:
                print(f"📋 RECORDS: {len(result['sql_data'])}")
                
                # Show first few records
                for i, row in enumerate(result['sql_data'][:5]):
                    print(f"   {i+1}. {row}")
                if len(result['sql_data']) > 5:
                    print(f"   ... and {len(result['sql_data']) - 5} more")
            
            print(f"\n💡 RESPONSE: {result['response']}")
            
            if result['visualization'] and result['visualization'].get('status') == 'success':
                print(f"📈 CHART: {result['visualization'].get('filepath')}")
            
            print("-" * 40 + "\n")
            
        except KeyboardInterrupt:
            print("\n👋 Goodbye!")
            break
        except Exception as e:
            print(f"❌ Error: {e}\n")


if __name__ == "__main__":
    main()
