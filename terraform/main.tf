# -------------------------------------------------------------------
# Resource Group
# -------------------------------------------------------------------
resource "azurerm_resource_group" "ca2" {
  name     = "CA-2"
  location = var.location
}

# -------------------------------------------------------------------
# Networking
# -------------------------------------------------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = "ca2-vnet"
  location            = azurerm_resource_group.ca2.location
  resource_group_name = azurerm_resource_group.ca2.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "ca2-subnet"
  resource_group_name  = azurerm_resource_group.ca2.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "ca2-pip"
  location            = azurerm_resource_group.ca2.location
  resource_group_name = azurerm_resource_group.ca2.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["3"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "ca2-nsg"
  location            = azurerm_resource_group.ca2.location
  resource_group_name = azurerm_resource_group.ca2.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "ca2-nic"
  location            = azurerm_resource_group.ca2.location
  resource_group_name = azurerm_resource_group.ca2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# -------------------------------------------------------------------
# Virtual Machine
# -------------------------------------------------------------------
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "ca2-vm"
  location            = azurerm_resource_group.ca2.location
  resource_group_name = azurerm_resource_group.ca2.name
  size                = var.vm_size
  admin_username      = "azureuser"
  zone                = "3"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
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
