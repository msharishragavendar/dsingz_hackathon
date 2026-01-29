"""
Report Generator
Generate weekly and monthly analytics reports.
"""

from typing import Dict, Any, List
from datetime import datetime, timedelta
import os
import mysql.connector

try:
    from config import DB_CONFIG, REPORT_CONFIG
except ImportError:
    DB_CONFIG = {
        "host": "localhost",
        "user": "root",
        "password": "data@123",
        "database": "dsingz"
    }
    REPORT_CONFIG = {
        "output_dir": "./reports",
        "chart_dir": "./charts"
    }


class ReportGenerator:
    """Generate weekly and monthly analytics reports."""
    
    def __init__(self):
        self.db_config = DB_CONFIG
        self.output_dir = REPORT_CONFIG.get('output_dir', './reports')
        
        # Ensure output directory exists
        os.makedirs(self.output_dir, exist_ok=True)
    
    def generate_weekly_report(self) -> Dict[str, Any]:
        """Generate weekly attendance and performance report."""
        end_date = datetime.now().date()
        start_date = end_date - timedelta(days=7)
        
        report = {
            "type": "weekly",
            "period": f"{start_date} to {end_date}",
            "generated_at": datetime.now().isoformat(),
            "sections": {}
        }
        
        conn = mysql.connector.connect(**self.db_config)
        cursor = conn.cursor(dictionary=True)
        
        try:
            # Attendance Summary
            cursor.execute("""
                SELECT 
                    status,
                    COUNT(*) as count
                FROM attendance_records
                WHERE date BETWEEN %s AND %s
                AND deleted_at IS NULL
                GROUP BY status
            """, (start_date, end_date))
            
            attendance_stats = {row['status']: row['count'] for row in cursor.fetchall()}
            total = sum(attendance_stats.values())
            
            report['sections']['attendance'] = {
                "total_records": total,
                "present": attendance_stats.get('present', 0),
                "absent": attendance_stats.get('absent', 0),
                "late": attendance_stats.get('late', 0),
                "leave": attendance_stats.get('leave', 0),
                "wfh": attendance_stats.get('work_from_home', 0),
                "attendance_rate": round(
                    (attendance_stats.get('present', 0) + attendance_stats.get('work_from_home', 0)) / max(total, 1) * 100, 2
                )
            }
            
            # Leave Summary
            cursor.execute("""
                SELECT 
                    status,
                    type,
                    COUNT(*) as count,
                    SUM(days) as total_days
                FROM leaves
                WHERE created_at BETWEEN %s AND %s
                AND deleted_at IS NULL
                GROUP BY status, type
            """, (start_date, end_date))
            
            leave_data = cursor.fetchall()
            report['sections']['leaves'] = {
                "new_requests": sum(row['count'] for row in leave_data),
                "total_days": sum(row['total_days'] or 0 for row in leave_data),
                "by_status": {}
            }
            
            for row in leave_data:
                status = row['status']
                if status not in report['sections']['leaves']['by_status']:
                    report['sections']['leaves']['by_status'][status] = 0
                report['sections']['leaves']['by_status'][status] += row['count']
            
            # Top performers (most present)
            cursor.execute("""
                SELECT 
                    e.first_name,
                    e.last_name,
                    COUNT(CASE WHEN ar.status = 'present' THEN 1 END) as present_days
                FROM employees e
                JOIN attendance_records ar ON e.uuid = ar.employee_id
                WHERE ar.date BETWEEN %s AND %s
                AND ar.deleted_at IS NULL
                GROUP BY e.uuid, e.first_name, e.last_name
                ORDER BY present_days DESC
                LIMIT 5
            """, (start_date, end_date))
            
            report['sections']['top_performers'] = cursor.fetchall()
            
        finally:
            cursor.close()
            conn.close()
        
        # Generate text report
        report['text_report'] = self._format_weekly_text(report)
        
        # Save report
        filename = f"weekly_report_{end_date.strftime('%Y%m%d')}.txt"
        filepath = os.path.join(self.output_dir, filename)
        with open(filepath, 'w') as f:
            f.write(report['text_report'])
        
        report['filepath'] = filepath
        return report
    
    def generate_monthly_report(self) -> Dict[str, Any]:
        """Generate monthly analytics report."""
        end_date = datetime.now().date()
        start_date = end_date.replace(day=1)
        
        report = {
            "type": "monthly",
            "month": end_date.strftime('%B %Y'),
            "period": f"{start_date} to {end_date}",
            "generated_at": datetime.now().isoformat(),
            "sections": {}
        }
        
        conn = mysql.connector.connect(**self.db_config)
        cursor = conn.cursor(dictionary=True)
        
        try:
            # Monthly attendance by employee
            cursor.execute("""
                SELECT 
                    e.first_name,
                    e.last_name,
                    COUNT(*) as total_days,
                    SUM(CASE WHEN ar.status = 'present' THEN 1 ELSE 0 END) as present_days,
                    SUM(CASE WHEN ar.status = 'late' THEN 1 ELSE 0 END) as late_days,
                    SUM(CASE WHEN ar.status = 'absent' THEN 1 ELSE 0 END) as absent_days
                FROM employees e
                LEFT JOIN attendance_records ar ON e.uuid = ar.employee_id
                    AND ar.date BETWEEN %s AND %s
                    AND ar.deleted_at IS NULL
                WHERE e.deleted_at IS NULL
                GROUP BY e.uuid, e.first_name, e.last_name
            """, (start_date, end_date))
            
            report['sections']['employee_attendance'] = cursor.fetchall()
            
            # Monthly leave consumption
            cursor.execute("""
                SELECT 
                    e.first_name,
                    e.last_name,
                    SUM(l.days) as total_leave_days
                FROM employees e
                JOIN leaves l ON e.uuid = l.employee_id
                WHERE l.status = 'approved'
                AND l.start_date BETWEEN %s AND %s
                AND l.deleted_at IS NULL
                GROUP BY e.uuid, e.first_name, e.last_name
                ORDER BY total_leave_days DESC
            """, (start_date, end_date))
            
            report['sections']['leave_consumption'] = cursor.fetchall()
            
            # Project activity
            cursor.execute("""
                SELECT 
                    project_status,
                    COUNT(*) as count
                FROM projects
                WHERE deleted_at IS NULL
                GROUP BY project_status
            """)
            
            report['sections']['project_status'] = cursor.fetchall()
            
        finally:
            cursor.close()
            conn.close()
        
        # Generate text report
        report['text_report'] = self._format_monthly_text(report)
        
        # Save report
        filename = f"monthly_report_{end_date.strftime('%Y%m')}.txt"
        filepath = os.path.join(self.output_dir, filename)
        with open(filepath, 'w') as f:
            f.write(report['text_report'])
        
        report['filepath'] = filepath
        return report
    
    def _format_weekly_text(self, report: Dict) -> str:
        """Format weekly report as text."""
        text = f"""
================================================================================
                     WEEKLY ANALYTICS REPORT
                     {report['period']}
================================================================================

📊 ATTENDANCE SUMMARY
---------------------
Total Records: {report['sections']['attendance']['total_records']}
Attendance Rate: {report['sections']['attendance']['attendance_rate']}%

• Present: {report['sections']['attendance']['present']}
• Absent: {report['sections']['attendance']['absent']}
• Late: {report['sections']['attendance']['late']}
• On Leave: {report['sections']['attendance']['leave']}
• Work from Home: {report['sections']['attendance']['wfh']}

📋 LEAVE REQUESTS
-----------------
New Requests: {report['sections']['leaves']['new_requests']}
Total Days: {report['sections']['leaves']['total_days']}

🏆 TOP PERFORMERS
-----------------
"""
        for i, emp in enumerate(report['sections'].get('top_performers', []), 1):
            text += f"{i}. {emp['first_name']} {emp['last_name']} - {emp['present_days']} days present\n"
        
        text += f"""
================================================================================
Generated: {report['generated_at']}
================================================================================
"""
        return text
    
    def _format_monthly_text(self, report: Dict) -> str:
        """Format monthly report as text."""
        text = f"""
================================================================================
                     MONTHLY ANALYTICS REPORT
                     {report['month']}
================================================================================

📊 EMPLOYEE ATTENDANCE
----------------------
"""
        for emp in report['sections'].get('employee_attendance', [])[:10]:
            text += f"• {emp['first_name']} {emp['last_name']}: "
            text += f"{emp.get('present_days', 0)}/{emp.get('total_days', 0)} days present\n"
        
        text += """
📋 LEAVE CONSUMPTION (Top 5)
----------------------------
"""
        for emp in report['sections'].get('leave_consumption', [])[:5]:
            text += f"• {emp['first_name']} {emp['last_name']}: {emp['total_leave_days']} days\n"
        
        text += """
📁 PROJECT STATUS
-----------------
"""
        for proj in report['sections'].get('project_status', []):
            text += f"• {proj['project_status']}: {proj['count']} projects\n"
        
        text += f"""
================================================================================
Generated: {report['generated_at']}
================================================================================
"""
        return text
