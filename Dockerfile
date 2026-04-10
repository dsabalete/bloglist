FROM node:20-alpine

WORKDIR /app

COPY frontend/package*.json frontend/
RUN cd frontend && npm ci --omit=dev

COPY backend/package*.json backend/
RUN cd backend && npm ci --omit=dev

COPY frontend/ frontend/
COPY backend/ backend/

RUN cd frontend && npm run build

EXPOSE 3001
ENV NODE_ENV=production PORT=3001

CMD ["node", "backend/index.js"]