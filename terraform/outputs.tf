# -------------------------------------------------------------------
# Outputs
# -------------------------------------------------------------------
output "public_ip_address" {
  description = "Public IP of the VM"
  value       = azurerm_public_ip.pip.ip_address
}

output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh -i {path.module}/id_rsa_ca2 azureuser@${azurerm_public_ip.pip.ip_address}"
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/../ansible/inventory.tpl", {
    hostname  = azurerm_linux_virtual_machine.vm.name
    public_ip = azurerm_public_ip.pip.ip_address
  })
  filename = "${path.module}/../ansible/inventory.ini"
}