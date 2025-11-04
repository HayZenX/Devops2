# --- Étape 1 : Builder ---
# Utiliser une image Node.js avec Alpine pour une base légère
FROM node:20 AS builder

# Install pnpm via corepack (recommended)
RUN corepack enable pnpm

WORKDIR /app

# Copy dependency definitions
COPY package.json pnpm-lock.yaml ./

# Install all dependencies (including dev) for build
RUN pnpm install --frozen-lockfile

# Copy source and build
COPY . .

# Build the application (adjust if your builder step differs)
RUN pnpm build

FROM node:20-slim AS production

# Enable pnpm in production image
RUN corepack enable pnpm

# Create non-root user
RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup

WORKDIR /app

# Copy only production artifacts and lockfiles
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/pnpm-lock.yaml ./pnpm-lock.yaml
COPY --from=builder /app/dist ./dist

# Install production dependencies only
RUN pnpm install --prod --frozen-lockfile

# Switch to non-root user
USER appuser

# Expose runtime port (app uses port 3000 in dev/build)
EXPOSE 3000

# Start application (ensure this script exists in package.json)
CMD ["pnpm", "start"]