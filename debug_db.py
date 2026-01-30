
import mysql.connector

DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "kavin@123",
    "database": "dsingz"
}

def main():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)
    
    print("--- Employees Sample ---")
    cursor.execute("SELECT uuid, employee_id, first_name FROM employees LIMIT 3")
    for row in cursor.fetchall():
        print(row)
        
    print("\n--- Attendance Sample ---")
    cursor.execute("SELECT employee_id, status FROM attendance_records LIMIT 3")
    for row in cursor.fetchall():
        print(row)
        
    print("\n--- Distinct Employee IDs in Attendance ---")
    cursor.execute("SELECT DISTINCT employee_id FROM attendance_records LIMIT 5")
    for row in cursor.fetchall():
        print(row)

    conn.close()

if __name__ == "__main__":
    main()
