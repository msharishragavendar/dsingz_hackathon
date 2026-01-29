"""
Configuration for NL2SQL Analytics Engine
"""

# =========================
# DATABASE CONFIG
# =========================
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "data@123",
    "database": "dsingz"
}

# =========================
# API CONFIG
# =========================
OPENROUTER_API_KEY = "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"
OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"
MODEL = "deepseek/deepseek-chat"

# =========================
# EMAIL CONFIG (SMTP)
# =========================
EMAIL_CONFIG = {
    "smtp_server": "smtp.gmail.com",
    "smtp_port": 587,
    "sender_email": "your-email@gmail.com",  # UPDATE THIS
    "sender_password": "your-app-password",   # UPDATE THIS (use App Password for Gmail)
    "use_tls": True
}

# =========================
# REPORT SCHEDULE CONFIG
# =========================
SCHEDULE_CONFIG = {
    "weekly_report": {
        "enabled": True,
        "day_of_week": "monday",
        "hour": 9,
        "minute": 0
    },
    "monthly_report": {
        "enabled": True,
        "day_of_month": 1,
        "hour": 9,
        "minute": 0
    }
}

# =========================
# LEAVE POLICY CONFIG
# =========================
LEAVE_POLICY = {
    "annual_leave_days": 24,
    "sick_leave_days": 12,
    "personal_leave_days": 5,
    "low_balance_threshold": 3,  # Alert when balance falls below this
    "alert_enabled": True
}

# =========================
# REPORT OUTPUT CONFIG
# =========================
REPORT_CONFIG = {
    "output_dir": "./reports",
    "chart_dir": "./charts",
    "template_dir": "./templates"
}
