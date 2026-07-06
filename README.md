# Inception

This project was developed as part of the **42** curriculum by **jmassavi**.

## Description

This project consists of setting up a small infrastructure composed of several Docker services while following a set of specific requirements. The goal is to gain hands-on experience with containerization using Docker, creating custom images, and managing volumes, networks, and services.

## Instructions

### Prerequisites

* [Docker Compose](https://docs.docker.com/engine/install/)

A **Makefile** is included to simplify project management. It allows you to build the images, start and stop the containers, and automatically remove the associated volumes.

Example commands:

```bash
make build
make up
make down -v
```

Additional commands are available with:

```bash
make help
```

## Infrastructure Choices

### Virtual Machines vs Docker

The difference between virtual machines (VMs) and Docker is significant, especially in terms of performance.

A Docker container shares the host operating system's kernel, whereas a virtual machine runs its own complete operating system. As a result, containers are much lighter, consume fewer resources, and start within seconds, while VMs require more memory and take longer to boot.

Docker also relies on immutable **images**. An image precisely defines an application's runtime environment, ensuring that it can be deployed consistently on any compatible machine. This helps eliminate the well-known problem:

> "It works on my machine."

### Secrets vs Environment Variables

Environment variables are easy to use but are not designed to store sensitive information. They can be accessed from within the container, appear in Docker metadata, or be exposed in logs, making them unsuitable for passwords, API keys, or other confidential data.

**Docker Secrets** were designed to address this issue. Secrets are securely stored by Docker and mounted into containers as temporary files that are accessible only to authorized processes. Since they are not embedded in the image, they significantly reduce the risk of exposing sensitive information.

### Docker Network vs Host Network

By default, Docker creates virtual networks that allow containers to communicate with one another while remaining isolated from the host machine's network. Each container has its own private IP address, improving security and making service organization easier.

The **host** networking mode disables this isolation by allowing the container to use the host's network stack directly. While this can provide better network performance, it also reduces isolation and increases the risk of port conflicts and security issues. For this reason, the default **bridge** network is generally preferred for multi-service architectures.

### Docker Volumes vs Bind Mounts

Docker provides two main ways to persist data.

**Volumes** are fully managed by Docker. They are independent of the host filesystem, making backups and migrations easier while offering better performance on some platforms. They are the recommended solution for production data, such as databases.

**Bind mounts** directly map a directory from the host machine to a directory inside the container. This approach is especially convenient during development because changes made to files on the host are immediately reflected inside the container. However, it creates a dependency on the host's filesystem structure and may reduce portability.

In this project, **Docker Volumes** are preferred to ensure data persistence while keeping the infrastructure easily reproducible.

## Architecture

The infrastructure consists of several isolated services that communicate through a dedicated Docker network.

Each service is built from its own Docker image and serves a specific purpose:

* **NGINX**: Web server and reverse proxy.
* **WordPress**: PHP web application.
* **MariaDB**: Database used by WordPress.

Persistent data is stored in Docker volumes, ensuring it remains available even after the containers are removed.

The entire infrastructure is orchestrated with **Docker Compose**, allowing all services to be started with a single command while managing their dependencies automatically.

## Resources

### Docker

* [Official Documentation](https://docs.docker.com/compose/)

### NGINX

* [Official Image](https://github.com/nginx/docker-nginx)
* [Using the Official NGINX Docker Image](https://www.docker.com/blog/how-to-use-the-official-nginx-docker-image/)
* [How to Build a Custom NGINX Image](https://www.datacamp.com/tutorial/nginx-docker)

### WordPress

* [Official Image](https://github.com/docker-library/wordpress)
* [csenelle](https://github.com/Kamisenin)

### MariaDB

* [Official Documentation](https://mariadb.com/docs)
* [Official Image](https://github.com/MariaDB/mariadb-docker)
