# Bloglist Application

A full-stack blog application with a React frontend and Node.js/Express backend.

## Tech Stack

- **Frontend**: React + Vite
- **Backend**: Node.js + Express
- **Testing**: Jest (server), React Testing Library (client)

## Project Structure

```
bloglist/
├── client/              # React frontend
│   ├── src/
│   │   ├── components/  # React components
│   │   ├── services/    # API client modules
│   │   └── App.jsx      # Main app component
│   └── package.json
├── server/              # Express backend
│   ├── controllers/     # Route handlers
│   ├── models/          # Mongoose models
│   ├── tests/           # Jest tests
│   ├── utils/           # Helpers & config
│   └── app.js           # Express app setup
└── package.json         # Root scripts
```

## Available Scripts

| Script                | Description                               |
| --------------------- | ----------------------------------------- |
| `npm run dev`         | Start both frontend & backend in dev mode |
| `npm run build`       | Build frontend for production             |
| `npm run lint`        | Run linter on both client & server        |
| `npm test`            | Run backend tests                         |
| `npm run client:test` | Run frontend tests                        |

## Getting Started

### Prerequisites

- Node.js (v18+)
- MongoDB (for the backend)

### Installation

```bash
npm install
```

### Development

```bash
# Run both client and server (uses Vite proxy)
npm run dev
```

- Frontend: http://localhost:3000
- Backend: http://localhost:3001

### Production Build & Deploy

The app deploys as a single unit. Express serves both the API and the built frontend.

```bash
# Build client → outputs to server/dist
npm run build

# Start production server
npm run server:start
```

The Express server serves static files from `server/dist` and API routes from `/api/*`.

- Frontend: http://localhost:3000
- Backend: http://localhost:3001

### Testing

```bash
# Backend tests
npm test

# Frontend tests
npm run client:test
```

## API Endpoints

- `GET /api/blogs` - List all blogs
- `POST /api/blogs` - Create a new blog
- `DELETE /api/blogs/:id` - Delete a blog
- `POST /api/login` - User login
- `POST /api/users` - Create a new user
