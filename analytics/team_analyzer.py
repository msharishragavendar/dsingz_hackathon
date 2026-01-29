"""
Team Performance Analyzer
Compare and analyze team-level metrics.
"""

from typing import Dict, Any, List
from datetime import datetime, timedelta
import mysql.connector
from collections import defaultdict

try:
    from config import DB_CONFIG
except ImportError:
    DB_CONFIG = {
        "host": "localhost",
        "user": "root", 
        "password": "data@123",
        "database": "dsingz"
    }


class TeamAnalyzer:
    """Analyze and compare team-level performance metrics."""
    
    def __init__(self):
        self.db_config = DB_CONFIG
    
    def get_teams(self) -> List[Dict]:
        """Get list of teams (grouped by reporting_manager)."""
        conn = mysql.connector.connect(**self.db_config)
        cursor = conn.cursor(dictionary=True)
        
        try:
            cursor.execute("""
                SELECT 
                    e.reporting_manager as manager_uuid,
                    m.first_name as manager_name,
                    m.last_name as manager_last_name,
                    COUNT(e.uuid) as team_size
                FROM employees e
                LEFT JOIN employees m ON e.reporting_manager = m.uuid
                WHERE e.deleted_at IS NULL
                GROUP BY e.reporting_manager, m.first_name, m.last_name
            """)
            return cursor.fetchall()
        finally:
            cursor.close()
            conn.close()
    
    def get_team_attendance(self, manager_uuid: str = None, 
                            days: int = 30) -> Dict[str, Any]:
        """Get attendance metrics for a team or all teams."""
        conn = mysql.connector.connect(**self.db_config)
        cursor = conn.cursor(dictionary=True)
        
        try:
            query = """
                SELECT 
                    e.reporting_manager,
                    ar.status,
                    COUNT(*) as count
                FROM attendance_records ar
                JOIN employees e ON ar.employee_id = e.uuid
                WHERE ar.date >= DATE_SUB(CURDATE(), INTERVAL %s DAY)
                AND ar.deleted_at IS NULL
            """
            params = [days]
            
            if manager_uuid:
                query += " AND e.reporting_manager = %s"
                params.append(manager_uuid)
            
            query += " GROUP BY e.reporting_manager, ar.status"
            
            cursor.execute(query, params)
            results = cursor.fetchall()
            
            # Aggregate by team
            team_stats = defaultdict(lambda: defaultdict(int))
            for row in results:
                manager = row['reporting_manager'] or 'Unknown'
                team_stats[manager][row['status']] = row['count']
                team_stats[manager]['total'] += row['count']
            
            return dict(team_stats)
        finally:
            cursor.close()
            conn.close()
    
    def get_team_leave_stats(self, manager_uuid: str = None, 
                              days: int = 30) -> Dict[str, Any]:
        """Get leave statistics for teams."""
        conn = mysql.connector.connect(**self.db_config)
        cursor = conn.cursor(dictionary=True)
        
        try:
            query = """
                SELECT 
                    e.reporting_manager,
                    l.type,
                    l.status as leave_status,
                    SUM(l.days) as total_days
                FROM leaves l
                JOIN employees e ON l.employee_id = e.uuid
                WHERE l.start_date >= DATE_SUB(CURDATE(), INTERVAL %s DAY)
                AND l.deleted_at IS NULL
            """
            params = [days]
            
            if manager_uuid:
                query += " AND e.reporting_manager = %s"
                params.append(manager_uuid)
            
            query += " GROUP BY e.reporting_manager, l.type, l.status"
            
            cursor.execute(query, params)
            return cursor.fetchall()
        finally:
            cursor.close()
            conn.close()
    
    def compare_teams(self, days: int = 30) -> Dict[str, Any]:
        """Compare all teams on key metrics."""
        attendance = self.get_team_attendance(days=days)
        
        comparison = []
        for manager_id, stats in attendance.items():
            total = stats.get('total', 1)
            present = stats.get('present', 0) + stats.get('work_from_home', 0)
            
            comparison.append({
                "team_id": manager_id,
                "total_records": total,
                "present_count": present,
                "attendance_rate": round((present / total) * 100, 2) if total > 0 else 0,
                "late_count": stats.get('late', 0),
                "absent_count": stats.get('absent', 0),
                "leave_count": stats.get('leave', 0)
            })
        
        # Sort by attendance rate
        comparison.sort(key=lambda x: x['attendance_rate'], reverse=True)
        
        return {
            "period_days": days,
            "team_count": len(comparison),
            "rankings": comparison,
            "best_team": comparison[0] if comparison else None,
            "needs_attention": [t for t in comparison if t['attendance_rate'] < 80]
        }
    
    def get_team_skills(self, manager_uuid: str = None) -> Dict[str, Any]:
        """Get skill distribution for a team."""
        conn = mysql.connector.connect(**self.db_config)
        cursor = conn.cursor(dictionary=True)
        
        try:
            query = """
                SELECT 
                    e.reporting_manager,
                    t.technology_name,
                    es.level,
                    COUNT(*) as count
                FROM employees_skills es
                JOIN employees e ON es.employee_id = e.uuid
                JOIN technologies t ON es.technology_ids = t.uuid
                WHERE e.deleted_at IS NULL
            """
            params = []
            
            if manager_uuid:
                query += " AND e.reporting_manager = %s"
                params.append(manager_uuid)
            
            query += " GROUP BY e.reporting_manager, t.technology_name, es.level"
            
            cursor.execute(query, params)
            return cursor.fetchall()
        finally:
            cursor.close()
            conn.close()
    
    def generate_team_summary(self, manager_uuid: str = None) -> str:
        """Generate a text summary of team performance."""
        comparison = self.compare_teams()
        
        if not comparison['rankings']:
            return "No team data available."
        
        summary = f"📊 **Team Performance Summary** (Last 30 days)\n\n"
        summary += f"Teams analyzed: {comparison['team_count']}\n\n"
        
        for i, team in enumerate(comparison['rankings'][:5], 1):
            emoji = "🥇" if i == 1 else "🥈" if i == 2 else "🥉" if i == 3 else f"{i}."
            summary += f"{emoji} Team {team['team_id'][:8]}...: {team['attendance_rate']}% attendance\n"
        
        if comparison['needs_attention']:
            summary += f"\n⚠️ {len(comparison['needs_attention'])} team(s) need attention (< 80% attendance)"
        
        return summary
