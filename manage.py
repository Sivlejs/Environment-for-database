from flask import Flask, jsonify
import psycopg2
import os

app = Flask(__name__)


@app.route("/")
def home():
    return "Hello, Render!"


@app.route("/users")
def get_users():
    conn = None
    try:
        # Log database URL retrieval
        db_url = os.getenv("DATABASE_URL")
        if not db_url:
            print("DATABASE_URL is not set.")
            return jsonify({"error": "DATABASE_URL is not set."}), 500

        print(f"Connecting to database with URL: {db_url}")
        conn = psycopg2.connect(db_url)

        with conn.cursor() as cur:
            query = "SELECT * FROM users;"
            print(f"Executing query: {query}")
            cur.execute(query)
            rows = cur.fetchall()
            print(f"Query results: {rows}")

        return jsonify(rows)
    except psycopg2.DatabaseError as db_error:
        print(f"Database connection error: {db_error}")
        return jsonify({"database_error": str(db_error)}), 500
    except Exception as e:
        print(f"Unexpected error: {e}")
        return jsonify({"error": str(e)}), 500
    finally:
        if conn:
            print("Closing database connection.")
            conn.close()


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 10000))
    app.run(host="0.0.0.0", port=port)
