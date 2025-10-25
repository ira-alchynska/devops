# devops

# 🐳 Django + PostgreSQL + Nginx (Dockerized Project)

This project demonstrates a simple **Dockerized web application** that uses:
- **Django** — as the main web framework  
- **PostgreSQL** — as the relational database  
- **Nginx** — as a reverse proxy and web server  

It was created as part of the **Linux Administration / DevOps homework** task to practice containerization and service orchestration with **Docker Compose**.

---

## 🧩 Project Structure


---

## ⚙️ Services Overview

| Service | Description | Exposed Port |
|----------|--------------|--------------|
| **db** | PostgreSQL database | 5432 |
| **django** | Django web app | 8000 (internal) |
| **nginx** | Reverse proxy for Django | 80 (external) |

All services run in isolated containers defined in `compose.yaml`.

---

## 🧾 Environment Variables

Create a `.env` file in the project root with the following content:

```env
POSTGRES_DB=app_db
POSTGRES_USER=app_user
POSTGRES_PASSWORD=app_password
POSTGRES_HOST=db
POSTGRES_PORT=5432

DJANGO_SECRET_KEY=dev-insecure-key
DJANGO_DEBUG=1
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1
