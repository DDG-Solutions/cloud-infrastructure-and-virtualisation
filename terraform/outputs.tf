# -------------------------------------------------------------------
# Outputs
# -------------------------------------------------------------------
output "public_ip_address" {
  description = "Public IP of the VM"
  value       = azurerm_public_ip.pip.ip_address
}

output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh azureuser@${azurerm_public_ip.pip.ip_address}"
}
