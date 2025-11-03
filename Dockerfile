# --- Étape 1 : Builder ---
# Utiliser une image de base complète pour compiler/installer les dépendances
FROM node:20-alpine AS builder

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de définition de dépendances pour profiter du cache Docker
COPY package*.json ./

# Installer les dépendances
# Utilisez --omit=dev si vous n'avez pas besoin des dépendances de développement dans le conteneur final
RUN npm install --omit=dev

# Copier le reste du code
COPY . .

# Si votre application nécessite une étape de compilation (ex: TypeScript, React build)
# RUN npm run build

# --- Étape 2 : Production ---
# Utiliser une image de base légère pour l'exécution (meilleure sécurité et taille)
FROM node:20-slim AS production

# Créer un utilisateur non-root pour l'exécution (sécurité accrue)
RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup
USER appuser

# Définir le répertoire de travail
WORKDIR /app

# Copier uniquement les fichiers nécessaires depuis l'étape 'builder'
# Ici on copie node_modules et le code source compilé/prêt à l'emploi
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules
# Si vous avez une étape de build, copiez le répertoire de build (ex: dist)
# COPY --from=builder --chown=appuser:appgroup /app/dist ./dist 
COPY --from=builder --chown=appuser:appgroup /app/src ./src
COPY --from=builder --chown=appuser:appgroup /app/package.json ./package.json

# Exposer le port de l'application
EXPOSE 8080

# Définir la commande de lancement de l'application
CMD ["node", "src/index.js"]