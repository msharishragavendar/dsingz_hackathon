"""
Profile Engine
Aggregates comprehensive data for a person (attendance, skills, projects)
"""

from typing import Dict, Any, List
import mysql.connector
from datetime import datetime

class ProfileEngine:
    """Aggregates data for a person profile."""
    
    def __init__(self, db_config: Dict[str, Any]):
        self.db_config = db_config
        
    def _get_connection(self):
        return mysql.connector.connect(**self.db_config)
    
    def get_profile_data(self, uuid: str) -> Dict[str, Any]:
        """
        Fetch all profile data for a given employee UUID.
        """
        data = {
            "uuid": uuid,
            "basic_info": {},
            "attendance_stats": {},
            "skills": [],
            "projects": []
        }
        
        conn = None
        try:
            conn = self._get_connection()
            cursor = conn.cursor(dictionary=True)
            
            # 1. Basic Info
            sql_basic = """
                SELECT 
                    first_name, last_name, official_email, contact_no,
                    designation.designation as job_role,
                    date_of_joining, profile_image
                FROM employees
                LEFT JOIN designation ON employees.job_role = designation.uuid
                WHERE employees.uuid = %s
            """
            cursor.execute(sql_basic, (uuid,))
            basic = cursor.fetchone()
            if basic:
                # Convert dates
                if isinstance(basic.get('date_of_joining'), datetime) or hasattr(basic.get('date_of_joining'), 'isoformat'):
                     basic['date_of_joining'] = str(basic['date_of_joining'])
                data["basic_info"] = basic
                
            # 2. Attendance Stats (Summary)
            # Count presence, late, leaves
            sql_attend = """
                SELECT status, COUNT(*) as count 
                FROM attendance_records 
                WHERE employee_id = %s 
                GROUP BY status
            """
            cursor.execute(sql_attend, (uuid,))
            attend_rows = cursor.fetchall()
            
            total_days = 0
            stats = {"present": 0, "late": 0, "absent": 0, "leave": 0, "wfh": 0}
            
            for row in attend_rows:
                status = row['status'].lower()
                count = row['count']
                total_days += count
                
                if 'present' in status: stats['present'] += count
                elif 'late' in status: stats['late'] += count
                elif 'absent' in status: stats['absent'] += count
                elif 'leave' in status: stats['leave'] += count
                elif 'work_from_home' in status: stats['wfh'] += count
            
            stats['total_days'] = total_days
            if total_days > 0:
                stats['attendance_rate'] = round(((stats['present'] + stats['late'] + stats['wfh']) / total_days) * 100, 1)
            else:
                stats['attendance_rate'] = 0
                
            data["attendance_stats"] = stats
            
            # 3. Skills
            sql_skills = """
                SELECT t.technology_name, es.level
                FROM employees_skills es
                JOIN technologies t ON es.technology_ids = t.uuid
                WHERE es.employee_id = %s
            """
            cursor.execute(sql_skills, (uuid,))
            data["skills"] = cursor.fetchall()
            
            # 4. Projects
            sql_projects = """
                SELECT name, project_status, description
                FROM projects
                WHERE employee_id = %s
            """
            cursor.execute(sql_projects, (uuid,))
            data["projects"] = cursor.fetchall()
            
            # 5. Intern check (if not found in employees, though UUID usually distinct)
            if not basic:
                 # Logic for interns could be added here if needed, 
                 # but for now we assume employee UUIDs are passed.
                 pass
                 
        except Exception as e:
            print(f"Error fetching profile data: {e}")
            data["error"] = str(e)
        finally:
            if conn and conn.is_connected():
                cursor.close()
                conn.close()
                
        return data
