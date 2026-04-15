# -------------------------------------------------------------------
# Resource Group
# -------------------------------------------------------------------
resource "azurerm_resource_group" "ca2" {
  name     = "CA-2"
  location = var.location
}

# -------------------------------------------------------------------
# Virtual Machine
# -------------------------------------------------------------------
resource "azurerm_linux_virtual_machine" "vm" {
  count               = 2
  name                = "ca2-vm-${count.index}"
  location            = azurerm_resource_group.ca2.location
  resource_group_name = azurerm_resource_group.ca2.name
  size                = var.vm_size
  admin_username      = "azureuser"
  zone                = "3"

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.vm_ssh_key.public_key_openssh
  }

  os_disk {
    name                 = "osdisk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  disable_password_authentication = true
}
