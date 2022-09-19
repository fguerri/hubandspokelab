######################################################
# Custom Route Tables - Spoke1 VNet - Primary region
######################################################

resource "azurerm_route_table" "primary-spoke-route-table" {
  name                = "${var.primary-location}-spoke-route-table"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  disable_bgp_route_propagation = true

  route {
    name           = "default-via-azfw"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "hub-via-azfw"
    address_prefix = local.primary-hub-prefix[0]
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "route-table-for-spoke1-primary-region" {
  subnet_id      = azurerm_subnet.primary-spoke1-fesubnet.id
  route_table_id = azurerm_route_table.primary-spoke-route-table.id
}

resource "azurerm_subnet_route_table_association" "route-table-for-spoke1-be-primary-region" {
  subnet_id      = azurerm_subnet.primary-spoke1-besubnet.id
  route_table_id = azurerm_route_table.primary-spoke-route-table.id
}


######################################################
# Custom Route Tables - Spoke2 VNet - Primary region
######################################################

resource "azurerm_route_table" "primary-secure-spoke-2-fe-route-table" {
  name                = "${var.primary-location}-secure-spoke2-fe-route-table"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  disable_bgp_route_propagation = true

  route {
    name           = "default-via-azfw"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "hub-via-azfw"
    address_prefix = local.primary-hub-prefix[0]
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "local-spoke-via-azfw"
    address_prefix = local.primary-spoke2-prefix[0]
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "spoke2-fe-direct"
    address_prefix = local.primary-spoke2-fesubnet[0]
    next_hop_type  = "VnetLocal"
  }
}

resource "azurerm_subnet_route_table_association" "route-table-for-spoke2-fe-primary-region" {
  subnet_id      = azurerm_subnet.primary-spoke2-fesubnet.id
  route_table_id = azurerm_route_table.primary-secure-spoke-2-fe-route-table.id
}

resource "azurerm_route_table" "primary-secure-spoke-2-be-route-table" {
  name                = "${var.primary-location}-secure-spoke2-be-route-table"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  disable_bgp_route_propagation = true

  route {
    name           = "default-via-azfw"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "hub-via-azfw"
    address_prefix = local.primary-hub-prefix[0]
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "local-spoke-via-azfw"
    address_prefix = local.primary-spoke2-prefix[0]
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "spoke2-be-direct"
    address_prefix = local.primary-spoke2-besubnet[0]
    next_hop_type  = "VnetLocal"
  }
}

resource "azurerm_subnet_route_table_association" "route-table-for-spoke2-be-primary-region" {
  subnet_id      = azurerm_subnet.primary-spoke2-besubnet.id
  route_table_id = azurerm_route_table.primary-secure-spoke-2-be-route-table.id
}


######################################################
# Custom Route Tables - Spoke VNets - Secondary region
######################################################

resource "azurerm_route_table" "secondary-spoke-route-table" {
  name                = "${var.secondary-location}-spoke-route-table"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name

  disable_bgp_route_propagation = true

  route {
    name           = "default-via-azfw"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-secondary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "hub-via-azfw"
    address_prefix = local.secondary-hub-prefix[0]
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-secondary.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "route-table-for-spoke1-secondary-region" {
  subnet_id      = azurerm_subnet.secondary-spoke1-fesubnet.id
  route_table_id = azurerm_route_table.secondary-spoke-route-table.id
}

resource "azurerm_subnet_route_table_association" "route-table-for-spoke2-secondary-region" {
  subnet_id      = azurerm_subnet.secondary-spoke2-fesubnet.id
  route_table_id = azurerm_route_table.secondary-spoke-route-table.id
}

resource "azurerm_subnet_route_table_association" "route-table-for-spoke1-be-secondary-region" {
  subnet_id      = azurerm_subnet.secondary-spoke1-besubnet.id
  route_table_id = azurerm_route_table.secondary-spoke-route-table.id
}

resource "azurerm_subnet_route_table_association" "route-table-for-spoke2-be-secondary-region" {
  subnet_id      = azurerm_subnet.secondary-spoke2-besubnet.id
  route_table_id = azurerm_route_table.secondary-spoke-route-table.id
}


##########################################################
# Custom Route Tables - Firewall Subnet - Primary region
##########################################################

resource "azurerm_route_table" "primary-azfw-route-table" {
  name                = "${var.primary-location}-azfw-route-table"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  disable_bgp_route_propagation = false

  route {
    name           = "to-${var.secondary-location}-via-azfw"
    address_prefix = local.secondary-region-prefix
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-secondary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "default-via-internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}

resource "azurerm_subnet_route_table_association" "route-table-for-azfw-primary-region" {
  subnet_id      = azurerm_subnet.primary-hub-azurefirewallsubnet.id
  route_table_id = azurerm_route_table.primary-azfw-route-table.id
}


##########################################################
# Custom Route Tables - Firewall Subnet - Secondary region
##########################################################

resource "azurerm_route_table" "secondary-azfw-route-table" {
  name                = "${var.secondary-location}-azfw-route-table"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name

  disable_bgp_route_propagation = false

  route {
    name           = "to-${var.primary-location}-via-azfw"
    address_prefix = local.primary-region-prefix
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "default-via-internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}

resource "azurerm_subnet_route_table_association" "route-table-for-azfw-secondary-region" {
  subnet_id      = azurerm_subnet.secondary-hub-azurefirewallsubnet.id
  route_table_id = azurerm_route_table.secondary-azfw-route-table.id
}


##########################################################
# Custom Route Tables - Gateway Subnet - Primary region
##########################################################

resource "azurerm_route_table" "primary-gateway-subnet-route-table" {
  name                = "${var.primary-location}-gateway-subnet-route-table"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  disable_bgp_route_propagation = false

  route {
    name           = "to-${var.primary-location}-spoke1-via-azfw"
    address_prefix = local.primary-spoke1-prefix[0]
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "to-${var.primary-location}-spoke2-via-azfw"
    address_prefix = local.primary-spoke2-prefix[0]
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "hub-via-azfw"
    address_prefix = local.primary-hub-prefix[0]
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "route-table-for-gateway-subnet-primary-region" {
  subnet_id      = azurerm_subnet.primary-hub-gatewaysubnet.id
  route_table_id = azurerm_route_table.primary-gateway-subnet-route-table.id
}


##########################################################
# Custom Route Tables - Gateway Subnet - Secondary region
##########################################################

resource "azurerm_route_table" "secondary-gateway-subnet-route-table" {
  name                = "${var.secondary-location}-gateway-subnet-route-table"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name

  disable_bgp_route_propagation = false

  route {
    name                    = "to-${var.secondary-location}-spoke1-via-azfw"
    address_prefix          = local.secondary-spoke1-prefix[0]
    next_hop_type           = "VirtualAppliance"
    next_hop_in_ip_address  = azurerm_firewall.azfw-secondary.ip_configuration[0].private_ip_address
  }
  route {
    name                    = "to-${var.secondary-location}-spoke2-via-azfw"
    address_prefix          = local.secondary-spoke2-prefix[0]
    next_hop_type           = "VirtualAppliance"
    next_hop_in_ip_address  = azurerm_firewall.azfw-secondary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "hub-via-azfw"
    address_prefix = local.secondary-hub-prefix[0]
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-secondary.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "route-table-for-gateway-subnet-secondary-region" {
  subnet_id      = azurerm_subnet.secondary-hub-gatewaysubnet.id
  route_table_id = azurerm_route_table.secondary-gateway-subnet-route-table.id
}


##########################################################
# Custom Route Tables - VM Subnet - Primary region
##########################################################

resource "azurerm_route_table" "primary-vm-subnet-route-table" {
  name                = "${var.primary-location}-vm-subnet-route-table"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  disable_bgp_route_propagation = true

  route {
    name           = "default-via-azfw"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "to-${var.primary-location}-spoke1-via-azfw"
    address_prefix = local.primary-spoke1-prefix[0]
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "to-${var.primary-location}-spoke2-via-azfw"
    address_prefix = local.primary-spoke2-prefix[0]
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "hub-via-azfw"
    address_prefix = local.primary-hub-prefix[0]
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "to-${var.secondary-location}-hub-via-azfw"
    address_prefix = local.secondary-hub-prefix[0]
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-primary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "local-subnet-direct"
    address_prefix = local.primary-hub-vmsubnet[0]
    next_hop_type  = "VnetLocal"
  }
}

resource "azurerm_subnet_route_table_association" "route-table-for-vm-subnet-primary-region" {
  subnet_id      = azurerm_subnet.primary-hub-vmsubnet.id
  route_table_id = azurerm_route_table.primary-vm-subnet-route-table.id
}


##########################################################
# Custom Route Tables - VM Subnet - Secondary region
##########################################################

resource "azurerm_route_table" "secondary-vm-subnet-route-table" {
  name                = "${var.secondary-location}-vm-subnet-route-table"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name

  disable_bgp_route_propagation = true

  route {
    name           = "default-via-azfw"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-secondary.ip_configuration[0].private_ip_address
  }
  route {
    name                    = "to-${var.secondary-location}-spoke1-via-azfw"
    address_prefix          = local.secondary-spoke1-prefix[0]
    next_hop_type           = "VirtualAppliance"
    next_hop_in_ip_address  = azurerm_firewall.azfw-secondary.ip_configuration[0].private_ip_address
  }
  route {
    name                    = "to-${var.secondary-location}-spoke2-via-azfw"
    address_prefix          = local.secondary-spoke2-prefix[0]
    next_hop_type           = "VirtualAppliance"
    next_hop_in_ip_address  = azurerm_firewall.azfw-secondary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "hub-via-azfw"
    address_prefix = local.secondary-hub-prefix[0]
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-secondary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "to-${var.primary-location}-hub-via-azfw"
    address_prefix = local.primary-hub-prefix[0]
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw-secondary.ip_configuration[0].private_ip_address
  }
  route {
    name           = "local-subnet-direct"
    address_prefix = local.secondary-hub-vmsubnet[0]
    next_hop_type  = "VnetLocal"
  }
}

resource "azurerm_subnet_route_table_association" "route-table-for-vm-subnet-secondary-region" {
  subnet_id      = azurerm_subnet.secondary-hub-vmsubnet.id
  route_table_id = azurerm_route_table.secondary-vm-subnet-route-table.id
}
