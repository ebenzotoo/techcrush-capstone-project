# Capstone Group 5 — Dockerized 3-Tier Web App with GitHub CI/CD

A three-tier web application containerized with Docker and deployed via a GitHub Actions CI/CD pipeline.

## Architecture

```
Browser → Frontend (Nginx :8080) → Backend (Node.js :3000) → Database (PostgreSQL :5432)
```

| Tier     | Technology       | Docker Image              |
|----------|-----------------|---------------------------|
| Frontend | Nginx (HTML/CSS) | `ebenzotoo/frontend:v1.0` |
| Backend  | Node.js/Express | `ebenzotoo/backend:v1.0`  |
| Database | PostgreSQL 15   | `postgres:15-alpine`      |

## Project Structure

```
.
├── .github/
│   └── workflows/
│       └── deploy.yml        # GitHub Actions CI/CD pipeline
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   └── server.js             # Express API with PostgreSQL
├── db/
│   └── init.sql              # Database schema + seed data
├── frontend/
│   ├── Dockerfile
│   ├── index.html            # Portfolio page
│   └── nginx.conf            # Nginx reverse proxy config
├── docker-compose.yml
└── README.md
```

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) & Docker Compose
- [Docker Hub](https://hub.docker.com/) account (`ebenzotoo`)
- A Linux VM (Ubuntu 22.04 recommended) with Docker installed

## Running Locally

```bash
# Clone the repository
git clone https://github.com/ebenzotoo/capstone-group5.git
cd capstone-group5

# Start all three services
docker compose up -d

# Verify containers are running
docker compose ps
```

Then open your browser at `http://localhost:8080`.

## Building & Pushing Images to Docker Hub

```bash
# Log in to Docker Hub
docker login

# Build and tag images
docker build -t ebenzotoo/backend:v1.0 ./backend
docker build -t ebenzotoo/frontend:v1.0 ./frontend

# Push to Docker Hub
docker push ebenzotoo/backend:v1.0
docker push ebenzotoo/frontend:v1.0
```

## Manual Deployment to a Linux VM

```bash
# SSH into the VM
ssh <VM_USER>@<VM_IP>

# Install Docker (Ubuntu)
sudo apt update && sudo apt install -y docker.io docker-compose-plugin
sudo systemctl enable --now docker

# Pull and run the app
mkdir -p ~/capstone/db
cd ~/capstone

# Copy docker-compose.yml and db/init.sql to this directory, then:
docker compose pull
docker compose up -d
```

The app will be accessible at `http://<VM_IP>:8080`.

## GitHub Actions CI/CD Pipeline

The pipeline in [.github/workflows/deploy.yml](.github/workflows/deploy.yml) triggers on every push to `main` and:

1. **Builds** both Docker images
2. **Pushes** them to Docker Hub with `v1.0` and `latest` tags
3. **SSHs into the Linux VM** and runs `docker compose up -d`

### Required GitHub Secrets

Go to your repo → **Settings → Secrets and variables → Actions** and add:

| Secret Name          | Description                              |
|----------------------|------------------------------------------|
| `DOCKERHUB_USERNAME` | Your Docker Hub username (`ebenzotoo`)   |
| `DOCKERHUB_TOKEN`    | Docker Hub access token (not password)   |
| `VM_HOST`            | Public IP address of your Linux VM       |
| `VM_USER`            | SSH username on the VM (e.g. `ubuntu`)   |
| `VM_SSH_KEY`         | Private SSH key for VM access            |

## API Endpoints

| Method | Endpoint        | Description           |
|--------|-----------------|-----------------------|
| GET    | `/api/projects` | Fetch all projects    |

## Docker Hub Images

- [`ebenzotoo/frontend`](https://hub.docker.com/r/ebenzotoo/frontend)
- [`ebenzotoo/backend`](https://hub.docker.com/r/ebenzotoo/backend)
