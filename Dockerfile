# --- Étape 1 : Builder ---
# Utiliser une image Node.js avec Alpine pour une base légère
FROM node:20-alpine AS builder

# Installation de pnpm
RUN npm install -g pnpm

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de définition de dépendances pour profiter du cache Docker
# pnpm nécessite pnpm-lock.yaml et package.json
COPY package.json pnpm-lock.yaml ./

# Installer les dépendances
# Utiliser l'option --production si vous ne voulez pas des devDependencies dans le conteneur final (RECOMMANDÉ)
RUN pnpm install --prod

# Copier le reste du code
COPY . .

# Si votre application nécessite une compilation (ex: TypeScript, React build), exécutez la ici
# RUN pnpm run build

# --- Étape 2 : Production (Image légère et sécurisée) ---
FROM node:20-slim AS production

# Installation de pnpm globalement pour garantir l'exécution de l'application si besoin
RUN npm install -g pnpm

# Créer un utilisateur non-root pour l'exécution (sécurité)
RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup
USER appuser

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers nécessaires depuis l'étape 'builder'
# On copie pnpm-lock.yaml et package.json pour les commandes de démarrage si besoin
COPY --from=builder --chown=appuser:appgroup /app/package.json ./
COPY --from=builder --chown=appuser:appgroup /app/pnpm-lock.yaml ./
# Copier le dossier de modules pnpm
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules
# Copier le code source ou le répertoire de build (ex: dist)
COPY --from=builder --chown=appuser:appgroup /app/src ./src

# Exposer le port de l'application
EXPOSE 8080

# Définir la commande de lancement de l'application
# **ACTION REQUISE : Vérifiez cette commande pour votre application spécifique**
CMD ["pnpm", "start"]