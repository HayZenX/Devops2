# Stage de test
FROM node:20-alpine as test

# Installation de pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copie des fichiers de dépendances
COPY package.json pnpm-lock.yaml ./

# Installation des dépendances
RUN pnpm install

# Copie du reste des fichiers
COPY . .

# Exécution des tests unitaires
RUN pnpm test

RUN apk add --no-cache chromium chromium-chromedriver firefox-esr
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
ENV PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser
RUN pnpm exec playwright install --with-deps
RUN pnpm test:e2e

FROM node:20-alpine as production

# Installation de pnpm
RUN npm install -g pnpm

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --prod

COPY . .

EXPOSE 3000

CMD ["pnpm", "dev"]