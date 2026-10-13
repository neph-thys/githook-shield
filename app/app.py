from flask import Flask
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)
REQS = Counter("app_requests_total", "Total requests")

@app.route("/")
def home():
    REQS.inc()
    return "GitHook Shield is running"

@app.route("/health")
def health():
    return "ok"

@app.route("/metrics")
def metrics():
    return generate_latest(), 200, {"Content-Type": CONTENT_TYPE_LATEST}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)