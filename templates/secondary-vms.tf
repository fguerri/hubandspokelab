##############################
# Secondary Hub VM
##############################

resource "azurerm_network_interface" "secondary-hub-vm-nic" {
  name                = "${var.secondary-location}-hub-vm-nic"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.secondary-hub-vmsubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "secondary-hub-vm" {
  name                = "${var.secondary-location}-hub-vm"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name
  size                = var.vm-size
  
  admin_username      = var.vm-user
  admin_password      = var.vm-password
  disable_password_authentication = false

  network_interface_ids = [ azurerm_network_interface.secondary-hub-vm-nic.id ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_5"
    version   = "latest"
  }
}


##############################
# Secondary Spoke1 Frontend VM
##############################
resource "azurerm_network_interface" "secondary-spoke1-fe-vm-nic" {
  name                = "${var.secondary-location}-spoke1-fe-vm-nic"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.secondary-spoke1-fesubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "secondary-spoke1-fe-vm" {
  name                = "${var.secondary-location}-spoke1-fe-vm"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name
  size                = var.vm-size
  
  admin_username      = var.vm-user
  admin_password      = var.vm-password
  disable_password_authentication = false

  network_interface_ids = [ azurerm_network_interface.secondary-spoke1-fe-vm-nic.id ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_5"
    version   = "latest"
  }
}

##############################
# Secondary Spoke1 Backend VM
##############################
resource "azurerm_network_interface" "secondary-spoke1-be-vm-nic" {
  name                = "${var.secondary-location}-spoke1-be-vm-nic"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.secondary-spoke1-besubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "secondary-spoke1-be-vm" {
  name                = "${var.secondary-location}-spoke1-be-vm"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name
  size                = var.vm-size
  
  admin_username      = var.vm-user
  admin_password      = var.vm-password
  disable_password_authentication = false

  network_interface_ids = [ azurerm_network_interface.secondary-spoke1-be-vm-nic.id ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_5"
    version   = "latest"
  }
}


##############################
# Secondary Spoke2 Frontend VM
##############################
resource "azurerm_network_interface" "secondary-spoke2-fe-vm-nic" {
  name                = "${var.secondary-location}-spoke2-fe-vm-nic"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.secondary-spoke2-fesubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "secondary-spoke2-fe-vm" {
  name                = "${var.secondary-location}-spoke2-fe-vm"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name
  size                = var.vm-size
  
  admin_username      = var.vm-user
  admin_password      = var.vm-password
  disable_password_authentication = false

  network_interface_ids = [ azurerm_network_interface.secondary-spoke2-fe-vm-nic.id ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_5"
    version   = "latest"
  }
}


##############################
# Secondary Spoke2 Backend VM
##############################
resource "azurerm_network_interface" "secondary-spoke2-be-vm-nic" {
  name                = "${var.secondary-location}-spoke2-be-vm-nic"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.secondary-spoke2-besubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "secondary-spoke2-be-vm" {
  name                = "${var.secondary-location}-spoke2-be-vm"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name
  size                = var.vm-size
  
  admin_username      = var.vm-user
  admin_password      = var.vm-password
  disable_password_authentication = false

  network_interface_ids = [ azurerm_network_interface.secondary-spoke2-be-vm-nic.id ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_5"
    version   = "latest"
  }
}


