"""
Leave Balance Tracker
Track employee leave balances and detect low balance conditions.
"""

from typing import Dict, Any, List
from datetime import datetime, date
import mysql.connector

try:
    from config import DB_CONFIG, LEAVE_POLICY
except ImportError:
    DB_CONFIG = {
        "host": "localhost",
        "user": "root",
        "password": "data@123",
        "database": "dsingz"
    }
    LEAVE_POLICY = {
        "annual_leave_days": 24,
        "sick_leave_days": 12,
        "personal_leave_days": 5,
        "low_balance_threshold": 3,
        "alert_enabled": True
    }


class LeaveTracker:
    """Track and manage employee leave balances."""
    
    def __init__(self):
        self.db_config = DB_CONFIG
        self.policy = LEAVE_POLICY
    
    def get_employee_leave_balance(self, employee_uuid: str) -> Dict[str, Any]:
        """Get leave balance for a specific employee."""
        conn = mysql.connector.connect(**self.db_config)
        cursor = conn.cursor(dictionary=True)
        
        try:
            # Get employee info
            cursor.execute("""
                SELECT uuid, employee_id, first_name, last_name, official_email, date_of_joining
                FROM employees WHERE uuid = %s AND deleted_at IS NULL
            """, (employee_uuid,))
            employee = cursor.fetchone()
            
            if not employee:
                return {"error": "Employee not found"}
            
            # Get approved leaves taken this year
            current_year = datetime.now().year
            cursor.execute("""
                SELECT type, SUM(days) as total_days
                FROM leaves
                WHERE employee_id = %s 
                AND status = 'approved'
                AND YEAR(start_date) = %s
                AND deleted_at IS NULL
                GROUP BY type
            """, (employee_uuid, current_year))
            
            leaves_taken = {row['type']: row['total_days'] for row in cursor.fetchall()}
            
            # Calculate balances
            annual_taken = leaves_taken.get('planned', 0) 
            sick_taken = leaves_taken.get('sick', 0)
            half_day_taken = (leaves_taken.get('first_half', 0) + leaves_taken.get('second_half', 0)) / 2
            
            balance = {
                "employee": employee,
                "year": current_year,
                "annual_leave": {
                    "allocated": self.policy['annual_leave_days'],
                    "taken": annual_taken + half_day_taken,
                    "remaining": self.policy['annual_leave_days'] - annual_taken - half_day_taken
                },
                "sick_leave": {
                    "allocated": self.policy['sick_leave_days'],
                    "taken": sick_taken,
                    "remaining": self.policy['sick_leave_days'] - sick_taken
                },
                "total_remaining": (
                    self.policy['annual_leave_days'] - annual_taken - half_day_taken +
                    self.policy['sick_leave_days'] - sick_taken
                )
            }
            
            # Check for low balance
            balance["low_balance_alert"] = any([
                balance["annual_leave"]["remaining"] <= self.policy['low_balance_threshold'],
                balance["sick_leave"]["remaining"] <= self.policy['low_balance_threshold']
            ])
            
            return balance
            
        finally:
            cursor.close()
            conn.close()
    
    def get_all_leave_balances(self) -> List[Dict[str, Any]]:
        """Get leave balances for all active employees."""
        conn = mysql.connector.connect(**self.db_config)
        cursor = conn.cursor(dictionary=True)
        
        try:
            cursor.execute("""
                SELECT uuid FROM employees 
                WHERE deleted_at IS NULL AND date_of_relieving IS NULL
            """)
            employees = cursor.fetchall()
            
            balances = []
            for emp in employees:
                balance = self.get_employee_leave_balance(emp['uuid'])
                if 'error' not in balance:
                    balances.append(balance)
            
            return balances
        finally:
            cursor.close()
            conn.close()
    
    def get_low_balance_employees(self) -> List[Dict[str, Any]]:
        """Get employees with low leave balance for alerts."""
        all_balances = self.get_all_leave_balances()
        return [b for b in all_balances if b.get('low_balance_alert')]
    
    def get_pending_leave_requests(self, employee_uuid: str = None) -> List[Dict]:
        """Get pending leave requests."""
        conn = mysql.connector.connect(**self.db_config)
        cursor = conn.cursor(dictionary=True)
        
        try:
            query = """
                SELECT 
                    l.uuid, l.employee_id, l.request_type, l.type,
                    l.start_date, l.end_date, l.days, l.status, l.reason,
                    e.first_name, e.last_name, e.official_email
                FROM leaves l
                JOIN employees e ON l.employee_id = e.uuid
                WHERE l.status = 'pending' AND l.deleted_at IS NULL
            """
            params = []
            
            if employee_uuid:
                query += " AND l.employee_id = %s"
                params.append(employee_uuid)
            
            query += " ORDER BY l.created_at DESC"
            
            cursor.execute(query, params)
            return cursor.fetchall()
        finally:
            cursor.close()
            conn.close()
    
    def get_upcoming_leaves(self, days: int = 7) -> List[Dict]:
        """Get leaves starting in the next N days."""
        conn = mysql.connector.connect(**self.db_config)
        cursor = conn.cursor(dictionary=True)
        
        try:
            cursor.execute("""
                SELECT 
                    l.*, e.first_name, e.last_name, e.official_email
                FROM leaves l
                JOIN employees e ON l.employee_id = e.uuid
                WHERE l.status = 'approved'
                AND l.start_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL %s DAY)
                AND l.deleted_at IS NULL
                ORDER BY l.start_date
            """, (days,))
            return cursor.fetchall()
        finally:
            cursor.close()
            conn.close()
    
    def generate_balance_report(self) -> str:
        """Generate a text report of all leave balances."""
        balances = self.get_all_leave_balances()
        
        if not balances:
            return "No employee data available."
        
        report = "📋 **Leave Balance Report**\n"
        report += f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M')}\n\n"
        
        low_balance = []
        
        for b in balances:
            emp = b['employee']
            annual = b['annual_leave']
            sick = b['sick_leave']
            
            status = "⚠️" if b['low_balance_alert'] else "✅"
            report += f"{status} **{emp['first_name']} {emp['last_name']}**\n"
            report += f"   Annual: {annual['remaining']}/{annual['allocated']} remaining\n"
            report += f"   Sick: {sick['remaining']}/{sick['allocated']} remaining\n\n"
            
            if b['low_balance_alert']:
                low_balance.append(f"{emp['first_name']} {emp['last_name']}")
        
        if low_balance:
            report += f"\n🚨 **Employees with low balance:** {', '.join(low_balance)}"
        
        return report
