"""
Email Notifier
Send email alerts for leave balance and other notifications.
"""

import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
from typing import Dict, Any, List, Optional
from datetime import datetime
import os

try:
    from config import EMAIL_CONFIG
except ImportError:
    EMAIL_CONFIG = {
        "smtp_server": "smtp.gmail.com",
        "smtp_port": 587,
        "sender_email": "71762308019@cit.edu.in",
        "sender_password": "your-app-password",
        "use_tls": True
    }


class EmailNotifier:
    """Send email notifications using SMTP."""
    
    def __init__(self, config: Dict = None):
        self.config = config or EMAIL_CONFIG
        self.smtp_server = self.config.get('smtp_server', 'smtp.gmail.com')
        self.smtp_port = self.config.get('smtp_port', 587)
        self.sender_email = self.config.get('sender_email')
        self.sender_password = self.config.get('sender_password')
        self.use_tls = self.config.get('use_tls', True)
    
    def send_email(self, to_email: str, subject: str, body: str, 
                   html_body: str = None, attachments: List[str] = None) -> Dict[str, Any]:
        """
        Send an email.
        
        Args:
            to_email: Recipient email address
            subject: Email subject
            body: Plain text body
            html_body: Optional HTML body
            attachments: Optional list of file paths to attach
            
        Returns:
            Dict with status and message
        """
        try:
            # Create message
            msg = MIMEMultipart('alternative')
            msg['Subject'] = subject
            msg['From'] = self.sender_email
            msg['To'] = to_email
            
            # Add plain text
            msg.attach(MIMEText(body, 'plain'))
            
            # Add HTML if provided
            if html_body:
                msg.attach(MIMEText(html_body, 'html'))
            
            # Add attachments
            if attachments:
                for filepath in attachments:
                    if os.path.exists(filepath):
                        with open(filepath, 'rb') as f:
                            part = MIMEBase('application', 'octet-stream')
                            part.set_payload(f.read())
                            encoders.encode_base64(part)
                            part.add_header(
                                'Content-Disposition',
                                f'attachment; filename={os.path.basename(filepath)}'
                            )
                            msg.attach(part)
            
            # Send email
            with smtplib.SMTP(self.smtp_server, self.smtp_port) as server:
                if self.use_tls:
                    server.starttls()
                server.login(self.sender_email, self.sender_password)
                server.sendmail(self.sender_email, to_email, msg.as_string())
            
            return {"status": "success", "message": f"Email sent to {to_email}"}
            
        except smtplib.SMTPAuthenticationError:
            return {"status": "error", "message": "SMTP authentication failed. Check credentials."}
        except smtplib.SMTPException as e:
            return {"status": "error", "message": f"SMTP error: {str(e)}"}
        except Exception as e:
            return {"status": "error", "message": f"Error sending email: {str(e)}"}
    
    def send_low_balance_alert(self, employee: Dict, balance: Dict) -> Dict[str, Any]:
        """Send low leave balance alert to employee."""
        subject = "⚠️ Low Leave Balance Alert"
        
        body = f"""
Dear {employee.get('first_name', 'Employee')},

This is an automated notification regarding your leave balance.

Your current leave balance is running low:

📅 Annual Leave: {balance['annual_leave']['remaining']} days remaining
🏥 Sick Leave: {balance['sick_leave']['remaining']} days remaining

Please plan your leaves accordingly. If you have any questions, contact HR.

Best regards,
HR Analytics System
        """
        
        html_body = f"""
<html>
<body style="font-family: Arial, sans-serif; padding: 20px;">
    <h2 style="color: #e74c3c;">⚠️ Low Leave Balance Alert</h2>
    <p>Dear <strong>{employee.get('first_name', 'Employee')}</strong>,</p>
    <p>This is an automated notification regarding your leave balance.</p>
    
    <div style="background: #f8f9fa; padding: 15px; border-radius: 8px; margin: 20px 0;">
        <h3 style="margin-top: 0;">Your Current Balance:</h3>
        <table style="width: 100%;">
            <tr>
                <td>📅 Annual Leave:</td>
                <td><strong>{balance['annual_leave']['remaining']}</strong> / {balance['annual_leave']['allocated']} days</td>
            </tr>
            <tr>
                <td>🏥 Sick Leave:</td>
                <td><strong>{balance['sick_leave']['remaining']}</strong> / {balance['sick_leave']['allocated']} days</td>
            </tr>
        </table>
    </div>
    
    <p>Please plan your leaves accordingly. If you have any questions, contact HR.</p>
    <p style="color: #888; font-size: 12px;">This is an automated message from HR Analytics System.</p>
</body>
</html>
        """
        
        return self.send_email(
            to_email=employee.get('official_email', ''),
            subject=subject,
            body=body,
            html_body=html_body
        )
    
    def send_leave_approval_notification(self, leave_request: Dict, 
                                          approved: bool) -> Dict[str, Any]:
        """Send leave approval/rejection notification."""
        status = "Approved ✅" if approved else "Rejected ❌"
        subject = f"Leave Request {status}"
        
        body = f"""
Dear {leave_request.get('first_name', 'Employee')},

Your leave request has been {status.lower()}.

Leave Details:
- Type: {leave_request.get('type', 'N/A')}
- From: {leave_request.get('start_date', 'N/A')}
- To: {leave_request.get('end_date', 'N/A')}
- Days: {leave_request.get('days', 'N/A')}

Best regards,
HR Analytics System
        """
        
        return self.send_email(
            to_email=leave_request.get('official_email', ''),
            subject=subject,
            body=body
        )
    
    def send_weekly_report(self, to_emails: List[str], report_content: str, 
                           attachments: List[str] = None) -> List[Dict[str, Any]]:
        """Send weekly analytics report to multiple recipients."""
        subject = f"📊 Weekly Analytics Report - {datetime.now().strftime('%Y-%m-%d')}"
        
        results = []
        for email in to_emails:
            result = self.send_email(
                to_email=email,
                subject=subject,
                body=report_content,
                attachments=attachments
            )
            results.append({"email": email, **result})
        
        return results
    
    def send_monthly_report(self, to_emails: List[str], report_content: str,
                            attachments: List[str] = None) -> List[Dict[str, Any]]:
        """Send monthly analytics report to multiple recipients."""
        month = datetime.now().strftime('%B %Y')
        subject = f"📈 Monthly Analytics Report - {month}"
        
        results = []
        for email in to_emails:
            result = self.send_email(
                to_email=email,
                subject=subject,
                body=report_content,
                attachments=attachments
            )
            results.append({"email": email, **result})
        
        return results


# Convenience function
def send_alert(to_email: str, subject: str, message: str) -> Dict[str, Any]:
    """Quick function to send an alert email."""
    notifier = EmailNotifier()
    return notifier.send_email(to_email, subject, message)
