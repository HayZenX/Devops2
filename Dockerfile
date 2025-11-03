FROM node:20-alpine

# Install pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copy package files first to leverage Docker cache
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy source
COPY . .

# Build the app (if build script exists)
RUN pnpm build || true

EXPOSE 3000

# Start the app (use start script from package.json)
CMD ["pnpm", "start"]