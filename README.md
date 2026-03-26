# What is this Repo?

This is a shared repository for DDG Solutions - 3 Students studying a Higher Diploma in Science in Computing with Dublin Business School

This repository will contain notes, documents and our submission for CA1 assignment for our Cloud Infrastructure and Virtualisation Module.

## Whats in this repo?

[Docs](./Docs/) directory contains relevant documents

- Actual Assignment Brief
- Meeting notes (if applicable)

[bash-scripts](./bash-scripts/)

- Some initial scripts to perform the work from the [Docker Workshop](https://docs.docker.com/get-started/workshop/02_our_app/)

[ansible](./ansible/)

- This directory contains some ansible scripts to install and configure docker on a target host/hosts.
    [inventory.ini](./ansible/inventory.ini)
    This file should contain a list of the systems you wish to install docker on.

[terraform](./terraform/)

- This directory contains the terraform files required to deploy a virtual machine and associated resources into Azure.
    [main.tf](./terraform/main.tf)
        Main terraform file which creates the resource group and virtual machine
    [networking.tf](./terraform/networking.tf)
        This file creates the network to support the virtial machine and security group to allow inbound SSH connections.
    [outputs.tf](./terraform/outputs.tf)
        This file creates the outputs from terraform which includes the public IP Address of the machine that is created.
    [provider.tf](./terraform/provider.tf)
        Azure Provider
    [terraform.tfstate](./terraform/terraform.tfstate)
        Terraform State file
    [terraform.tfstate.backup](./terraform/terraform.tfstate.backup)
        Backup of terraform state file
    [variables.tf](./terraform/variables.tf)
        Variables used to define what ssh key should be used, region to deploy to and instance/vm size to be used.

## Reference Documentation

[Docker Workshop](https://docs.docker.com/get-started/workshop/02_our_app/)  
Docker workshop linked above was discussed in class 16th February 2026 where lecturer advised our CA would essentially be based off Parts 1 to 7.
