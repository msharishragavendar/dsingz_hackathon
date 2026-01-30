
import mysql.connector
from analytics.profile_engine import ProfileEngine

DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "kavin@123",
    "database": "dsingz"
}

def get_employee_uuids():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT uuid, first_name, last_name FROM employees LIMIT 5")
    rows = cursor.fetchall()
    conn.close()
    return rows

def main():
    employees = get_employee_uuids()
    engine = ProfileEngine(DB_CONFIG)
    
    print(f"Found {len(employees)} employees checking stats...")
    
    for emp in employees:
        print(f"\n--- Checking {emp['first_name']} {emp['last_name']} ({emp['uuid']}) ---")
        data = engine.get_profile_data(emp['uuid'])
        stats = data.get('attendance_stats', {})
        print(f"Stats: {stats}")
        print(f"Skills Count: {len(data.get('skills', []))}")

if __name__ == "__main__":
    main()
