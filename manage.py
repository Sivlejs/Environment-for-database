from flask import Flask, jsonify
import psycopg2
import os

app = Flask(__name__)


# Establish database connection using environment variable
def get_db_connection():
    conn = psycopg2.connect(os.getenv("DATABASE_URL"))
    return conn


@app.route("/")
def home():
    return "Hello, Render!"


@app.route("/users")
def get_users():
    conn = None
    try:
        conn = get_db_connection()
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM users;")
            rows = cur.fetchall()
        return jsonify(rows)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if conn is not None:
            conn.close()


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 10000))
    app.run(host="0.0.0.0", port=port)
