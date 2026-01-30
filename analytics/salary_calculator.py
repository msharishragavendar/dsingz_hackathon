"""
Salary Calculator Engine
Calculates monthly salary based on attendance, leaves, and configurable rules.
"""

import json
import mysql.connector
from datetime import datetime
import os

class SalaryCalculator:
    def __init__(self, db_config):
        self.db_config = db_config
        self.settings_file = "salary_config.json"
        self.load_settings()

    def load_settings(self):
        """Load rates and rules from JSON."""
        if os.path.exists(self.settings_file):
            with open(self.settings_file, 'r') as f:
                self.config = json.load(f)
        else:
            self.config = {
                "rates": {"intern": 50, "employee": 100, "expert": 200},
                "rules": {"max_full_leaves": 1, "max_half_leaves": 2, "deficit_threshold": 1, "expected_hours": 160}
            }

    def _get_connection(self):
        return mysql.connector.connect(**self.db_config)

    def _compute_salary_for_user(self, cursor, user, month_val, year_val):
        """Core logic to calculate salary for a single user record."""
        user_uuid = user['uuid']
        user_type = user['type']
        
        # 1. Determine Rate
        role = str(user.get('job_role', '')).lower()
        rates = self.config['rates']
        
        if user_type == 'intern':
            hourly_rate = rates['intern']
        elif 'expert' in role:
            hourly_rate = rates['expert']
        else:
            hourly_rate = rates['employee']

        # 2. Fetch Attendance (Worked Hours)
        table = "attendance_records" if user_type == "employee" else "intern_attendance_records"
        id_col = "employee_id" if user_type == "employee" else "intern_id"
        
        sql_hours = f"""
            SELECT SUM(TIMESTAMPDIFF(HOUR, check_in_time, check_out_time)) as total_hours
            FROM {table}
            WHERE {id_col} = '{user_uuid}'
            AND MONTH(date) = {month_val} AND YEAR(date) = {year_val}
            AND status IN ('present', 'late', 'work_from_home')
        """
        cursor.execute(sql_hours)
        result_hours = cursor.fetchone()
        worked_hours = float(result_hours['total_hours']) if result_hours and result_hours['total_hours'] else 0.0

        # 3. Fetch Approved Leaves
        leave_table = "leaves" if user_type == "employee" else "intern_leaves"
        
        sql_leaves = f"""
            SELECT type, COUNT(*) as count
            FROM {leave_table}
            WHERE {id_col} = '{user_uuid}'
            AND status = 'approved'
            AND (MONTH(start_date) = {month_val} OR MONTH(end_date) = {month_val})
            GROUP BY type
        """
        cursor.execute(sql_leaves)
        leave_counts = {row['type']: row['count'] for row in cursor.fetchall()}
        
        # Apply Policy
        rules = self.config['rules']
        paid_leave_hours = 0
        full_taken = leave_counts.get('planned', 0) + leave_counts.get('sick', 0)
        half_taken = leave_counts.get('first_half', 0) + leave_counts.get('second_half', 0)
        
        if full_taken > 0:
            paid_leave_hours = min(full_taken, rules['max_full_leaves']) * 8
        elif half_taken > 0:
            paid_leave_hours += min(half_taken, rules['max_half_leaves']) * 4

        # 4. Deficit & Final
        expected = rules['expected_hours']
        total_actual = worked_hours + paid_leave_hours
        deficit = max(0, expected - total_actual)
        
        threshold = rules['deficit_threshold']
        deficit_forgiven = False
        if deficit > 0 and deficit <= threshold:
            deficit_forgiven = True
        
        payable_hours = worked_hours + paid_leave_hours
        if deficit_forgiven:
            payable_hours += deficit
        
        final_salary = payable_hours * hourly_rate
        
        return {
            "name": f"{user.get('first_name','')} {user.get('last_name','')}".strip(),
            "role": role,
            "type": user_type,
            "hourly_rate": hourly_rate,
            "worked_hours": round(worked_hours, 2),
            "paid_leave_hours": paid_leave_hours,
            "deficit": round(deficit, 2),
            "deficit_forgiven": deficit_forgiven,
            "payable_hours": round(payable_hours, 2),
            "final_salary": round(final_salary, 2),
            "currency": "₹"
        }

    def _get_date_params(self, month_str):
        if month_str:
            try:
                dt = datetime.strptime(month_str, "%Y-%m")
                return dt.month, dt.year, dt.strftime("%B %Y")
            except:
                return None, None, None
        now = datetime.now()
        return now.month, now.year, now.strftime("%B %Y")

    def calculate(self, name_query: str, month_str: str = None) -> dict:
        """Calculate for a single user by name."""
        conn = self._get_connection()
        cursor = conn.cursor(dictionary=True)
        try:
            m, y, display_month = self._get_date_params(month_str)
            if not m: return {"status": "error", "message": "Invalid date format. Use YYYY-MM."}

            clean_name = name_query.replace("@", "").strip()
            
            # Find User
            sql_emp = f"SELECT uuid, first_name, last_name, job_role, 'employee' as type FROM employees WHERE LOWER(CONCAT(first_name, ' ', last_name)) LIKE LOWER('%{clean_name}%') LIMIT 1"
            cursor.execute(sql_emp)
            user = cursor.fetchone()
            
            if not user:
                sql_int = f"SELECT uuid, first_name, last_name, role as job_role, 'intern' as type FROM interns WHERE LOWER(CONCAT(first_name, ' ', last_name)) LIKE LOWER('%{clean_name}%') LIMIT 1"
                cursor.execute(sql_int)
                user = cursor.fetchone()
            
            if not user:
                return {"status": "error", "message": f"User '{name_query}' not found."}

            data = self._compute_salary_for_user(cursor, user, m, y)
            data['month'] = display_month
            return {"status": "success", "data": data}

        except Exception as e:
            return {"status": "error", "message": str(e)}
        finally:
            if cursor: cursor.close()
            conn.close()

    def calculate_all(self, user_type: str, month_str: str = None) -> dict:
        """Calculate salary for ALL users of a specific type ('employee' or 'intern')."""
        conn = self._get_connection()
        cursor = conn.cursor(dictionary=True)
        try:
            m, y, display_month = self._get_date_params(month_str)
            if not m: return {"status": "error", "message": "Invalid date format."}

            if user_type == 'employee':
                sql = "SELECT uuid, first_name, last_name, job_role, 'employee' as type FROM employees"
            else:
                sql = "SELECT uuid, first_name, last_name, role as job_role, 'intern' as type FROM interns"
            
            cursor.execute(sql)
            users = cursor.fetchall()
            
            results = []
            for user in users:
                data = self._compute_salary_for_user(cursor, user, m, y)
                data['month'] = display_month
                results.append(data)
                
            return {"status": "success", "data": results, "count": len(results)}

        except Exception as e:
            return {"status": "error", "message": str(e)}
        finally:
            if cursor: cursor.close()
            conn.close()