# Personalityshop Client Docker Image

## What is Personalityshop-client

Personalityshop-client is a frontend web application built with React, React-Router (Node.js + Vite).

This Docker image uses a multi-stage build to:

- Build the application in a Node.js environment
- Serve the generated static files using Nginx

Nginx is a high-performance web server commonly used to serve static content efficiently, with low memory usage and high concurrency.

---

## Multi-Container Application Context

This image is not intended to run standalone. It is part of a multi-container application that works together with:

- Personalityshop-server (backend API)
- MongoDB (database)
- Mongo Express (database UI)

These services are orchestrated using Docker Compose, allowing them to communicate over a shared network.

The frontend communicates with the backend via API requests, which are routed internally within the Docker network.

---

## Environment Variables (.env)

Before running the application, you must configure a `.env` file with the required environment variables.

### Required variables include:

- **Frontend**
  - `VITE_API_URL` → URL of the backend API

- **Backend / Database**
  - `MONGO_URI`
  - `MONGO_USER`
  - `MONGO_PASSWORD`

- **Firebase**
  - Firebase configuration keys

These variables are injected into the containers at runtime via Docker Compose.

---

## Nginx Configuration

The frontend container includes a custom `nginx.conf` file to properly handle application behavior.

### Key features:

- **SPA Routing Support**
  ```nginx
  try_files $uri $uri/ /index.html;
  ```

Ensures that all non-file requests are redirected to index.html, allowing React Router to handle client-side navigation.

### Reverse Proxy to Backend

```nginx
location /api
location /images
```

Requests to /api and /images are forwarded to the personalityshop-server container.

### Benefits of this setup:

- Simplifies frontend API calls (no need for hardcoded backend URLs)
- Enables seamless communication between containers
- Avoids CORS issues by routing through the same origin

## How It Works Together

When running with Docker Compose:

1. The frontend is served via Nginx
2. API requests (/api, /images) are proxied to the backend container
3. The backend connects to MongoDB using environment variables
4. All services communicate over the same Docker network

### Docker Compose Configuration

```yaml
services:
  mongo:
    image: mongo
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGO_USER}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD}
    ports:
      - '27017:27017'
    volumes:
      - mongo_data:/data/db
    networks:
      - app-network

  mongo-express:
    image: mongo-express
    restart: unless-stopped
    ports:
      - '8081:8081'
    environment:
      ME_CONFIG_MONGODB_URL: mongodb://mongo:27017/
      ME_CONFIG_BASICAUTH_ENABLED: true
      ME_CONFIG_BASICAUTH_USERNAME: ${MONGO_EXPRESS_USER}
      ME_CONFIG_BASICAUTH_PASSWORD: ${MONGO_EXPRESS_PASSWORD}
    networks:
      - app-network

  personalityshop-server:
    image: dstuartkelly/personalityshop-server:latest
    container_name: personalityshop-server
    ports:
      - '3001:3001'
    environment:
      MONGO_URI: ${MONGO_URI}
      PORT: 3001
      MONGO_USER: ${MONGO_USER}
      MONGO_PASSWORD: ${MONGO_PASSWORD}
    networks:
      - app-network

  personalityshop-client:
    image: dstuartkelly/personalityshop-client:latest
    container_name: personalityshop-client
    ports:
      - '80:80'
    environment:
      VITE_API_URL: ${VITE_API_URL}
    networks:
      - app-network

volumes:
  mongo_data:

networks:
  app-network:
```
