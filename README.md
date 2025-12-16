# ⚙️ Royal Pizza - Setup de la Base de Données et du Stack

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

Pour arrêter tous les services et supprimer les volumes PostgreSQL (utile pour repartir d’une base propre) :

```bash
docker compose -f docker/docker-compose.yml down --volumes
```

⚠️ Attention : cette commande supprime les données locales. La prochaine fois que vous relancez, PostgreSQL restaurera la base depuis backup.sql si le volume n’existe plus.

### Sauvegarder la base actuelle
Pour mettre à jour backup.sql avec l’état actuel de la base :

```bash
./save-db.sh
```

Le fichier backup.sql sera écrasé. Utile pour partager les dernières données avec d’autres développeurs.

### Restaurer la base depuis backup.sql
Pour remettre la base à l’état exact de backup.sql :

```bash
./restore-db.sh
```

Supprime la base existante et la recrée à partir de backup.sql. Nécessite que le conteneur PostgreSQL soit en fonctionnement (docker compose up).

### Conseils pour les nouveaux développeurs

1. Cloner le repo.
2. Lancer `docker compose up --build`.
3. La BDD sera prête à l’emploi.
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