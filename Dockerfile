FROM python:3.7-alpine

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

ENTRYPOINT FLASK_APP=/app/app.py flask run --host=0.0.0.0 --port=80
