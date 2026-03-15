import os

import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)


def get_db_connection():
    conn = psycopg2.connect(os.getenv("DATABASE_URL"))
    return conn


@app.route("/")
def home():
    return "Hello, Render!"


@app.route("/users")
def get_users():
    try:
        conn = get_db_connection()
        with conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM users;")
                rows = cur.fetchall()
        conn.close()
        return jsonify(rows)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 10000))
    app.run(host="0.0.0.0", port=port)
