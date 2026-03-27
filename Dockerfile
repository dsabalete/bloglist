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

WORKDIR /app/server

# Copy server files
COPY server/ ./
COPY --from=build /app/server/dist ./dist

# Install dependencies
RUN npm ci --omit=dev

EXPOSE 3001

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "fetch('http://localhost:3001/api/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"

CMD ["node", "index.js"]
