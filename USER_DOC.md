## Architecture

The infrastructure is composed of several isolated Docker services that communicate through a dedicated private network.

Each service is built from its own Docker image and fulfills a specific role:

* **NGINX**: Web server and reverse proxy.
* **WordPress**: PHP web application.
* **MariaDB**: Database management system used by WordPress.

Persistent data is stored in **Docker volumes**, ensuring it remains available even after the containers are removed.

The entire infrastructure is orchestrated with **Docker Compose**, allowing you to build, start, and manage all services with a single command.

---

## Usage

### Prerequisites

* [Docker Compose](https://docs.docker.com/engine/install/)

A **Makefile** is provided to simplify project management. It allows you to build the Docker images, start the services, stop the containers, and clean up the associated volumes.

### Available Commands

```bash
make build    # Build the Docker images
make up       # Start the infrastructure
make down -v  # Stop the containers and remove the volumes
```

---

## Accessing the Server

By default, **MariaDB** listens only on the local interface (`127.0.0.1`) and is therefore not accessible from outside the container.

The **NGINX** server is configured with the following domain name:

```text
jmassavi.42.fr
```

Once the containers are running, the WordPress administration dashboard is available at:

```text
https://jmassavi.42.fr/wp-admin/
```

---

## Environment Variables

The project configuration is centralized in the following file:

```text
srcs/.env
```

You can modify various settings there, such as database names, usernames, and other configuration values.

Passwords are stored separately using **Docker Secrets**.

At the root of the project, create a directory named:

```text
secrets/
```

It should contain the following files:

```text
admin_password.txt
mariadb_password.txt
user_password.txt
wordpress_db_password.txt
```

Each file must contain **only** the corresponding secret value, with no additional text or formatting.

