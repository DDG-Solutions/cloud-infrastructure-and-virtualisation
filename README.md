# What is this Repo?

This is a shared repository for DDG Solutions - 3 Students studying a Higher Diploma in Science in Computing with Dublin Business School

This project is our submission for CA_2 and uses [Terraform](https://www.terraform.io/), [Ansible](https://www.ansible.com/) to create an environment in Azure which will be used as part of the assignment.

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
    [ssh-keys.tf](./terraform/ssh-keys.tf)
        Creates SSH Private and Public keys for connecting to the Virtual machine
    [variables.tf](./terraform/variables.tf)  
        Variables used to define what ssh key should be used, region to deploy to and instance/vm size to be used.  

## Reference Documentation

- [Docker Workshop](https://docs.docker.com/get-started/workshop/02_our_app/)  
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Azure Virtual Machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine)
- [Ansible Collection Documentation](https://docs.ansible.com/projects/ansible/latest/collections/index.html)  
- [Ansible.Builtin Collection](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/index.html)


## How to deploy stuff and things

### Prerequisites

- [Terraform should be installed and working.](https://developer.hashicorp.com/terraform/install)
- [Ansible should be installed and working.](https://docs.ansible.com/projects/ansible/latest/installation_guide/installation_distros.html)
- [Azure CLI should be installed, configured and working.](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Sign into Azure using az login.](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli-interactively)

### Use terraform to create a virtual machine in Azure
Navigate to the terraform directory and execute a terraform apply
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
10. SSH Private Key file
11. SSH Public Key file

When creation has completed, Terraform will advise that it has completed and output the Public IPAddress of the host that it has created.

### Use Ansbile to install docker on the new Azure virtual machine

navigate to the ansible directory and run the playbook

```bash
cd ../ansible
ansible-playbook -i inventory.ini docker-playbook.yaml 
```
