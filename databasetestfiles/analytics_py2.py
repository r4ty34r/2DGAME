from flask import Flask, request, jsonify
import pymysql
import os

# Database configuration
DB_HOST = 'localhost'
DB_PORT = 3306
DB_USER = 'root'
DB_PASSWORD = 'Dido1234!!*'  # Consider using environment variables for this
DB_NAME = 'projectTest'

app = Flask(__name__)

# Database connection function
def get_db_connection():
    try:
        connection = pymysql.connect(
            host=DB_HOST,
            port=DB_PORT,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME,
            cursorclass=pymysql.cursors.DictCursor
        )
        print("✅ Connected to MariaDB!")
        return connection
    except pymysql.MySQLError as e:
        print(f"Error connecting to database: {e}")
        return None

# API endpoint to receive game analytics
@app.route('/analytics', methods=['POST'])
def receive_analytics():
    # Get data from request
    data = request.json
    
    if not data:
        return jsonify({"error": "No data provided"}), 400
    
    # Print the received data (you can keep or remove this)
    print("Received game analytics:")
    print(f"Player ID: {data.get('player_id')}")
    print(f"Session Time: {data.get('session_time')}")
    print(f"Score: {data.get('score')}")
    print(f"Deaths: {data.get('deaths')}")
    print(f"Level: {data.get('level')}")
    print(f"Accuracy: {data.get('accuracy')}")
    print(f"Damage dealt: {data.get('damage')}")
    print(f"Shots fired: {data.get('shots_fired')}")
    
    # Connect to the database
    connection = get_db_connection()
    if connection is None:
        return jsonify({"error": "Database connection failed"}), 500
    
    try:
        with connection.cursor() as cursor:
            # Insert data into the players table (adjust SQL as needed)
            sql = """INSERT INTO players 
                    (player_name, session_time, score, deaths, level, accuracy, damage, shots_fired) 
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"""
            cursor.execute(sql, (
                data.get('player_id'),
                data.get('session_time'),
                data.get('score'),
                data.get('deaths'),
                data.get('level'),
                data.get('accuracy'),
                data.get('damage'),
                data.get('shots_fired')
            ))
            connection.commit()
        return jsonify({"status": "success", "message": "Data saved successfully"}), 200
    except pymysql.MySQLError as e:
        return jsonify({"error": f"Database error: {str(e)}"}), 500
    finally:
        connection.close()

# Simple endpoint to test if API is working
@app.route('/test', methods=['GET'])
def test_endpoint():
    return jsonify({"status": "API is running"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)