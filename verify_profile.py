
import os
import sys
from analytics.profile_engine import ProfileEngine
from analytics.visualizer import Visualizer
from main import DB_CONFIG

# Ensure charts dir exists
if not os.path.exists("./charts"):
    os.makedirs("./charts")

def verify():
    print("🚀 Starting Verification")
    
    # 1. Test Profile Engine
    print("\n[1] Testing ProfileEngine...")
    engine = ProfileEngine(DB_CONFIG)
    
    # Use a known UUID from sample.sql (Rajesh Kumar: emp-001)
    target_uuid = "emp-001" 
    
    try:
        data = engine.get_profile_data(target_uuid)
        print("✅ Data fetched successfully")
        print(f"   Name: {data['basic_info'].get('first_name')} {data['basic_info'].get('last_name')}")
        print(f"   Role: {data['basic_info'].get('job_role')}")
        print(f"   Attendance Rate: {data['attendance_stats'].get('attendance_rate')}%")
        print(f"   Skills: {len(data['skills'])} skills found")
        print(f"   Projects: {len(data['projects'])} projects found")
        
        if not data['basic_info']:
            print("❌ Basic info missing!")
            return
            
    except Exception as e:
        print(f"❌ ProfileEngine Failed: {e}")
        return

    # 2. Test Visualizer
    print("\n[2] Testing Visualizer...")
    viz = Visualizer(output_dir="./charts")
    
    try:
        result = viz.create_profile_dashboard(data)
        if result['status'] == 'success':
            print(f"✅ Dashboard generated: {result['filepath']}")
            if os.path.exists(result['filepath']):
                print("✅ File exists on disk")
            else:
                print("❌ File not found on disk")
        else:
            print(f"❌ Visualization failed: {result.get('message')}")
            
    except Exception as e:
        print(f"❌ Visualizer Exception: {e}")

if __name__ == "__main__":
    verify()
