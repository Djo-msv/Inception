## Architecture

L'infrastructure repose sur plusieurs services Docker isolés qui communiquent via un réseau privé dédié.

Chaque service est construit à partir de sa propre image Docker et remplit un rôle spécifique :

* **NGINX** : serveur web et reverse proxy.
* **WordPress** : application web PHP.
* **MariaDB** : système de gestion de base de données utilisé par WordPress.

Les données persistantes sont stockées dans des **volumes Docker**, ce qui permet de les conserver même après la suppression des conteneurs.

L'ensemble des services est orchestré par **Docker Compose**, permettant de construire, lancer et gérer toute l'infrastructure avec une seule commande.

---

## Utilisation

### Prérequis

* [Docker Compose](https://docs.docker.com/engine/install/)

Un **Makefile** est fourni afin de simplifier la gestion du projet. Il permet notamment de construire les images, démarrer les services, arrêter les conteneurs et nettoyer les volumes.

### Commandes disponibles

```bash
make build    # Construction des images Docker
make up       # Démarrage de l'infrastructure
make down -v  # Arrêt des conteneurs et suppression des volumes
```

---

## Accès au serveur

Par défaut, **MariaDB** n'écoute que sur l'adresse locale (`127.0.0.1`) et n'est donc pas accessible depuis l'extérieur.

Le serveur **NGINX** est configuré avec le nom de domaine :

```
jmassavi.42.fr
```

Une fois les conteneurs démarrés, l'interface d'administration de WordPress est accessible à l'adresse suivante :

```
https://jmassavi.42.fr/wp-admin/
```

---

## Variables d'environnement

La configuration du projet est centralisée dans le fichier :

```
srcs/.env
```

Vous pouvez y modifier différents paramètres (utilisateurs, base de données, etc.).

Les mots de passe sont stockés séparément grâce au système de **Docker Secrets**.

À la racine du projet, créez un dossier :

```
secrets/
```

Il doit contenir les fichiers suivants :

```
admin_password.txt
mariadb_password.txt
user_password.txt
wordpress_db_password.txt
```

Chaque fichier doit contenir uniquement la valeur du secret correspondant, sans information supplémentaire.
