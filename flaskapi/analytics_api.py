from flask import Flask, request, jsonify
import pymysql
import os

app = Flask(__name__)

# Database connection function - for testing, you can use SQLite instead
def get_db_connection():
    # For testing, print the data instead of storing it
    return None

# API endpoint to receive game analytics
@app.route('/analytics', methods=['POST'])
def receive_analytics():
    # Get data from request
    data = request.json
    
    if not data:
        return jsonify({"error": "No data provided"}), 400
    
    # For testing, just print the received data
    print("Received game analytics:")
    print(f"Player ID: {data.get('player_id')}")
    print(f"Session Time: {data.get('session_time')}")
    print(f"Score: {data.get('score')}")
    print(f"Deaths: {data.get('deaths')}")
    print(f"Level: {data.get('level')}")
    
    # Connect to the database here
    return jsonify({"status": "success", "message": "Data received successfully"}), 200

# Simple endpoint to test if API is working
@app.route('/test', methods=['GET'])
def test_endpoint():
    return jsonify({"status": "API is running"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)