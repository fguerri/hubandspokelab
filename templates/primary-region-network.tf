##############################
# Hub VNet
##############################

resource "azurerm_virtual_network" "primary-hub" {
  name                = "${var.primary-location}-hub"
  location            = var.primary-location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name
  address_space       = local.primary-hub-prefix
}

resource "azurerm_subnet" "primary-hub-gatewaysubnet" {
    name                    = "GatewaySubnet"
    resource_group_name     = azurerm_resource_group.hubandspoke-primary-rg.name
    virtual_network_name    = azurerm_virtual_network.primary-hub.name
    address_prefixes          = local.primary-hub-gatewaysubnet
}

resource "azurerm_subnet" "primary-hub-azurefirewallsubnet" {
    name                    = "AzureFirewallSubnet"
    resource_group_name     = azurerm_resource_group.hubandspoke-primary-rg.name
    virtual_network_name    = azurerm_virtual_network.primary-hub.name
    address_prefixes          = local.primary-hub-azurefirewallsubnet
}

resource "azurerm_subnet" "primary-hub-azurebastionsubnet" {
    name                    = "AzureBastionSubnet"
    resource_group_name     = azurerm_resource_group.hubandspoke-primary-rg.name
    virtual_network_name    = azurerm_virtual_network.primary-hub.name
    address_prefixes        = local.primary-hub-azurebastionsubnet
}

resource "azurerm_subnet" "primary-hub-vmsubnet" {
    name                    = "vmsubnet"
    resource_group_name     = azurerm_resource_group.hubandspoke-primary-rg.name
    virtual_network_name    = azurerm_virtual_network.primary-hub.name
    address_prefixes        = local.primary-hub-vmsubnet
}

resource "azurerm_subnet_network_security_group_association" "primary-hub-vmsubnet-nsg-a" {
  subnet_id                 = azurerm_subnet.primary-hub-vmsubnet.id
  network_security_group_id = azurerm_network_security_group.any-to-any-cross-region-primary.id
}

##############################
# Spoke1 VNet
##############################

resource "azurerm_virtual_network" "primary-spoke1" {
  name                = "${var.primary-location}-spoke1"
  location            = var.primary-location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name
  address_space       = local.primary-spoke1-prefix
}

resource "azurerm_subnet" "primary-spoke1-fesubnet" {
    name                    = "frontend-subnet"
    resource_group_name     = azurerm_resource_group.hubandspoke-primary-rg.name
    virtual_network_name    = azurerm_virtual_network.primary-spoke1.name
    address_prefixes          = local.primary-spoke1-fesubnet
}

resource "azurerm_subnet_network_security_group_association" "primary-spoke1-fesubnet-nsg-a" {
  subnet_id                 = azurerm_subnet.primary-spoke1-fesubnet.id
  network_security_group_id = azurerm_network_security_group.any-to-any-cross-region-primary.id
}

resource "azurerm_subnet" "primary-spoke1-besubnet" {
    name                    = "backend-subnet"
    resource_group_name     = azurerm_resource_group.hubandspoke-primary-rg.name
    virtual_network_name    = azurerm_virtual_network.primary-spoke1.name
    address_prefixes          = local.primary-spoke1-besubnet
}

resource "azurerm_subnet_network_security_group_association" "primary-spoke1-besubnet-nsg-a" {
  subnet_id                 = azurerm_subnet.primary-spoke1-besubnet.id
  network_security_group_id = azurerm_network_security_group.any-to-any-cross-region-primary.id
}


##############################
# Spoke2 VNet
##############################

resource "azurerm_virtual_network" "primary-spoke2" {
  name                = "${var.primary-location}-spoke2"
  location            = var.primary-location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name
  address_space       = local.primary-spoke2-prefix
}

resource "azurerm_subnet" "primary-spoke2-fesubnet" {
    name                    = "frontend-subnet"
    resource_group_name     = azurerm_resource_group.hubandspoke-primary-rg.name
    virtual_network_name    = azurerm_virtual_network.primary-spoke2.name
    address_prefixes          = local.primary-spoke2-fesubnet
}

resource "azurerm_subnet_network_security_group_association" "primary-spoke2-fesubnet-nsg-a" {
  subnet_id                 = azurerm_subnet.primary-spoke2-fesubnet.id
  network_security_group_id = azurerm_network_security_group.any-to-any-cross-region-primary.id
}

resource "azurerm_subnet" "primary-spoke2-besubnet" {
    name                    = "backend-subnet"
    resource_group_name     = azurerm_resource_group.hubandspoke-primary-rg.name
    virtual_network_name    = azurerm_virtual_network.primary-spoke2.name
    address_prefixes          = local.primary-spoke2-besubnet
}

resource "azurerm_subnet_network_security_group_association" "primary-spoke2-besubnet-nsg-a" {
  subnet_id                 = azurerm_subnet.primary-spoke2-besubnet.id
  network_security_group_id = azurerm_network_security_group.any-to-any-cross-region-primary.id
}


#########################################################
# Peering hub <--> spoke1
#########################################################  
resource "azurerm_virtual_network_peering" "from-primary-hub-to-spoke1" {
  name                              = "from-hub-to-spoke1"
  resource_group_name               = azurerm_resource_group.hubandspoke-primary-rg.name
  virtual_network_name              = azurerm_virtual_network.primary-hub.name
  remote_virtual_network_id         = azurerm_virtual_network.primary-spoke1.id
  allow_virtual_network_access      = true
  allow_forwarded_traffic           = false
  allow_gateway_transit             = true
  use_remote_gateways               = false
  
  depends_on                        = [ azurerm_virtual_network_gateway.primary-vpngw ]
}

resource "azurerm_virtual_network_peering" "from-spoke1-to-primary-hub" {
  name                              = "from-spoke1-to-hub"
  resource_group_name               = azurerm_resource_group.hubandspoke-primary-rg.name
  virtual_network_name              = azurerm_virtual_network.primary-spoke1.name
  remote_virtual_network_id         = azurerm_virtual_network.primary-hub.id
  allow_virtual_network_access      = true
  allow_forwarded_traffic           = true
  allow_gateway_transit             = false
  use_remote_gateways               = true

  depends_on                        = [ azurerm_virtual_network_gateway.primary-vpngw ]
}


#########################################################
# Peering hub <--> spoke2
#########################################################  
resource "azurerm_virtual_network_peering" "from-primary-hub-to-spoke2" {
  name                              = "from-hub-to-spoke2"
  resource_group_name               = azurerm_resource_group.hubandspoke-primary-rg.name
  virtual_network_name              = azurerm_virtual_network.primary-hub.name
  remote_virtual_network_id         = azurerm_virtual_network.primary-spoke2.id
  allow_virtual_network_access      = true
  allow_forwarded_traffic           = false
  allow_gateway_transit             = true
  use_remote_gateways               = false
  
  depends_on                        = [ azurerm_virtual_network_gateway.primary-vpngw ]
}

resource "azurerm_virtual_network_peering" "from-spoke2-to-primary-hub" {
  name                              = "from-spoke2-to-hub"
  resource_group_name               = azurerm_resource_group.hubandspoke-primary-rg.name
  virtual_network_name              = azurerm_virtual_network.primary-spoke2.name
  remote_virtual_network_id         = azurerm_virtual_network.primary-hub.id
  allow_virtual_network_access      = true
  allow_forwarded_traffic           = true
  allow_gateway_transit             = false
  use_remote_gateways               = true

 depends_on                        = [ azurerm_virtual_network_gateway.primary-vpngw ]
}

#########################################################
# Peering primary --> secondary
######################################################### 

resource "azurerm_virtual_network_peering" "from-primary-hub-to-secondary-hub" {
  name                              = "from-${var.primary-location}-hub-to-${var.secondary-location}-hub"
  resource_group_name               = azurerm_resource_group.hubandspoke-primary-rg.name
  virtual_network_name              = azurerm_virtual_network.primary-hub.name
  remote_virtual_network_id         = azurerm_virtual_network.secondary-hub.id
  allow_virtual_network_access      = true
  allow_forwarded_traffic           = true
  allow_gateway_transit             = false
  use_remote_gateways               = false

}


#########################################################
# VPN Gateway
#########################################################  
resource "azurerm_public_ip" "primary-vpngw-pip-1" {
  name                = "${var.primary-location}-vpngw-pip-1"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  allocation_method = "Static"
}

resource "azurerm_public_ip" "primary-vpngw-pip-2" {
  name                = "${var.primary-location}-vpngw-pip-2"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  allocation_method = "Static"
}

resource "azurerm_virtual_network_gateway" "primary-vpngw" {
  name                = "${var.primary-location}-vpngw"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = true
  enable_bgp    = true
  sku           = "VpnGw2"
  generation    = "Generation2"  

  ip_configuration {
    name                          = "ipconfig1"
    public_ip_address_id          = azurerm_public_ip.primary-vpngw-pip-1.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.primary-hub-gatewaysubnet.id
  }

  ip_configuration {
    name                          = "ipconfig2"
    public_ip_address_id          = azurerm_public_ip.primary-vpngw-pip-2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.primary-hub-gatewaysubnet.id
  }

  bgp_settings {
    asn = "65001"
  }
}
