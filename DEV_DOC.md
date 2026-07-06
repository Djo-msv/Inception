# Developer Documentation

Cette documentation décrit le fonctionnement interne du projet Inception ainsi que les choix techniques effectués.

---

# Arborescence
```.
├── Makefile
├── srcs
│ ├── docker-compose.yml
│ ├── .env
│ ├── requirements
│ │ ├── mariadb
│ │ ├── nginx
│ │ └── wordpress
│ └── secrets
└── README.md
```

Chaque service possède son propre dossier contenant :

- un `Dockerfile`
- un script d'initialisation
- les fichiers de configuration nécessaires

---

# Cycle de démarrage

Le démarrage suit l'ordre suivant :

1. Création du réseau Docker.
2. Création des volumes.
3. Construction des images.
4. Lancement de MariaDB.
5. Initialisation de la base de données.
6. Lancement de WordPress.
7. Installation automatique de WordPress via WP-CLI.
8. Lancement de NGINX.
9. Le reverse proxy devient accessible sur le port 443.

L'utilisation de `depends_on` garantit uniquement l'ordre de lancement des conteneurs. Les scripts d'initialisation attendent que les services soient réellement disponibles avant de poursuivre.

---

# Docker Compose

Le fichier `docker-compose.yml` est responsable de :

- créer le réseau Docker ;
- monter les volumes persistants ;
- injecter les variables d'environnement ;
- construire les images ;
- définir les dépendances entre services.

Aucune image officielle n'est utilisée directement. Toutes les images sont construites à partir des Dockerfiles du projet conformément au sujet.

---

# MariaDB

## Objectif

MariaDB stocke toutes les données de WordPress.

## Initialisation

Lors du premier lancement :

- création de la base de données ;
- création de l'utilisateur WordPress ;
- attribution des permissions.

Les données sont stockées dans un volume Docker afin d'être conservées après la suppression des conteneurs.

---

# WordPress

## Objectif

Fournir le CMS.

## Installation automatique

Le conteneur vérifie si WordPress est déjà installé.

Si ce n'est pas le cas :

- téléchargement de WordPress ;
- génération du fichier `wp-config.php` ;
- installation via WP-CLI ;
- création de l'utilisateur administrateur ;
- création d'un utilisateur classique.

Au redémarrage, ces opérations sont ignorées si WordPress est déjà installé.

---

# NGINX

NGINX agit comme reverse proxy.

Responsabilités :

- terminaison TLS ;
- distribution des fichiers statiques ;
- transfert des requêtes PHP vers PHP-FPM.

Le certificat TLS est généré automatiquement durant le build.

---

# Volumes

Deux volumes sont utilisés.

## MariaDB

Contient :

- les bases de données ;
- les utilisateurs ;
- les tables.

## WordPress

Contient :

- les fichiers du site ;
- les plugins ;
- les uploads.

Ces volumes permettent de recréer entièrement les conteneurs sans perdre les données.

---

# Réseau

Les trois conteneurs communiquent via un réseau bridge privé.
