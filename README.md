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
        This file creates outputs from terraform which includes an ansible inventory file and the public IP Address of the machine displayed on screen.
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

[Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

[Terraform Azure Virtual Machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine)

[Ansible Collection Documentation](https://docs.ansible.com/projects/ansible/latest/collections/index.html)
[Ansible.Builtin Collection](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/index.html)


## How to deploy stuff and things

### Use terraform to create a virtual machine in Azure

#### Requirements for applying terraform
- You must have an Azure subscription and Azure CLI installed.
- You must use ``az login`` to log into the Azure account and select the appropriate subscription.

#### Steps to create virtual machine
navigate to the terraform directory and execute a terraform apply
```bash
cd terraform
terraform apply
```
Terraform will show you the changes it is going to make in your Azure subscription, review these to ensure you know what you are deploying and if you are satisfied type ``yes``

Expected Resources:
1. Virtual Machine
2. Network Interface
3. Security Group Association (With the network interface)
4. Network Security Group
5. Public IP Address
6. Resource Group
7. Subnet
8. Virtual Network
9. Ansible inventory file

When creation has completed, Terraform will output the Public IPAddress of the host that it has created.

### Use Ansbile to install docker

navigate to the ansible directory and run the playbook

```bash
cd ../ansible
ansible-playbook -i inventory.ini docker-playbook.yaml 
```
