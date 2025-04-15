from flask import Flask, request, jsonify
import pymysql
import os

app = Flask(__name__)


# Database configuration
DB_HOST = 'localhost'
DB_PORT = 3306
DB_USER = 'root'
DB_PASSWORD = 'rootpassword'
DB_NAME = 'godot'

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
        return connection
    except pymysql.MySQLError as e:
        print(f"Database connection error: {e}")
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
    print(f"Accucracy: {data.get('accuracy')}")
    print(f"Damage dealt: {data.get('damage')}")
    print(f"Shots fired: {data.get('shots_fired')}")
    # Connect to the database here
    connection = get_db_connection()
    if not connection:
        return jsonify({"error": "Database connection failed"}), 500
    
    try:
        with connection.cursor() as cursor:
            # Insert data into the players table
            sql = """
            INSERT INTO players 
            (username, session_time, score, accuracy, damage, shots_fired) 
            VALUES (%s, %s, %s, %s, %s, %s)
            """
            
            # Extract values from the request data, providing defaults if not present
            username = data.get('player_id', '')
            session_time = data.get('session_time', '0')
            score = data.get('score', 0)
            accuracy = data.get('accuracy', 0.0)
            damage = data.get('damage', 0)
            shots_fired = data.get('shots_fired', 0)
            
            # Execute the SQL query
            cursor.execute(sql, (username, session_time, score, accuracy, damage, shots_fired))
            
            # Commit the transaction
            connection.commit()
            
            print(f"Data inserted successfully for player_id: {username}")
            return jsonify({"status": "success", "message": "Data received successfully"}), 200
    except pymysql.MySQLError as e:
        # Handle database errors
        if connection:
            connection.rollback()
        print(f"Database error: {e}")
        return jsonify({"error": f"Database error: {str(e)}"}), 500
    finally:
        # Close the connection
        if connection:
            connection.close()

# Simple endpoint to test if API is working
@app.route('/test', methods=['GET'])
def test_endpoint():
    return jsonify({"status": "API is running"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)