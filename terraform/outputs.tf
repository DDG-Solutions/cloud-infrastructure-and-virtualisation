# -------------------------------------------------------------------
# Outputs
# -------------------------------------------------------------------
output "public_ip_address" {
  description = "Public IP of the VM"
  value       = azurerm_public_ip.pip[*].ip_address
}

output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = [for ip in azurerm_public_ip.pip[*].ip_address : "ssh -i ${path.module}/id_rsa_ca2 azureuser@${ip}"]
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/../ansible/roles/docker/files/inventory.tpl", {
    vms = [
      for i in range(2) : {
        hostname  = azurerm_linux_virtual_machine.vm[i].name
        public_ip = azurerm_public_ip.pip[i].ip_address
      }
    ]
  })
  filename = "${path.module}/../ansible/inventory.ini"
}