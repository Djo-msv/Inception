# Inception

Ce projet a été créé dans le cadre du programme **42** par **jmassavi**.

## Description

Ce projet consiste à mettre en place une petite infrastructure composée de plusieurs services Docker, en respectant des règles spécifiques. L'objectif est de découvrir la conteneurisation avec Docker, la création d'images personnalisées, la gestion des volumes, des réseaux et des services.

## Instructions

### Prérequis

* [Docker Compose](https://docs.docker.com/engine/install/)

Un **Makefile** est inclus afin de simplifier la gestion du projet. Il permet de construire les images, démarrer les conteneurs, les arrêter ainsi que supprimer automatiquement les volumes.

Exemples de commandes :

```bash
make build
make up
make down -v
```

D'autres commandes sont disponibles avec :

```bash
make help
```

## Choix d'infrastructure

### Virtual Machines vs Docker

La différence entre les machines virtuelles (VM) et Docker est importante, notamment en matière de performances.

Un conteneur Docker partage le noyau du système d'exploitation de l'hôte, tandis qu'une machine virtuelle embarque son propre système d'exploitation complet. Les conteneurs sont donc beaucoup plus légers, consomment moins de ressources et démarrent en quelques secondes, là où une VM nécessite davantage de mémoire et de temps de démarrage.

Docker fonctionne également à partir d'**images** immuables. Une image décrit précisément l'environnement d'exécution d'une application, ce qui garantit qu'elle pourra être déployée de manière identique sur n'importe quelle machine compatible. Cela permet d'éviter le célèbre problème :

> « Ça marche sur ma machine. »

### Secrets vs Environment Variables

Les variables d'environnement sont simples à utiliser mais ne sont pas conçues pour stocker des informations sensibles. Elles peuvent être consultées depuis le conteneur, apparaître dans les métadonnées Docker ou être exposées dans les journaux, ce qui représente un risque de sécurité lorsqu'elles contiennent des mots de passe, des clés API ou d'autres données confidentielles.

Les **Docker Secrets** ont été conçus pour répondre à ce problème. Les secrets sont stockés de manière sécurisée par Docker et sont montés dans le conteneur sous forme de fichiers temporaires accessibles uniquement aux processus autorisés. Ils ne sont pas intégrés dans l'image et limitent ainsi le risque de fuite d'informations sensibles.

### Docker Network vs Host Network

Par défaut, Docker crée des réseaux virtuels qui permettent aux conteneurs de communiquer entre eux tout en restant isolés du réseau de la machine hôte. Chaque conteneur possède sa propre adresse IP privée, ce qui améliore la sécurité et facilite l'organisation des services.

Le mode **host**, quant à lui, désactive cette isolation : le conteneur utilise directement le réseau de la machine hôte. Cela peut offrir de meilleures performances réseau, mais réduit l'isolation et augmente les risques de conflits de ports ou de sécurité. Pour cette raison, le mode **bridge** (réseau Docker par défaut) est généralement préféré pour les architectures composées de plusieurs services.

### Docker Volumes vs Bind Mounts

Docker propose deux méthodes principales pour persister les données.

Les **Volumes** sont entièrement gérés par Docker. Ils sont indépendants de l'arborescence du système hôte, facilitent les sauvegardes, les migrations et offrent de meilleures performances sur certaines plateformes. Ils constituent la solution recommandée pour les données de production, comme les bases de données.

Les **Bind Mounts** relient directement un dossier du système hôte à un dossier du conteneur. Cette solution est particulièrement pratique durant le développement, car les modifications effectuées sur les fichiers sont immédiatement visibles depuis le conteneur. En revanche, elle crée une dépendance avec l'organisation des fichiers de la machine hôte et peut poser des problèmes de portabilité.

Dans ce projet, les **Volumes Docker** sont privilégiés afin d'assurer la persistance des données tout en conservant une infrastructure facilement reproductible.

## Architecture

L'infrastructure est composée de plusieurs services isolés qui communiquent grâce à un réseau Docker dédié.

Chaque service est construit à partir de sa propre image Docker et possède un rôle précis :

* **NGINX** : serveur web et reverse proxy.
* **WordPress** : application web PHP.
* **MariaDB** : base de données utilisée par WordPress.

Les données persistantes sont stockées dans des volumes Docker afin qu'elles soient conservées même après la suppression des conteneurs.

L'ensemble est orchestré par **Docker Compose**, qui permet de lancer tous les services avec une seule commande et de gérer leurs dépendances.

## Ressources

### Docker

* [Documentation officielle](https://docs.docker.com/compose/)

### Nginx

* [Image officielle](https://github.com/nginx/docker-nginx)
* [Configuration de Nginx avec Docker](https://www.docker.com/blog/how-to-use-the-official-nginx-docker-image/)
* [How to Build a Custom Nginx Image](https://www.datacamp.com/tutorial/nginx-docker)

### WordPress

* [Image officielle](https://github.com/docker-library/wordpress)
* [csenelle le GOAT](https://github.com/Kamisenin)

### MariaDB

* [Documentation officielle](https://mariadb.com/docs)
* [Image officielle](https://github.com/MariaDB/mariadb-docker)
