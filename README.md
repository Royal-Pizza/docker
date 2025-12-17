# ⚙️ Royal Pizza - Docker Setup

**[EN](#en) | [FR](#fr)**

## <a id="en"></a>English

This repository contains all the Docker configuration necessary to launch the complete development environment (Java/Spring Backend and PostgreSQL Database).

## 📦 Project Architecture

```
Royal-Pizza/
├── backend/              # https://github.com/Royal-Pizza/backend
│
├── docker/               # https://github.com/Royal-Pizza/docker
│
└── frontend/             # https://github.com/Royal-Pizza/frontend
```

## 🎯 Purpose

This guide explains how to :
1. Launch the PostgreSQL database and backend using Docker Compose.
2. Backup and restore the database state.
3. Easily share an initial database state with other developers.

---

## 📂 `docker/` Directory Structure

| File/Folder | Description |
| :--- | :--- |
| `data/` | Contains volumes or data exports (ignore by Git if volatile data). |
| `backup.sql` | **Main backup of initial database state** (the "Golden Master"). |
| `docker-compose.yml` | Configuration file for container orchestration (`backend-app` and `postgres-db`). |
| `init.sql` | Initialization script executed on first PostgreSQL container startup (optional). |
| `restore-db.sh` | Script to restore database state from `backup.sql`. |
| `save-db.sh` | Script to update `backup.sql` with current database state. |
| `pizza.lo1` / `pizza.loo` | Looping file to visualize MCD |
| `README.md` | This file. |

---

## 🚀 Launch Database and Backend

This command launches the `postgres-db` and `backend-app` services.

**Key behavior:** If the PostgreSQL volume is empty, the initialization script will automatically restore **`backup.sql`** to provide an immediate working database.

```bash
docker compose -f docker/docker-compose.yml up --build
```

### Stop and remove containers and volumes

To stop all services and remove PostgreSQL volumes (useful to start with a clean database) :

```bash
docker compose -f docker/docker-compose.yml down --volumes
```

⚠️ Warning : this command deletes local data. Next time you restart, PostgreSQL will restore the database from backup.sql if the volume no longer exists.

### Backup current database

To update backup.sql with the current database state :

```bash
./save-db.sh
```

The backup.sql file will be overwritten. Useful for sharing latest data with other developers.

### Restore database from backup.sql

To restore the database to the exact state of backup.sql :

```bash
./restore-db.sh
```

Deletes the existing database and recreates it from backup.sql. Requires the PostgreSQL container to be running (docker compose up).

### Tips for new developers

1. Clone the repo.
2. Run `docker compose up --build`.
3. The database will be ready to use.
4. To reset the database, run `docker compose down --volumes` then restart.
5. Save your changes with `./save-db.sh` before pushing.

### Quick container diagram

```
+-------------------+        +---------------------+
| backend-app       | ---->  | postgres-db         |
| (Spring/Java)     |        | (PostgreSQL)        |
+-------------------+        +---------------------+
```

backend-app connects to PostgreSQL via jdbc:postgresql://postgres-db:5432/royal_pizza. PostgreSQL initializes the database from backup.sql if the volume is empty.

---

## <a id="fr"></a>Français

Ce dépôt contient l'ensemble de la configuration Docker nécessaire pour lancer l'environnement de développement complet (Backend Java/Spring et Base de Données PostgreSQL).

## 📦 Architecture du Projet

```
Royal-Pizza/
├── backend/              # https://github.com/Royal-Pizza/backend
│
├── docker/               # https://github.com/Royal-Pizza/docker
│
└── frontend/             # https://github.com/Royal-Pizza/frontend
```

## 🎯 Objectif

Ce guide explique comment :
1.  Lancer la base de données PostgreSQL et le backend en utilisant Docker Compose.
2.  Sauvegarder et restaurer l'état de la base de données.
3.  Partager facilement un état initial de la BDD avec les autres développeurs.

---

## 📂 Structure du Répertoire `docker/`

| Fichier/Dossier | Description |
| :--- | :--- |
| `data/` | Contient les volumes ou les exports de données (à ignorer par Git si ce sont des données volatiles). |
| `backup.sql` | **Sauvegarde principale de l'état initial de la base** (le "Golden Master"). |
| `docker-compose.yml` | Fichier de configuration pour l'orchestration des conteneurs (`backend-app` et `postgres-db`). |
| `init.sql` | Script d'initialisation exécuté lors du premier démarrage du conteneur PostgreSQL (optionnel). |
| `restore-db.sh` | Script pour restaurer l'état de la base depuis `backup.sql`. |
| `save-db.sh` | Script pour mettre à jour `backup.sql` avec l'état actuel de la base. |
| `pizza.lo1` / `pizza.loo` | Fichier looping pour visualiser MCD |
| `README.md` | Ce fichier. |

---

## 🚀 Lancer la Base de Données et le Backend

Cette commande lance les services `postgres-db` et `backend-app`.

**Comportement clé :** Si le volume PostgreSQL est vide, le script d'initialisation restaurera **`backup.sql` automatiquement** pour fournir une base de travail immédiate.

```bash
docker compose -f docker/docker-compose.yml up --build
```

### Arrêter et supprimer les conteneurs et volumes

Pour arrêter tous les services et supprimer les volumes PostgreSQL (utile pour repartir d'une base propre) :

```bash
docker compose -f docker/docker-compose.yml down --volumes
```

⚠️ Attention : cette commande supprime les données locales. La prochaine fois que vous relancez, PostgreSQL restaurera la base depuis backup.sql si le volume n'existe plus.

### Sauvegarder la base actuelle

Pour mettre à jour backup.sql avec l'état actuel de la base :

```bash
./save-db.sh
```

Le fichier backup.sql sera écrasé. Utile pour partager les dernières données avec d'autres développeurs.

### Restaurer la base depuis backup.sql

Pour remettre la base à l'état exact de backup.sql :

```bash
./restore-db.sh
```

Supprime la base existante et la recrée à partir de backup.sql. Nécessite que le conteneur PostgreSQL soit en fonctionnement (docker compose up).

### Conseils pour les nouveaux développeurs

1. Cloner le repo.
2. Lancer `docker compose up --build`.
3. La BDD sera prête à l'emploi.
4. Pour remettre la BDD à zéro, faire `docker compose down --volumes` puis relancer.
5. Sauvegarder vos modifications avec `./save-db.sh` avant de push.

### Diagramme rapide des conteneurs

```
+-------------------+        +---------------------+
| backend-app       | ---->  | postgres-db         |
| (Spring/Java)     |        | (PostgreSQL)        |
+-------------------+        +---------------------+
```

backend-app se connecte à PostgreSQL via jdbc:postgresql://postgres-db:5432/royal_pizza. PostgreSQL initialise la base à partir de backup.sql si le volume est vide.
