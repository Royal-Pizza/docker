## Lancer et arrêter la base de données avec Docker Compose

### Commandes pour gérer la base de données :

1. **Démarrer la base de données** :
   ```bash
   docker compose -f docker/docker-compose.yml up

1. **Arrêter et supprimer les volumes associés :** :
   ```bash
   docker compose -f docker/docker-compose.yml down -v