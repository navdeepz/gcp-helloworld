from flask import Flask
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry import traceccat
from opentelemetry.exporter.jaeger.thrift import JaegerExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.resources import SERVICE_NAME, Resource
import os
import psycopg2
import redis

app = Flask(__name__)

# Configure OpenTelemetry
resource = Resource.create({SERVICE_NAME: "webapp"})
tracer_provider = TracerProvider(resource=resource)
trace.set_tracer_provider(tracer_provider)
jaeger_exporter = JaegerExporter(
    agent_host_name="localhost", agent_port=6831
)
trace.set_tracer_provider(tracer_provider)

FlaskInstrumentor().instrument_app(app)

# Get environment variables
db_host = os.getenv("DB_HOST")
db_name = os.getenv("DB_NAME")
db_user = os.getenv("DB_USER")
db_password = os.getenv("DB_PASSWORD")
redis_host = os.getenv("REDIS_HOST")

# Connect to Redis
cache = redis.Redis(host=redis_host)

# Function to establish a database connection
def get_db_connection():
    conn = psycopg2.connect(
        host=db_host,
        database=db_name,
        user=db_user,
        password=db_password
    )
    return conn

# Route to fetch and cache data from the database
@app.route('/')
def hello_world():
    cached_message = cache.get('hello_message')
    if cached_message:
        return cached_message.decode('utf-8')
    
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT message FROM hello WHERE id = 1')
    message = cursor.fetchone()[0]
    conn.close()
    
    cache.set('hello_message', message)
    return message

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
