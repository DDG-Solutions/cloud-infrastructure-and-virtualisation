# Meetings

## Meeting 1
### Assignment discussion and work division

We reviewed the assignment brief and noted that it requires a private cloud environment, but there is not one available. We were provided access to Azure student credits during our modules last semester so have decided to use Azure.

We agreed to use the Personality Shop project that we are working on for Web and Cloud Application Development module. There are 3 components in the application Frontend (React), Backend (Node/Express), Database (MongoDB).

We discussed using infrastructure as code specifically Terraform to spin up the resources in Azure and Ansible to deploy pre-requisites

The application we are building for the Web and Cloud Application Development Module is not yet complete, so we can work on this project when the other assignment has completed.

### Work Division:
Daniel: - Terraform, Ansible, Deployment automation
Donal: Backend containerization - Node/Express Dockerfile
Gustavo: Frontend containerization - React Dockerfile
All: Documentation, Docker Compose orchestration, report writing (divided later)

## Meeting 2

Review of Terraform

Refactor terraform into modular structure


## Meeting 3

Terraform working

Review of Ansible

Review of end to end Terraform -> Ansible -> Is docker working on the host?

## Meeting 4

Dockerfiles created, tested and working
CI/CD Pipelines to build and push docker completed tested and working

Create docker-compose using docker hub images
- Donal Server
- Gustavo Client

Review backup strategies for Mongo DB
Gustavo to add Mongo to docker compose.

