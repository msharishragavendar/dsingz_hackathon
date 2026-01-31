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
    """
    try:
        data = request.get_json()
        if not data or 'message' not in data:
            return jsonify({"success": False, "error": "No message provided"}), 400
        
        message = data['message'].strip()
        include_chart = data.get('include_chart', False) # Check for graph flag
        
        if not message:
            return jsonify({"success": False, "error": "Empty message"}), 400
        
        # Call the main pipeline with the graph flag
        result = process_query(message, include_chart)
        
        # Extract chart path if available
        chart_path = None
        viz = result.get('visualization')
        if viz and isinstance(viz, dict) and viz.get('status') == 'success':
            # Convert local path to URL path (assuming /charts is served statically)
            full_path = viz.get('filepath', '')
            filename = os.path.basename(full_path)
            if filename:
                chart_path = f"/charts/{filename}"

        response = {
            "success": True,
            "response": result['response'],
            "query_type": result['query_info'].get('query_type'),
            "sql_query": result['sql_query'],
            "record_count": len(result['sql_data']) if result['sql_data'] else 0,
            "data": result['sql_data'],
            "chart": chart_path
        }
        
        return jsonify(response)

    except Exception as e:
        print(f"API Error: {e}")
        return jsonify({"success": False, "error": str(e)}), 500

@app.route('/api/employees', methods=['GET'])
def employees():
    """Return list of employee names for autocomplete."""
    try:
        names = get_employee_names()
        return jsonify({"success": True, "employees": names})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

# Serve Charts
@app.route('/charts/<path:filename>')
def serve_chart(filename):
    return send_from_directory('charts', filename)

@app.route('/api/settings', methods=['GET'])
def get_settings():
    try:
        if os.path.exists(SETTINGS_FILE):
            with open(SETTINGS_FILE, 'r') as f:
                data = json.load(f)
            return jsonify({"success": True, "settings": data})
        else:
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

# Serve Frontend
@app.route('/')
def index():
    return send_from_directory(app.static_folder, 'index.html')

@app.route('/<path:path>')
def serve_static(path):
    if os.path.exists(os.path.join(app.static_folder, path)):
        return send_from_directory(app.static_folder, path)
    return send_from_directory(app.static_folder, 'index.html')

if __name__ == '__main__':
    # Ensure charts directory exists
    if not os.path.exists('charts'):
        os.makedirs('charts')
    app.run(debug=True, host='0.0.0.0', port=5000)