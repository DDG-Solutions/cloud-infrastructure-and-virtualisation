# Meetings

## Meeting 1 Feb 17th
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

## Meeting 2 March 26th

Initial terraform built, tested and in git.
Initial ansible under construction, parts tested and working, further work to be done.

### Next Steps:
Terraform to be refactored into into modular structure, seperate files for provider, VM, network, outputs and variables.
Terraform state to be tracked in Git - any applys/destroys `terraform.tfstate` files should be committed and pushed to git.


## Meeting 3 April 1st

Terraform has been tested extensively and currently working to deploy 1 virtual machine and associated resources.
Ansible inventory to be added to terraform so that it gets created automatically based on IPAddresses of the machines created.

Review of Ansible

Review of end to end Terraform -> Ansible -> Is docker working on the host?

Local testing of client and server dockerfiles looks promising.

### Next Steps:
Donal and Gustavo to review assignment brief again for report requirements.
Donal to complete server Dockerfile
Gustavo to complete client Dockerfile


## Meeting 4 April 13th

Terraform and Ansible working and repeatable.
Dockerfiles created, tested and working.
CI/CD Pipelines to build and push docker completed tested and working

Create docker-compose using docker hub images
- Donal Server
- Gustavo Client

### Next Steps:
Gustavo to add Mongo to docker compose.
Gustavo and Donal to extend docker compose.

Donal starting initaial draft of our Report


## Meeting 5 April 14th

Dockerfiles complete
Docker Compose functionally complete - needs health check and depends_on to be set up


## Next Steps:
Gustavo to add health check and depends on
Donal to continue work on report
Daniel to add docker-compose to ansible


## Meeting 6 April 15th




## Final sprint April 16t
