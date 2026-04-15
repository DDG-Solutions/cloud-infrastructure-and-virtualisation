# Personalityshop Client Docker Image

## What is Personalityshop-client

**Personalityshop-client** is a frontend web application built with modern JavaScript tooling (Node.js + Vite).

This Docker image uses a **multi-stage build** to:

- Build the application in a Node.js environment
- Serve the generated static files using Nginx

Nginx is a high-performance web server commonly used to serve static content efficiently, with low memory usage and high concurrency.

---

## How to use this image

This image follows the approach recommended in the official Nginx Docker documentation for serving static content.

### Get the app

GitHub repository:

https://github.com/DDG-Solutions/PersonalityShop-Client

### Build the image

docker build -t personalityshop-client .

## Run the container

docker run -d -p 8080:80 personalityshop-client

Then access the application at:

http://localhost:8080

## How it works

The Dockerfile is divided into two stages:

### 1. Build Stage (Node.js)

```
FROM node:20-alpine AS build
```

Uses a lightweight Node.js image based on Alpine Linux. The AS build creates a named stage for reuse later.

```
WORKDIR /app
```

Sets the working directory inside the container to /app.

```
COPY package\*.json ./
```

Copies package.json and package-lock.json first to take advantage of Docker layer caching.

```
RUN npm install
```

Installs all project dependencies.

```
COPY . .
```

Copies the rest of the application source code into the container.

```
RUN npm run build
```

Builds the application for production, generating static files in /app/dist.

### 2. Production Stage (Nginx)

```
FROM nginx:stable-alpine AS production
```

Uses a lightweight and production-ready Nginx image.

```
COPY --from=build /app/dist /usr/share/nginx/html
```

Copies the built static files from the build stage into Nginx’s default public directory.

```
COPY nginx.conf /etc/nginx/conf.d/default.conf
```

Adds a custom Nginx configuration file, replacing the default.

```
EXPOSE 80
```

Exposes port 80 to allow HTTP traffic.

```
CMD ["nginx", "-g", "daemon off;"]
```

Runs Nginx in the foreground so Docker can keep the container alive.

## Custom configuration

A custom nginx.conf is included:

```
COPY nginx.conf /etc/nginx/conf.d/default.conf
```

This allows customization of:

- Routing
- Reverse proxy behavior
- Headers and caching strategies
