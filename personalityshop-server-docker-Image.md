# Personalityshop Server Docker Image

## What is Personalityshop-server

Personalityshop-server is a backend REST API built with Node.js, Express, and Mongoose.

This Docker image:

- Runs the application in a lightweight Node.js 20 Alpine environment
- Connects to a MongoDB database for data persistence
- Exposes a REST API on port 3001 for the Personalityshop client application

---

## Multi-Container Application Context

This image is not intended to run standalone. It is part of a multi-container application that works together with:

- Personalityshop-client (frontend UI)
- MongoDB (database)
- Mongo Express (database UI)

These services are orchestrated using Docker Compose, allowing them to communicate over a shared network.

The server receives API requests from the client and communicates with MongoDB for data storage and retrieval.

---

## Environment Variables (.env)

Before running the application, you must configure a `.env` file with the required environment variables.

### Required variables include:

- **Database**
  - `MONGO_URI` → Full MongoDB connection string
  - `MONGO_USER` → MongoDB root username
  - `MONGO_PASSWORD` → MongoDB root password

- **Server**
  - `PORT` → Port the server listens on (default: 3001)

These variables are injected into the container at runtime via Docker Compose.

---

## Docker Entrypoint

The server container includes a custom `docker-entrypoint.sh` script that runs before the application starts.

### Key features:

- **MongoDB Readiness Check**
  ```sh
  until nc -z mongo 27017; do
    echo "Waiting for MongoDB..."
    sleep 2
  done
  ```
  Waits for the MongoDB container to be available before proceeding, preventing connection errors on startup.

- **Automatic Database Seeding**

  On first run, the entrypoint checks if the `products` collection is empty. If no products exist, it automatically runs `npm run seed` to populate the database with initial data.

---

## API Routes

The server exposes the following API endpoints:

- `/api/products` → Product catalogue
- `/api/profile` → User profiles
- `/api/orders` → Order management
- `/api/contact` → Contact form submissions
- `/images` → Static product images

---

## How It Works Together

When running with Docker Compose:

1. The MongoDB container starts and initialises with root credentials
2. The server container waits for MongoDB to be ready
3. If the database is empty, the server seeds it with initial product data
4. The server starts listening on port 3001
5. API requests from the client are handled and data is read/written to MongoDB
6. All services communicate over the same Docker network

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
