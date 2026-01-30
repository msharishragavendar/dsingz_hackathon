"""
Flask API for NL2SQL Analytics Engine
Provides REST endpoints for the chatbot frontend.
"""

from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import os
import sys

# Import the main pipeline
from main import process_query, execute_sql

app = Flask(__name__, static_folder='frontend/dist', static_url_path='')
CORS(app)  # Enable CORS for frontend dev server


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
            return jsonify({
                "success": False,
                "error": "No message provided"
            }), 400
        
        message = data['message'].strip()
        
        if not message:
            return jsonify({
                "success": False,
                "error": "Empty message"
            }), 400
        
        # Process the query using existing pipeline
        result = process_query(message)
        
        # Prepare response
        response = {
            "success": True,
            "response": result.get('response', 'No response generated'),
            "query_type": result.get('query_info', {}).get('query_type', 'UNKNOWN') if result.get('query_info') else 'UNKNOWN',
            "sql_query": result.get('sql_query'),
            "data": result.get('sql_data', [])[:20],  # Limit to 20 records
            "record_count": len(result.get('sql_data', [])),
            "chart": None,
            "profile_data": result.get('profile_data')
        }
        
        # Include chart if generated
        viz = result.get('visualization')
        if viz and viz.get('status') == 'success':
            chart_path = viz.get('filepath', '')
            if chart_path and os.path.exists(chart_path):
                response['chart'] = f"/charts/{os.path.basename(chart_path)}"
        
        return jsonify(response)
    
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


@app.route('/api/health', methods=['GET'])
def health():
    """Health check endpoint."""
    return jsonify({"status": "healthy", "service": "NL2SQL Analytics API"})


@app.route('/charts/<path:filename>')
def serve_chart(filename):
    """Serve generated chart images."""
    charts_dir = os.path.join(os.path.dirname(__file__), 'charts')
    return send_from_directory(charts_dir, filename)


@app.route('/')
def serve_frontend():
    """Serve the React frontend."""
    return send_from_directory(app.static_folder, 'index.html')


@app.route('/<path:path>')
def serve_static(path):
    """Serve static files."""
    if os.path.exists(os.path.join(app.static_folder, path)):
        return send_from_directory(app.static_folder, path)
    return send_from_directory(app.static_folder, 'index.html')


if __name__ == '__main__':
    # Ensure charts directory exists
    os.makedirs('charts', exist_ok=True)
    
    print("🚀 Starting NL2SQL Analytics API...")
    print("📡 API: http://localhost:5000/api/chat")
    print("🌐 UI:  http://localhost:5000")
    
    app.run(host='0.0.0.0', port=5000, debug=True)
