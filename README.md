# Environment-for-database

A Docker-based local development environment for the **Celestial Eye** backend database.
It bundles a PostgreSQL database together with the [Adminer](https://www.adminer.org/) web UI so you can inspect and manage all backend data from your browser.

---

## Prerequisites

| Tool | Minimum version |
|------|-----------------|
| [Docker](https://docs.docker.com/get-docker/) | 20.x |
| [Docker Compose](https://docs.docker.com/compose/install/) | v2 (comes with Docker Desktop) |

---

## Quick start

```bash
# 1. Copy the example environment file and set your own credentials
cp .env.example .env
# Edit .env and change POSTGRES_PASSWORD before first run

# 2. Start all services
docker compose up -d

# 3. Open the database UI in your browser
open http://localhost:8080
```

### Adminer login details

| Field    | Value (matches your `.env`) |
|----------|-----------------------------|
| System   | PostgreSQL                  |
| Server   | `db`                        |
| Username | `POSTGRES_USER` from `.env` |
| Password | `POSTGRES_PASSWORD` from `.env` |
| Database | `POSTGRES_DB` from `.env`   |

---

## Environment variables

All configuration lives in `.env` (copy from `.env.example`).

| Variable | Default | Description |
|----------|---------|-------------|
| `POSTGRES_DB` | `celestial_eye` | Database name |
| `POSTGRES_USER` | `celestial_admin` | Database superuser |
| `POSTGRES_PASSWORD` | — | **Must be changed** before first run |
| `POSTGRES_PORT` | `5432` | Host port mapped to PostgreSQL |
| `ADMINER_PORT` | `8080` | Host port for the Adminer web UI |

---

## Database schema

The initial schema is applied automatically on first start from `init/01_schema.sql`:

| Table | Purpose |
|-------|---------|
| `users` | Backend user accounts |
| `sessions` | Authentication tokens |
| `celestial_objects` | Core catalogue of stars, planets, galaxies, etc. |
| `observations` | User observation logs |

A small set of seed rows is inserted into `celestial_objects` so the database is not empty on first login.

---

## Useful commands

```bash
# View running containers
docker compose ps

# Tail database logs
docker compose logs -f db

# Connect via psql
docker compose exec db psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"

# Stop and remove containers (data volume is preserved)
docker compose down

# Stop and remove containers AND wipe the data volume
docker compose down -v
```

---

## Project structure

```
.
├── docker-compose.yml   # Service definitions (PostgreSQL + Adminer)
├── .env.example         # Environment variable template
├── init/
│   └── 01_schema.sql    # Initial schema + seed data (auto-applied on first start)
└── README.md
```
