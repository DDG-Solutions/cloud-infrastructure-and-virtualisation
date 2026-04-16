# Cloud Infrastructure and Virtualisation - Project Report

## 1. Introduction

This report documents the planning, design, and implementation of a private cloud environment for hosting a containerised web application. The scenario involves a medium-sized enterprise requiring an internal application where data sensitivity and regulatory requirements mandate that the application and its data reside within a controlled cloud infrastructure.

Our group, DDG Solutions, selected The Personality Shop, a full-stack e-commerce application developed for our Web and Cloud Application Development module, as the application to containerise and deploy. The Personality Shop allows users to browse, search, and purchase personality traits, and comprises three interacting components: a React frontend, a Node.js/Express backend, and a MongoDB database. Supporting services include Firebase for authentication and Stripe for payment processing.

The objective of this project was to provision cloud infrastructure using Infrastructure as Code (IaC), containerise all application components using Docker, and orchestrate their deployment using Docker Compose on an Azure-hosted virtual machine.

## 2. Private Cloud Plan and Design

### 2.1 Requirements Analysis

The application required an environment capable of running three containerised services with the following needs:

- **Compute**: A Linux virtual machine with sufficient resources to run multiple Docker containers
- **Networking**: A virtual network with a public IP for SSH access, and internal container networking for inter-service communication
- **Storage**: Persistent storage for MongoDB data to survive container restarts
- **Security**: Restricted inbound access, SSH key-based authentication, and sensitive configuration managed through environment variables

### 2.2 Technology Justification

We selected the following technologies for our infrastructure:

- **Microsoft Azure** - Our team had access to Azure student credits from previous modules. Azure provides a mature cloud platform with comprehensive support for virtual machines, networking, and storage resources.
- **Terraform** - An industry-standard IaC tool that allows us to define our Azure infrastructure declaratively. Terraform ensures our environment is reproducible and version-controlled.
- **Ansible** - A configuration management tool used to automate the installation of Docker and its dependencies on the provisioned VM. Ansible connects over SSH and requires no agent on the target machine, making it lightweight and well-suited to our setup.
- **Docker and Docker Compose** - Docker provides containerisation for each application component, while Docker Compose handles multi-container orchestration, networking, and dependency management.

### 2.3 Architecture

(Note: brief mentions Architecture diagrams)

The architecture follows a three-layer approach: infrastructure provisioning, configuration management, and application deployment.

Terraform provisions the Azure resources: a resource group, virtual network, subnet, network security group, public IP, network interface, and an Ubuntu 24.04 LTS virtual machine in the France Central region. Terraform also generates an Ansible inventory file as an output, linking the provisioning and configuration stages.

Ansible then connects to the VM via SSH and executes the Docker role, which installs Docker Engine, Docker CLI, containerd, and the Docker Compose plugin. It also configures user permissions for the docker group.

Finally, Docker Compose orchestrates the three application containers - MongoDB, the backend server, and the frontend client - on a shared Docker network with appropriate dependency ordering and health checks.

### 2.4 Security Considerations

Security was addressed at multiple levels:

- **Network Security Group (NSG)**: The Azure NSG restricts inbound traffic to SSH (port 22) only. Application ports are not exposed directly to the internet.
- **SSH Key Authentication**: Password authentication is disabled on the VM. Access is restricted to SSH key pairs.
- **Environment Variables**: Sensitive values such as database credentials, Stripe API keys, and connection strings are stored in a `.env` file which is excluded from version control via `.gitignore`. A `.env.template` is provided as a reference for team members.
- **Container Isolation**: Each application component runs in its own container with defined network boundaries. MongoDB is not exposed to the host network beyond what is required for the application.

## 3. Containerisation Strategy

### 3.1 Application Components

The Personality Shop consists of three components, each containerised independently:

| Component | Technology | Docker Image | Port |
|-----------|-----------|-------------|------|
| Database | MongoDB | `mongo` (official) | 27017 |
| Backend | Node.js, Express | `dstuartkelly/personalityshop-server` | 3001 |
| Frontend | React, Vite | `dstuartkelly/personalityshop-client` | 5173:80 |

The official MongoDB image from Docker Hub was used directly, configured with root credentials via `MONGO_INITDB_ROOT_USERNAME` and `MONGO_INITDB_ROOT_PASSWORD` environment variables as documented in the official image reference.

The backend and frontend images were built from custom Dockerfiles. The server Dockerfile uses `node:20-alpine` as a base image, copies the application source, installs dependencies, and exposes port 3001. Both images are built and pushed to Docker Hub via CI/CD pipelines using GitHub Actions.

The frontend image has a multi-stage Docker build approach for production environments. Node.js (`node:20-alpine`) is used in the first stage as base image to install dependencies and build the React application using Vite that produces static assets in a `/dist` directory. The second stage uses an Nginx (`nginx:stable-alpine`) image to serve these static files efficiently.

This approach separates the build stage from the runtime stage that reduces the image size and improves security by removing unnecessary tools. The Nginx then serves the static files as a lightweight, high-performance web server in production.

Additionally, the frontend container includes a custom `nginx.conf` file to support single-page-application routing. Without configuration, Nginx would return 404 error for the routes as navigation happens on the client side. This configuration file solves this by redirecting any request that does not match a real file to `index.html`, where React handles the routing in the browser.

### 3.2 Docker Compose Orchestration

Docker Compose defines all three services in a single `docker-compose.yml` file. Key design decisions include:

- **Health Checks**: The MongoDB service includes a health check that pings the database at 10-second intervals. The backend server uses a `depends_on` condition that waits for MongoDB to be healthy before starting, preventing connection failures on startup.
- **Data Persistence**: A named Docker volume (`mongo_data`) is mounted to `/data/db` in the MongoDB container, ensuring data persists across container restarts and redeployments.
- **Networking**: All services communicate over a shared Docker network (`web-and-cloud-application-development_default`). The backend connects to MongoDB using the service name `mongo` as the hostname in the connection URI.
- **Environment Configuration**: Sensitive values are injected from the `.env` file using variable substitution (e.g. `${MONGO_URI}`), keeping secrets out of the compose file and version control.

### 3.3 CI/CD Pipeline

Docker images for the server and client are built and pushed to Docker Hub automatically using GitHub Actions. This ensures that the latest application code is always available as a container image, and the deployment on the VM simply pulls the latest images rather than building from source.

## 4. Implementation Summary

### 4.1 Infrastructure Provisioning

The VM was provisioned by navigating to the `terraform/` directory and running `terraform apply`. Terraform created the following resources in the Azure France Central region:

1. Resource Group (`CA-2`)
2. Virtual Network and Subnet
3. Network Security Group with SSH inbound rule
4. Public IP Address
5. Network Interface
6. Ubuntu 24.04 LTS Virtual Machine (`Standard_B2ats_v2`)
7. Ansible inventory file (auto-generated)

### 4.2 Configuration Management

With the VM provisioned, Ansible was run from the `ansible/` directory using the auto-generated inventory file. The Docker playbook executed two task files in sequence: `docker-prerequisites.yaml` installed required packages and dependencies, and `docker-install.yaml` added the Docker repository, installed Docker Engine and the Compose plugin, enabled the Docker service, and configured user group permissions.

### 4.3 Application Deployment

With Docker installed on the VM, the `docker-compose.yml` and `.env` files were transferred to the VM. Running `docker compose up -d` pulled the images from Docker Hub and started all three containers. The MongoDB health check ensured the database was accepting connections before the backend started, and the frontend was accessible on port 5173.

### 4.4 Challenges and Solutions

- **Service Startup Order**: Initially the backend would attempt to connect to MongoDB before the database was ready, causing connection errors. This was resolved by adding a health check to the MongoDB service and a `depends_on` condition with `service_healthy` on the backend.
- **Sensitive Configuration**: Hardcoding credentials in `docker-compose.yml` was identified as a security risk early on. We adopted a `.env` file approach with variable substitution and added `.env` to `.gitignore`, providing a `.env.template` for reference.
- **Cross-Repository Coordination**: The application source code lives in separate repositories (server and client), while the infrastructure configuration is in this repository. CI/CD pipelines bridge this gap by building and pushing Docker images to Docker Hub, which the infrastructure repository references.

## 5. Conclusion

This project demonstrated the end-to-end process of provisioning cloud infrastructure and deploying a containerised multi-component application. By using Terraform for infrastructure provisioning, Ansible for configuration management, and Docker Compose for container orchestration, we achieved a reproducible and automated deployment pipeline.

The three-component architecture of The Personality Shop - frontend, backend, and database - mapped naturally to a containerised deployment model, with each component isolated in its own container while communicating over a shared Docker network. Key concerns such as data persistence, service dependency ordering, and secrets management were addressed through Docker volumes, health checks, and environment variable substitution respectively.

The project reinforced the value of Infrastructure as Code for ensuring consistency and repeatability, and highlighted the importance of automation in reducing manual configuration errors. Working as a team across multiple repositories required clear communication and well-defined interfaces between infrastructure and application concerns.
