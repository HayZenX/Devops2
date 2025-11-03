# Stage de test
FROM mcr.microsoft.com/playwright:v1.40.0-focal as test

# Installation de pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copie des fichiers de configuration
COPY package.json pnpm-lock.yaml ./

# Installation des dépendances
RUN pnpm install

# Copie du reste des fichiers
COPY . .

# Configuration Playwright
ENV CI=true
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

# Exécution des tests unitaires
RUN pnpm test

# Installation des dépendances Playwright
RUN npx playwright install chromium --with-deps

FROM node:20-alpine as production

# Installation de pnpm
RUN npm install -g pnpm

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --prod

COPY . .

EXPOSE 3000

CMD ["pnpm", "dev"]