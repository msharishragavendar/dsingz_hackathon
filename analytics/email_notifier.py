"""
Email Notifier
Send email alerts for leave balance and other notifications.
"""

import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from typing import Dict, Any, List, Optional
try:
    from config import EMAIL_CONFIG
except ImportError:
    # Fallback if config.py not found
    EMAIL_CONFIG = {}

class EmailNotifier:
    """Send email notifications using SMTP."""
    
    def __init__(self):
        self.config = EMAIL_CONFIG
        self.smtp_server = self.config.get('smtp_server', 'smtp.gmail.com')
        self.smtp_port = self.config.get('smtp_port', 587)
        self.sender_email = self.config.get('sender_email')
        self.sender_password = self.config.get('sender_password')
        self.use_tls = self.config.get('use_tls', True)
    
    def send_email(self, to_email: str, subject: str, body: str) -> Dict[str, Any]:
        """Send a single email."""
        if not self.sender_email or not self.sender_password:
            return {"status": "error", "message": "Email credentials not configured"}

        try:
            msg = MIMEMultipart()
            msg['From'] = self.sender_email
            msg['To'] = to_email
            msg['Subject'] = subject
            msg.attach(MIMEText(body, 'plain'))
            
            server = smtplib.SMTP(self.smtp_server, self.smtp_port)
            if self.use_tls:
                server.starttls()
            
            server.login(self.sender_email, self.sender_password)
            server.send_message(msg)
            server.quit()
            
            return {"status": "success", "message": f"Email sent to {to_email}"}
            
        except Exception as e:
            return {"status": "error", "message": str(e)}

    def send_batch(self, recipients: List[str], subject: str, body: str) -> Dict[str, Any]:
        """Send emails to multiple recipients."""
        success_count = 0
        errors = []
        
        for email in recipients:
            if not email or "@" not in email:
                continue
            res = self.send_email(email, subject, body)
            if res["status"] == "success":
                success_count += 1
            else:
                errors.append(f"{email}: {res['message']}")
                
        return {
            "status": "completed",
            "sent": success_count,
            "failed": len(errors),
            "errors": errors
        }