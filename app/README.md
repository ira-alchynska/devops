# Django Hello World with Docker Compose

A simple Django application with PostgreSQL and Nginx, containerized using Docker and Docker Compose.

## Project Structure

```
app/
├── myproject/          # Django project
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── hello/              # Django app
│   ├── views.py
│   └── urls.py
├── nginx/              # Nginx configuration
│   └── nginx.conf
├── Dockerfile          # Django container
├── docker-compose.yml  # Docker Compose configuration
└── requirements.txt    # Python dependencies
```

## Services

- **web**: Django application (Gunicorn)
- **db**: PostgreSQL database
- **nginx**: Reverse proxy server

## Quick Start

1. **Build and start all services:**
   ```bash
   docker-compose up -d
   ```

2. **Access the application:**
   - Via Nginx: http://localhost
   - Direct Django: http://localhost:8000

3. **View logs:**
   ```bash
   docker-compose logs -f
   ```

4. **Stop services:**
   ```bash
   docker-compose down
   ```

5. **Stop and remove volumes (database data):**
   ```bash
   docker-compose down -v
   ```

## Database

The PostgreSQL database is automatically initialized when the containers start. Migrations run automatically on startup.

## Environment Variables

Create a `.env` file (or use `.env.example` as a template) to customize:
- `SECRET_KEY`: Django secret key
- `DEBUG`: Debug mode (True/False)
- `POSTGRES_*`: Database configuration

## Development

To run Django management commands:

```bash
docker-compose exec web python manage.py <command>
```

Example:
```bash
docker-compose exec web python manage.py createsuperuser
```

