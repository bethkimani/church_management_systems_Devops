FROM python:3.10-slim
WORKDIR /app
RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
RUN pip install gunicorn==22.0.0
CMD ["sh", "-c", "python manage.py migrate && gunicorn --bind 0.0.0.0:8000 church_backend.wsgi:application"]