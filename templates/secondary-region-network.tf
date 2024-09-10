##############################
# Hub VNet
##############################

resource "azurerm_virtual_network" "secondary-hub" {
  name                = "${var.secondary-location}-hub"
  location            = var.secondary-location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name
  address_space       = local.secondary-hub-prefix
}

resource "azurerm_subnet" "secondary-hub-gatewaysubnet" {
    name                    = "GatewaySubnet"
    resource_group_name     = azurerm_resource_group.hubandspoke-secondary-rg.name
    virtual_network_name    = azurerm_virtual_network.secondary-hub.name
    address_prefixes          = local.secondary-hub-gatewaysubnet
}

resource "azurerm_subnet" "secondary-hub-azurefirewallsubnet" {
    name                    = "AzureFirewallSubnet"
    resource_group_name     = azurerm_resource_group.hubandspoke-secondary-rg.name
    virtual_network_name    = azurerm_virtual_network.secondary-hub.name
    address_prefixes          = local.secondary-hub-azurefirewallsubnet
}

resource "azurerm_subnet" "secondary-hub-azurebastionsubnet" {
    name                    = "AzureBastionSubnet"
    resource_group_name     = azurerm_resource_group.hubandspoke-secondary-rg.name
    virtual_network_name    = azurerm_virtual_network.secondary-hub.name
    address_prefixes        = local.secondary-hub-azurebastionsubnet
}

resource "azurerm_subnet" "secondary-hub-vmsubnet" {
    name                    = "vmsubnet"
    resource_group_name     = azurerm_resource_group.hubandspoke-secondary-rg.name
    virtual_network_name    = azurerm_virtual_network.secondary-hub.name
    address_prefixes        = local.secondary-hub-vmsubnet
}

resource "azurerm_subnet_network_security_group_association" "secondary-hub-vmsubnet-nsg-a" {
  subnet_id                 = azurerm_subnet.secondary-hub-vmsubnet.id
  network_security_group_id = azurerm_network_security_group.any-to-any-cross-region-secondary.id
}

##############################
# Spoke1 VNet
##############################

resource "azurerm_virtual_network" "secondary-spoke1" {
  name                = "${var.secondary-location}-spoke1"
  location            = var.secondary-location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name
  address_space       = local.secondary-spoke1-prefix
}

resource "azurerm_subnet" "secondary-spoke1-fesubnet" {
    name                    = "frontend-subnet"
    resource_group_name     = azurerm_resource_group.hubandspoke-secondary-rg.name
    virtual_network_name    = azurerm_virtual_network.secondary-spoke1.name
    address_prefixes          = local.secondary-spoke1-fesubnet
}

resource "azurerm_subnet_network_security_group_association" "secondary-spoke1-fesubnet-nsg-a" {
  subnet_id                 = azurerm_subnet.secondary-spoke1-fesubnet.id
  network_security_group_id = azurerm_network_security_group.any-to-any-cross-region-secondary.id
}

resource "azurerm_subnet" "secondary-spoke1-besubnet" {
    name                    = "backend-subnet"
    resource_group_name     = azurerm_resource_group.hubandspoke-secondary-rg.name
    virtual_network_name    = azurerm_virtual_network.secondary-spoke1.name
    address_prefixes          = local.secondary-spoke1-besubnet
}

resource "azurerm_subnet_network_security_group_association" "secondary-spoke1-besubnet-nsg-a" {
  subnet_id                 = azurerm_subnet.secondary-spoke1-besubnet.id
  network_security_group_id = azurerm_network_security_group.any-to-any-cross-region-secondary.id
}

##############################
# Spoke2 VNet
##############################

resource "azurerm_virtual_network" "secondary-spoke2" {
  name                = "${var.secondary-location}-spoke2"
  location            = var.secondary-location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name
  address_space       = local.secondary-spoke2-prefix
}

resource "azurerm_subnet" "secondary-spoke2-fesubnet" {
    name                    = "frontend-subnet"
    resource_group_name     = azurerm_resource_group.hubandspoke-secondary-rg.name
    virtual_network_name    = azurerm_virtual_network.secondary-spoke2.name
    address_prefixes          = local.secondary-spoke2-fesubnet
}

resource "azurerm_subnet_network_security_group_association" "secondary-spoke2-fesubnet-nsg-a" {
  subnet_id                 = azurerm_subnet.secondary-spoke2-fesubnet.id
  network_security_group_id = azurerm_network_security_group.any-to-any-cross-region-secondary.id
}

resource "azurerm_subnet" "secondary-spoke2-besubnet" {
    name                    = "backend-subnet"
    resource_group_name     = azurerm_resource_group.hubandspoke-secondary-rg.name
    virtual_network_name    = azurerm_virtual_network.secondary-spoke2.name
    address_prefixes          = local.secondary-spoke2-besubnet
}

resource "azurerm_subnet_network_security_group_association" "secondary-spoke2-besubnet-nsg-a" {
  subnet_id                 = azurerm_subnet.secondary-spoke2-besubnet.id
  network_security_group_id = azurerm_network_security_group.any-to-any-cross-region-secondary.id
}


#########################################################
# Peering hub <--> spoke1
#########################################################  
resource "azurerm_virtual_network_peering" "from-secondary-hub-to-spoke1" {
  name                              = "from-hub-to-spoke1"
  resource_group_name               = azurerm_resource_group.hubandspoke-secondary-rg.name
  virtual_network_name              = azurerm_virtual_network.secondary-hub.name
  remote_virtual_network_id         = azurerm_virtual_network.secondary-spoke1.id
  allow_virtual_network_access      = true
  allow_forwarded_traffic           = false
  allow_gateway_transit             = true
  use_remote_gateways               = false
  
  depends_on                        = [ azurerm_virtual_network_gateway.secondary-vpngw ]
}

resource "azurerm_virtual_network_peering" "from-spoke1-to-secondary-hub" {
  name                              = "from-spoke1-to-hub"
  resource_group_name               = azurerm_resource_group.hubandspoke-secondary-rg.name
  virtual_network_name              = azurerm_virtual_network.secondary-spoke1.name
  remote_virtual_network_id         = azurerm_virtual_network.secondary-hub.id
  allow_virtual_network_access      = true
  allow_forwarded_traffic           = true
  allow_gateway_transit             = false
  use_remote_gateways               = true

  depends_on                        = [ azurerm_virtual_network_gateway.secondary-vpngw ]
}


#########################################################
# Peering hub <--> spoke2
#########################################################  
resource "azurerm_virtual_network_peering" "from-secondary-hub-to-spoke2" {
  name                              = "from-hub-to-spoke2"
  resource_group_name               = azurerm_resource_group.hubandspoke-secondary-rg.name
  virtual_network_name              = azurerm_virtual_network.secondary-hub.name
  remote_virtual_network_id         = azurerm_virtual_network.secondary-spoke2.id
  allow_virtual_network_access      = true
  allow_forwarded_traffic           = false
  allow_gateway_transit             = true
  use_remote_gateways               = false
  
  depends_on                        = [ azurerm_virtual_network_gateway.secondary-vpngw ]
}

resource "azurerm_virtual_network_peering" "from-spoke2-to-secondary-hub" {
  name                              = "from-spoke2-to-hub"
  resource_group_name               = azurerm_resource_group.hubandspoke-secondary-rg.name
  virtual_network_name              = azurerm_virtual_network.secondary-spoke2.name
  remote_virtual_network_id         = azurerm_virtual_network.secondary-hub.id
  allow_virtual_network_access      = true
  allow_forwarded_traffic           = true
  allow_gateway_transit             = false
  use_remote_gateways               = true

  depends_on                        = [ azurerm_virtual_network_gateway.secondary-vpngw ]
}

#########################################################
# Peering secondary --> primary
######################################################### 

resource "azurerm_virtual_network_peering" "from-secondary-hub-to-primary-hub" {
  name                              = "from-${var.secondary-location}-hub-to-${var.primary-location}-hub"
  resource_group_name               = azurerm_resource_group.hubandspoke-secondary-rg.name
  virtual_network_name              = azurerm_virtual_network.secondary-hub.name
  remote_virtual_network_id         = azurerm_virtual_network.primary-hub.id
  allow_virtual_network_access      = true
  allow_forwarded_traffic           = true
  allow_gateway_transit             = false
  use_remote_gateways               = false

}


#########################################################
# VPN Gateway
#########################################################  
resource "azurerm_public_ip" "secondary-vpngw-pip-1" {
  name                = "${var.secondary-location}-vpngw-pip-1"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name

  allocation_method = "Static"
}

resource "azurerm_public_ip" "secondary-vpngw-pip-2" {
  name                = "${var.secondary-location}-vpngw-pip-2"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name

  allocation_method = "Static"
}

resource "azurerm_virtual_network_gateway" "secondary-vpngw" {
  name                = "${var.secondary-location}-vpngw"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = true
  enable_bgp    = true
  sku           = "VpnGw2"
  generation    = "Generation2"  

  ip_configuration {
    name                          = "ipconfig1"
    public_ip_address_id          = azurerm_public_ip.secondary-vpngw-pip-1.id
    private_ip_address_allocation = "Static"
    subnet_id                     = azurerm_subnet.secondary-hub-gatewaysubnet.id
  }

  ip_configuration {
    name                          = "ipconfig2"
    public_ip_address_id          = azurerm_public_ip.secondary-vpngw-pip-2.id
    private_ip_address_allocation = "Static"
    subnet_id                     = azurerm_subnet.secondary-hub-gatewaysubnet.id
  }

  bgp_settings {
    asn = "65002"
  }
}
