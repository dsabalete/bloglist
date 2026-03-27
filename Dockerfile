# syntax = docker/dockerfile:1

# Build stage
FROM node:20-alpine AS build

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY server/package*.json ./server/
COPY client/package*.json ./client/

# Install root dependencies
RUN npm ci

# Install server dependencies and build client
RUN cd server && npm ci
RUN cd client && npm ci && npm run build

# Production stage
FROM node:20-alpine AS production

WORKDIR /app

# Copy package files and server directory
COPY package*.json ./
COPY server ./server

# Install production dependencies for root and server
WORKDIR /app/server
RUN npm ci --omit=dev
WORKDIR /app
RUN npm ci --omit=dev

# Copy built client files
COPY --from=build /app/server/dist ./server/dist

# Expose port (should match PORT in fly.toml)
EXPOSE 3001

# Start the server
CMD ["node", "server/index.js"]
