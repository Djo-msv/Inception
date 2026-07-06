# Developer Documentation

This documentation describes the internal architecture of the **Inception** project and the technical decisions made during its implementation.

---

# Project Structure

```text
.
├── Makefile
├── srcs
│   ├── docker-compose.yml
│   ├── .env
│   ├── requirements
│   │   ├── mariadb
│   │   ├── nginx
│   │   └── wordpress
│   └── secrets
└── README.md
```

Each service has its own directory containing:

* a `Dockerfile`;
* an initialization script;
* the required configuration files.

---

# Startup Sequence

The services are started in the following order:

1. Create the Docker network.
2. Create the Docker volumes.
3. Build the Docker images.
4. Start the MariaDB container.
5. Initialize the database.
6. Start the WordPress container.
7. Automatically install WordPress using WP-CLI.
8. Start the NGINX container.
9. The reverse proxy becomes available on port **443**.

The `depends_on` directive only guarantees the startup order of the containers. The initialization scripts wait until the required services are actually available before proceeding.

---

# Docker Compose

The `docker-compose.yml` file is responsible for:

* creating the Docker network;
* mounting persistent volumes;
* injecting environment variables;
* building the Docker images;
* defining service dependencies.

No official Docker images are used directly. All images are built from the project's own Dockerfiles, as required by the project specifications.

---

# MariaDB

## Purpose

MariaDB stores all WordPress data.

## Initialization

On the first startup, the container:

* creates the database;
* creates the WordPress user;
* grants the required permissions.

The database files are stored in a Docker volume to ensure data persists even after the containers are removed.

---

# WordPress

## Purpose

Provide the CMS.

## Automatic Installation

The container checks whether WordPress is already installed.

If it is not, it performs the following steps:

* downloads WordPress;
* generates the `wp-config.php` file;
* installs WordPress using WP-CLI;
* creates the administrator account;
* creates a regular user account.

On subsequent restarts, these steps are skipped if WordPress has already been installed.

---

# NGINX

NGINX acts as a reverse proxy.

Its responsibilities include:

* TLS termination;
* serving static files;
* forwarding PHP requests to PHP-FPM.

The TLS certificate is generated automatically during the image build.

---

# Volumes

The project uses two persistent Docker volumes.

## MariaDB Volume

Stores:

* databases;
* users;
* tables.

## WordPress Volume

Stores:

* website files;
* plugins;
* uploaded media.

These volumes allow the containers to be recreated without losing any persistent data.

---

# Network

The three containers communicate through a private Docker bridge network.

```text
Internet
│
▼
NGINX
│
▼
WordPress
│
▼
MariaDB
```

MariaDB is never exposed outside the Docker network.

Only NGINX publishes a port to the host.

---

# Environment Variables

Non-sensitive configuration values are stored in the `.env` file.

Sensitive information is stored using Docker Secrets.

Each service automatically reads these files during startup.

---

# Initialization Scripts

Each service includes an `entrypoint` script responsible for:

* preparing the environment;
* verifying prerequisites;
* performing first-time installation tasks;
* starting the main process.

The final process is executed with `exec` so that it becomes the container's PID 1.

---

# Rebuilding the Project

To completely rebuild the project:

```bash
make down -v
make build
make up
```
