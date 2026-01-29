"""
Scheduler for automated report generation and alerts.
Uses APScheduler for scheduling tasks.
"""

from typing import Callable, Dict, Any, List
from datetime import datetime
import threading
import time

try:
    from apscheduler.schedulers.background import BackgroundScheduler
    from apscheduler.triggers.cron import CronTrigger
    HAS_APSCHEDULER = True
except ImportError:
    HAS_APSCHEDULER = False

try:
    from config import SCHEDULE_CONFIG, LEAVE_POLICY
except ImportError:
    SCHEDULE_CONFIG = {
        "weekly_report": {"enabled": True, "day_of_week": "monday", "hour": 9, "minute": 0},
        "monthly_report": {"enabled": True, "day_of_month": 1, "hour": 9, "minute": 0}
    }
    LEAVE_POLICY = {"alert_enabled": True, "low_balance_threshold": 3}


class ReportScheduler:
    """Schedule automated report generation and email alerts."""
    
    def __init__(self):
        self.config = SCHEDULE_CONFIG
        self.scheduler = None
        self.jobs = {}
        
        if HAS_APSCHEDULER:
            self.scheduler = BackgroundScheduler()
    
    def start(self):
        """Start the scheduler."""
        if not HAS_APSCHEDULER:
            print("⚠️ APScheduler not installed. Run: pip install apscheduler")
            return False
        
        if self.scheduler and not self.scheduler.running:
            self.scheduler.start()
            print("✅ Scheduler started")
            return True
        return False
    
    def stop(self):
        """Stop the scheduler."""
        if self.scheduler and self.scheduler.running:
            self.scheduler.shutdown()
            print("🛑 Scheduler stopped")
    
    def schedule_weekly_report(self, report_func: Callable, 
                                email_func: Callable = None,
                                recipients: List[str] = None):
        """Schedule weekly report generation."""
        if not HAS_APSCHEDULER:
            print("⚠️ APScheduler required for scheduling")
            return
        
        config = self.config.get('weekly_report', {})
        if not config.get('enabled', False):
            print("ℹ️ Weekly reports are disabled in config")
            return
        
        def job():
            print(f"📊 Generating weekly report at {datetime.now()}")
            try:
                report = report_func()
                if email_func and recipients:
                    email_func(recipients, report.get('text_report', ''), 
                              [report.get('filepath')])
                print(f"✅ Weekly report generated: {report.get('filepath')}")
            except Exception as e:
                print(f"❌ Error generating weekly report: {e}")
        
        trigger = CronTrigger(
            day_of_week=config.get('day_of_week', 'mon'),
            hour=config.get('hour', 9),
            minute=config.get('minute', 0)
        )
        
        job_id = self.scheduler.add_job(job, trigger, id='weekly_report')
        self.jobs['weekly_report'] = job_id
        print(f"📅 Weekly report scheduled: {config.get('day_of_week')} at {config.get('hour')}:{config.get('minute'):02d}")
    
    def schedule_monthly_report(self, report_func: Callable,
                                 email_func: Callable = None,
                                 recipients: List[str] = None):
        """Schedule monthly report generation."""
        if not HAS_APSCHEDULER:
            print("⚠️ APScheduler required for scheduling")
            return
        
        config = self.config.get('monthly_report', {})
        if not config.get('enabled', False):
            print("ℹ️ Monthly reports are disabled in config")
            return
        
        def job():
            print(f"📈 Generating monthly report at {datetime.now()}")
            try:
                report = report_func()
                if email_func and recipients:
                    email_func(recipients, report.get('text_report', ''),
                              [report.get('filepath')])
                print(f"✅ Monthly report generated: {report.get('filepath')}")
            except Exception as e:
                print(f"❌ Error generating monthly report: {e}")
        
        trigger = CronTrigger(
            day=config.get('day_of_month', 1),
            hour=config.get('hour', 9),
            minute=config.get('minute', 0)
        )
        
        job_id = self.scheduler.add_job(job, trigger, id='monthly_report')
        self.jobs['monthly_report'] = job_id
        print(f"📅 Monthly report scheduled: Day {config.get('day_of_month')} at {config.get('hour')}:{config.get('minute'):02d}")
    
    def schedule_leave_balance_alerts(self, tracker_func: Callable,
                                       email_func: Callable):
        """Schedule daily leave balance check and alerts."""
        if not HAS_APSCHEDULER:
            print("⚠️ APScheduler required for scheduling")
            return
        
        if not LEAVE_POLICY.get('alert_enabled', False):
            print("ℹ️ Leave alerts are disabled in config")
            return
        
        def job():
            print(f"🔔 Checking leave balances at {datetime.now()}")
            try:
                low_balance_employees = tracker_func()
                for emp_data in low_balance_employees:
                    emp = emp_data.get('employee', {})
                    result = email_func(emp, emp_data)
                    print(f"   Alert sent to {emp.get('first_name')}: {result.get('status')}")
                print(f"✅ Leave balance check complete: {len(low_balance_employees)} alerts sent")
            except Exception as e:
                print(f"❌ Error checking leave balances: {e}")
        
        # Run daily at 10 AM
        trigger = CronTrigger(hour=10, minute=0)
        job_id = self.scheduler.add_job(job, trigger, id='leave_alerts')
        self.jobs['leave_alerts'] = job_id
        print("📅 Leave balance alerts scheduled: Daily at 10:00")
    
    def run_now(self, job_name: str):
        """Manually trigger a scheduled job."""
        if job_name in self.jobs:
            job = self.scheduler.get_job(job_name)
            if job:
                job.modify(next_run_time=datetime.now())
                print(f"🚀 Running {job_name} now...")
        else:
            print(f"❌ Job '{job_name}' not found")
    
    def list_jobs(self) -> List[Dict]:
        """List all scheduled jobs."""
        if not self.scheduler:
            return []
        
        jobs = []
        for job in self.scheduler.get_jobs():
            jobs.append({
                "id": job.id,
                "name": job.name,
                "next_run": str(job.next_run_time),
                "trigger": str(job.trigger)
            })
        return jobs


# Simple scheduler without APScheduler dependency
class SimpleScheduler:
    """Fallback scheduler using threading (for environments without APScheduler)."""
    
    def __init__(self):
        self.running = False
        self.tasks = {}
        self.thread = None
    
    def add_daily_task(self, name: str, hour: int, minute: int, func: Callable):
        """Add a task to run daily at specified time."""
        self.tasks[name] = {
            "hour": hour,
            "minute": minute,
            "func": func,
            "last_run": None
        }
    
    def start(self):
        """Start the scheduler in background thread."""
        self.running = True
        self.thread = threading.Thread(target=self._run_loop, daemon=True)
        self.thread.start()
        print("✅ Simple scheduler started")
    
    def stop(self):
        """Stop the scheduler."""
        self.running = False
        if self.thread:
            self.thread.join(timeout=5)
        print("🛑 Simple scheduler stopped")
    
    def _run_loop(self):
        """Main scheduler loop."""
        while self.running:
            now = datetime.now()
            
            for name, task in self.tasks.items():
                if (now.hour == task['hour'] and 
                    now.minute == task['minute'] and
                    task['last_run'] != now.date()):
                    
                    try:
                        print(f"🔄 Running task: {name}")
                        task['func']()
                        task['last_run'] = now.date()
                    except Exception as e:
                        print(f"❌ Error in task {name}: {e}")
            
            time.sleep(30)  # Check every 30 seconds


def get_scheduler() -> ReportScheduler:
    """Get the appropriate scheduler based on available dependencies."""
    return ReportScheduler()
