FROM python:3.11-slim

WORKDIR /app

COPY web/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt || true

COPY web/ /app/

ENV PYTHONUNBUFFERED=1


CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]