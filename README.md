# Bloglist Application

A full-stack blog application with a React frontend and Node.js/Express backend.

Public URL: https://bloglist-rk2gnq-dawn-resonance-6647.fly.dev/

## Tech Stack

- **Frontend**: React 19 + Vite 6
- **Backend**: Node.js + Express + MongoDB/Mongoose
- **Testing**: Vitest (frontend), Node test (backend)

## Project Structure

```
bloglist/
├── frontend/              # React + Vite frontend
│   ├── src/
│   │   ├── components/    # React components
│   │   ├── services/      # API client modules
│   │   └── App.jsx        # Main app component
│   ├── dev.Dockerfile     # Development container
│   ├── Dockerfile         # Production frontend container
│   └── package.json
├── backend/               # Express backend
│   ├── controllers/       # Route handlers
│   ├── models/            # Mongoose models
│   ├── tests/             # Tests
│   ├── utils/             # Helpers & config
│   ├── dev.Dockerfile     # Development container
│   ├── Dockerfile         # Production backend container
│   └── package.json
├── nginx.conf            # Production reverse proxy config
├── nginx.dev.conf        # Nginx reverse proxy config
├── docker-compose.dev.yml # Docker Compose for development
├── docker-compose.yml     # Docker Compose for production
└── Dockerfile             # Single-container production image
```

## Available Scripts

| Script                | Description                        |
| --------------------- | ---------------------------------- |
| `npm run dev`         | Start frontend + backend in dev mode |
| `npm run build`       | Build frontend for production       |
| `npm run lint`        | Run linter on both                |
| `npm test`           | Run backend tests                |
| `npm run client:test` | Run frontend tests               |

## Getting Started

### Prerequisites

- Node.js (v20+)
- Docker & Docker Compose (optional)

### Local Development

```bash
npm install
npm run dev
```

- Frontend: http://localhost:5173
- Backend: http://localhost:3001

### Docker Development

```bash
docker-compose -f docker-compose.dev.yml up --build
```

Services:
- Frontend: http://localhost (via nginx)
- Backend: http://localhost/api
- MongoDB: localhost:27017

### Production Build

```bash
npm run build
npm run server:start
```

Express serves static files from `backend/dist` and API routes from `/api/*`.

### Testing

```bash
npm test           # Backend tests
npm run client:test # Frontend tests
```

## Docker

### Development

```bash
docker-compose -f docker-compose.dev.yml up --build
```

Access at http://localhost. Nginx proxies:
- `/` → frontend (Vite dev server)
- `/api/*` → backend (Express)

### Production

Run the split production stack with Docker Compose:

```bash
JWT_SECRET=your-secret-key docker compose up --build
```

The public app is served by the `frontend` container on port `80` by default, uses the root `nginx.conf` mounted by Docker Compose to proxy `/api/*` to the backend container, and persists MongoDB data in the `mongodb_data` volume.

You can change the published port with `APP_PORT`, for example:

```bash
APP_PORT=8080 JWT_SECRET=your-secret-key docker compose up --build
```

The repository also keeps the original single-container production image:

```bash
docker build -t bloglist .
docker run -p 3001:3001 --env-file .env bloglist
```

## Deploy to Fly.io

```bash
fly launch --no-deploy
fly secrets set MONGODB_URI="mongodb://..."
fly secrets set JWT_SECRET="your-secret-key"
fly deploy
```

## API Endpoints

| Method   | Endpoint         | Description              |
| -------- | --------------- | ------------------------ |
| GET      | /api/blogs      | List all blogs           |
| POST     | /api/blogs      | Create new blog         |
| DELETE   | /api/blogs/:id  | Delete blog             |
| POST     | /api/login     | User login              |
| POST     | /api/users     | Create new user         |
| GET      | /api/health    | Health check            |

## Seed Data

On first run, the backend seeds sample data:
- Users: `david`, `alice`, `bob` (password: `password123`)
- 6 sample blogs
