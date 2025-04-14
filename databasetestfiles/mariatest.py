import pymysql

# Database configuration
DB_HOST = 'localhost'
DB_PORT = 3306
DB_USER = 'root'
DB_PASSWORD = 'rootpassword'
DB_NAME = 'testdb'

try:
    # Connect to the MariaDB database
    connection = pymysql.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        cursorclass=pymysql.cursors.DictCursor  # So results are returned as dictionaries
    )

    print("✅ Connected to MariaDB!")

    with connection.cursor() as cursor:
        # Example query: get all rows from a test table
        cursor.execute("SELECT * FROM players;")
        results = cursor.fetchall()

        print("📦 Query Results:")
        for row in results:
            print(row)

except pymysql.MySQLError as e:
    print("❌ Database connection failed:", e)

finally:
    if 'connection' in locals() and connection.open:
        connection.close()
        print("🔌 Connection closed.")
 
