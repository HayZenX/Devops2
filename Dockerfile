# Builder stage
FROM node:20-alpine AS builder

# Install pnpm
RUN corepack enable pnpm

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy application files
COPY . .

# Build the application
RUN pnpm build

# Production stage
FROM node:20-alpine AS production

# Install pnpm
RUN corepack enable pnpm

# Create non-root user
RUN addgroup --system appgroup && \
    adduser --system appuser --ingroup appgroup

# Set working directory
WORKDIR /app

# Copy built files and dependencies
COPY --from=builder --chown=appuser:appgroup /app/dist ./dist
COPY --from=builder --chown=appuser:appgroup /app/package.json ./package.json
COPY --from=builder --chown=appuser:appgroup /app/pnpm-lock.yaml ./pnpm-lock.yaml

# Install production dependencies only
RUN pnpm install --prod --frozen-lockfile

# Switch to non-root user
USER appuser

# Expose application port
EXPOSE 3000

# Start the application
CMD ["pnpm", "start"]