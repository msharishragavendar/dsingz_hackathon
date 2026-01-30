"""
Flask API for NL2SQL Analytics Engine
Provides REST endpoints for the chatbot frontend.
"""

from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import os
import json

# Import the main pipeline and the new function
from main import process_query, get_employee_names

app = Flask(__name__, static_folder='frontend/dist', static_url_path='')
CORS(app)

SETTINGS_FILE = "salary_config.json"

@app.route('/api/chat', methods=['POST'])
def chat():
    """    
    Process a natural language query and return the response.
    
    Request body:
        {"message": "your question here"}
    
    Response:
        {
            "success": true,
            "response": "natural language response",
            "query_type": "DIRECT_SQL",
            "sql_query": "SELECT ...",
            "data": [...],
            "chart": "/charts/chart_123.png" or null
        }
    """
    try:
        data = request.get_json()
        if not data or 'message' not in data:
            return jsonify({"success": False, "error": "No message provided"}), 400
        
        message = data['message'].strip()
        if not message:
            return jsonify({"success": False, "error": "Empty message"}), 400
        
        result = process_query(message)
        
        response = {
            "success": True,
            "response": result.get('response', 'No response generated'),
            "query_type": result.get('query_info', {}).get('query_type', 'UNKNOWN') if result.get('query_info') else 'UNKNOWN',
            "sql_query": result.get('sql_query'),
            "data": result.get('sql_data', [])[:20],
            "record_count": len(result.get('sql_data', [])),
            "chart": None
        }
        
        viz = result.get('visualization')
        if viz and viz.get('status') == 'success':
            chart_path = viz.get('filepath', '')
            if chart_path and os.path.exists(chart_path):
                response['chart'] = f"/charts/{os.path.basename(chart_path)}"
        
        return jsonify(response)
    
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

# --- NEW ENDPOINT FOR AUTOCOMPLETE ---
@app.route('/api/employees', methods=['GET'])
def employees():
    """Return list of employees for @mentions."""
    try:
        names = get_employee_names()
        return jsonify({"success": True, "employees": names})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

@app.route('/api/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy"})

@app.route('/charts/<path:filename>')
def serve_chart(filename):
    charts_dir = os.path.join(os.path.dirname(__file__), 'charts')
    return send_from_directory(charts_dir, filename)

@app.route('/')
def serve_frontend():
    return send_from_directory(app.static_folder, 'index.html')

@app.route('/<path:path>')
def serve_static(path):
    if os.path.exists(os.path.join(app.static_folder, path)):
        return send_from_directory(app.static_folder, path)
    return send_from_directory(app.static_folder, 'index.html')

@app.route('/api/settings', methods=['GET'])
def get_settings():
    try:
        if os.path.exists(SETTINGS_FILE):
            with open(SETTINGS_FILE, 'r') as f:
                data = json.load(f)
            return jsonify({"success": True, "settings": data})
        else:
            # Return defaults
            return jsonify({
                "success": True, 
                "settings": {
                    "rates": {"intern": 50, "employee": 100, "expert": 200},
                    "rules": {"max_full_leaves": 1, "max_half_leaves": 2, "deficit_threshold": 1, "expected_hours": 160}
                }
            })
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

@app.route('/api/settings', methods=['POST'])
def save_settings():
    try:
        data = request.get_json()
        with open(SETTINGS_FILE, 'w') as f:
            json.dump(data, f, indent=4)
        return jsonify({"success": True, "message": "Settings saved"})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

if __name__ == '__main__':
    os.makedirs('charts', exist_ok=True)
    print("🚀 Starting API...")
    app.run(host='0.0.0.0', port=5000, debug=True)