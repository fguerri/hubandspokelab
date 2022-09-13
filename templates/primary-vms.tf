##############################
# Primary Hub VM
##############################
resource "azurerm_network_interface" "primary-hub-vm-nic" {
  name                = "${var.primary-location}-hub-vm-nic"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.primary-hub-vmsubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "primary-hub-vm" {
  name                = "${var.primary-location}-hub-vm"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name
  size                = var.vm-size
  
  admin_username      = var.vm-user
  admin_password      = var.vm-password
  disable_password_authentication = false

  network_interface_ids = [ azurerm_network_interface.primary-hub-vm-nic.id ]

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
# Primary Spoke1 Frontend VM
##############################
resource "azurerm_network_interface" "primary-spoke1-fe-vm-nic" {
  name                = "${var.primary-location}-spoke1-fe-vm-nic"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.primary-spoke1-fesubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "primary-spoke1-fe-vm" {
  name                = "${var.primary-location}-spoke1-fe-vm"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name
  size                = var.vm-size
  
  admin_username      = var.vm-user
  admin_password      = var.vm-password
  disable_password_authentication = false

  network_interface_ids = [ azurerm_network_interface.primary-spoke1-fe-vm-nic.id ]

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
# Primary Spoke1 Backend VM
##############################
resource "azurerm_network_interface" "primary-spoke1-be-vm-nic" {
  name                = "${var.primary-location}-spoke1-be-vm-nic"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.primary-spoke1-besubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "primary-spoke1-be-vm" {
  name                = "${var.primary-location}-spoke1-be-vm"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name
  size                = var.vm-size
  
  admin_username      = var.vm-user
  admin_password      = var.vm-password
  disable_password_authentication = false

  network_interface_ids = [ azurerm_network_interface.primary-spoke1-be-vm-nic.id ]

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
# Primary Spoke2 Frontend VM
##############################
resource "azurerm_network_interface" "primary-spoke2-fe-vm-nic" {
  name                = "${var.primary-location}-spoke2-fe-vm-nic"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.primary-spoke2-fesubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "primary-spoke2-fe-vm" {
  name                = "${var.primary-location}-spoke2-fe-vm"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name
  size                = var.vm-size
  
  admin_username      = var.vm-user
  admin_password      = var.vm-password
  disable_password_authentication = false

  network_interface_ids = [ azurerm_network_interface.primary-spoke2-fe-vm-nic.id ]

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
# Primary Spoke2 Backend VM
##############################
resource "azurerm_network_interface" "primary-spoke2-be-vm-nic" {
  name                = "${var.primary-location}-spoke2-be-vm-nic"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.primary-spoke2-besubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "primary-spoke2-be-vm" {
  name                = "${var.primary-location}-spoke2-be-vm"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name
  size                = var.vm-size
  
  admin_username      = var.vm-user
  admin_password      = var.vm-password
  disable_password_authentication = false

  network_interface_ids = [ azurerm_network_interface.primary-spoke2-be-vm-nic.id ]

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





