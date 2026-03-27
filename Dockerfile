# syntax = docker/dockerfile:1

# Build stage
FROM node:20-alpine AS build

WORKDIR /app

# Copy client files for build
COPY client/package*.json client/
RUN npm ci --prefix client

# Build client
COPY client/ client/
RUN npm run build --prefix client

# Production stage
FROM node:20-alpine AS production

WORKDIR /app

# Copy only server files (not root, not client)
COPY server/package*.json server/
COPY server/index.js server/app.js server/controllers server/models server/utils ./server/
COPY --from=build /app/server/dist ./server/dist

# Install server dependencies only
WORKDIR /app/server
RUN npm ci --omit=dev

WORKDIR /app

# Expose port
EXPOSE 3001

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "fetch('http://localhost:3001/api/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"

# Start the server
CMD ["node", "server/index.js"]
