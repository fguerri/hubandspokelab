##############################################
# Network security groups - Primary region
##############################################

resource "azurerm_network_security_group" "any-to-any-cross-region-primary" {
  name                = "any-to-any-cross-region"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name
}

resource "azurerm_network_security_rule" "allow-rfc-1918-primary-in" {
  name                          = "allow-rfc-1918-inbound"
  priority                      = 100
  direction                     = "Inbound"
  access                        = "Allow"
  protocol                      = "*"
  source_port_range             = "*"
  destination_port_range        = "*"
  source_address_prefixes       = [ "10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16" ]
  destination_address_prefixes  = [ "10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16" ]
  resource_group_name           = azurerm_resource_group.hubandspoke-primary-rg.name
  network_security_group_name   = azurerm_network_security_group.any-to-any-cross-region-primary.name
}

resource "azurerm_network_security_rule" "allow-rfc-1918-primary-out" {
  name                          = "allow-rfc-1918-outbound"
  priority                      = 100
  direction                     = "Outbound"
  access                        = "Allow"
  protocol                      = "*"
  source_port_range             = "*"
  destination_port_range        = "*"
  source_address_prefixes       = [ "10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16" ]
  destination_address_prefixes  = [ "10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16" ]
  resource_group_name           = azurerm_resource_group.hubandspoke-primary-rg.name
  network_security_group_name   = azurerm_network_security_group.any-to-any-cross-region-primary.name
}


##############################################
# Network security groups - Secondary region
##############################################

resource "azurerm_network_security_group" "any-to-any-cross-region-secondary" {
  name                = "any-to-any-cross-region"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name
}

resource "azurerm_network_security_rule" "allow-rfc-1918-secondary-in" {
  name                          = "allow-rfc-1918-inbound"
  priority                      = 100
  direction                     = "Inbound"
  access                        = "Allow"
  protocol                      = "*"
  source_port_range             = "*"
  destination_port_range        = "*"
  source_address_prefixes       = [ "10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16" ]
  destination_address_prefixes  = [ "10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16" ]
  resource_group_name           = azurerm_resource_group.hubandspoke-secondary-rg.name
  network_security_group_name   = azurerm_network_security_group.any-to-any-cross-region-secondary.name
}

resource "azurerm_network_security_rule" "allow-rfc-1918-secondary-out" {
  name                          = "allow-rfc-1918-outbound"
  priority                      = 100
  direction                     = "Outbound"
  access                        = "Allow"
  protocol                      = "*"
  source_port_range             = "*"
  destination_port_range        = "*"
  source_address_prefixes       = [ "10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16" ]
  destination_address_prefixes  = [ "10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16" ]
  resource_group_name           = azurerm_resource_group.hubandspoke-secondary-rg.name
  network_security_group_name   = azurerm_network_security_group.any-to-any-cross-region-secondary.name
}


#########################################
# Azure Firewall Policies - Cross-region
#########################################

resource "azurerm_firewall_policy" "cross-region-azfw-policy" {
  name                = "cross-region-azfw-policy"
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name
  location            = azurerm_resource_group.hubandspoke-primary-rg.location

  sku = "Premium"
}

resource "azurerm_firewall_policy_rule_collection_group" "cross-region-azfw-rulecollectiongroup" {
  name                  = "cross-region-azfwpolicy-rcg"
  firewall_policy_id    = azurerm_firewall_policy.cross-region-azfw-policy.id
  priority              = 300

  network_rule_collection {
    name     = "cross-region-allow-network-rules"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "allow-access-to-any-from-onprem-site-1-vm"
      protocols             = ["Any"]
      source_addresses      = [ azurerm_network_interface.onprem-site-1-vm-nic.ip_configuration[0].private_ip_address ]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
    rule {
      name                  = "allow-spoke1-fe-in-${var.primary-location}-to-spoke2-fe-in-${var.secondary-location}"
      protocols             = ["Any"]
      source_ip_groups      = [ azurerm_ip_group.primary-spoke1-fesubnet.id ]
      destination_ip_groups = [ azurerm_ip_group.secondary-spoke2-fesubnet.id ]
      destination_ports     = ["*"]
    }
    rule {
      name                  = "allow-hub-vmsubnet-in-${var.primary-location}-to-spoke1-fe-in-${var.secondary-location}"
      protocols             = ["Any"]
      source_ip_groups      = [ azurerm_ip_group.primary-hub-vmsubnet.id ]
      destination_ip_groups = [ azurerm_ip_group.secondary-spoke1-fesubnet.id ]
      destination_ports     = ["*"]
    }
  }
  network_rule_collection {
    name     = "cross-region-deny-network-rules"
    priority = 200
    action   = "Deny"
    rule {
      name                  = "deny-${var.primary-location}-to-${var.secondary-location}"
      protocols             = ["Any"]
      source_ip_groups      = [ azurerm_ip_group.primary-hub.id, azurerm_ip_group.primary-spoke1.id, azurerm_ip_group.primary-spoke2.id ]
      destination_ip_groups = [ azurerm_ip_group.secondary-hub.id, azurerm_ip_group.secondary-spoke1.id, azurerm_ip_group.secondary-spoke2.id ]
      destination_ports     = ["*"]
    }
    rule {
      name                  = "deny-${var.secondary-location}-to-${var.primary-location}"
      protocols             = ["Any"]
      source_ip_groups      = [ azurerm_ip_group.secondary-hub.id, azurerm_ip_group.secondary-spoke1.id, azurerm_ip_group.secondary-spoke2.id ]
      destination_ip_groups = [ azurerm_ip_group.primary-hub.id, azurerm_ip_group.primary-spoke1.id, azurerm_ip_group.primary-spoke2.id ]
      destination_ports     = ["*"]
    }
  }
}


############################################
# Azure Firewall Policies - Primary region
############################################

resource "azurerm_firewall_policy" "primary-azfw-policy" {
  name                = "${var.primary-location}-azfw-policy"
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name
  location            = azurerm_resource_group.hubandspoke-primary-rg.location

  sku = "Premium"

  base_policy_id = azurerm_firewall_policy.cross-region-azfw-policy.id
}

resource "azurerm_firewall_policy_rule_collection_group" "primary-azfw-rulecollectiongroup" {
  name                  = "${var.primary-location}-azfwpolicy-rcg"
  firewall_policy_id    = azurerm_firewall_policy.primary-azfw-policy.id
  priority              = 500

  network_rule_collection {
    name     = "network_rule_collection1"
    priority = 500
    action   = "Allow"
    rule {
      name                  = "allow-spoke1-fe-to-spoke2-fe-in-${var.primary-location}"
      protocols             = ["Any"]
      source_ip_groups      = [ azurerm_ip_group.primary-spoke1-fesubnet.id ]
      destination_ip_groups = [ azurerm_ip_group.primary-spoke2-fesubnet.id ]
      destination_ports     = ["*"]
    }
    rule {
      name                  = "allow-spoke2-fe-to-spoke2-be-in-${var.primary-location}"
      protocols             = ["Any"]
      source_ip_groups      = [ azurerm_ip_group.primary-spoke2-fesubnet.id ]
      destination_ip_groups = [ azurerm_ip_group.primary-spoke2-besubnet.id ]
      destination_ports     = ["*"]
    }
  }
}


############################################
# Azure Firewall Policies - Secondary region
############################################

resource "azurerm_firewall_policy" "secondary-azfw-policy" {
  name                = "${var.secondary-location}-azfw-policy"
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name
  location            = azurerm_resource_group.hubandspoke-primary-rg.location

  sku = "Premium"

  base_policy_id = azurerm_firewall_policy.cross-region-azfw-policy.id
}

resource "azurerm_firewall_policy_rule_collection_group" "secondary-azfw-rulecollectiongroup" {
  name                  = "${var.secondary-location}-azfwpolicy-rcg"
  firewall_policy_id    = azurerm_firewall_policy.secondary-azfw-policy.id
  priority              = 500
}


##############################
# Azure Firewall - Primary
##############################

resource "azurerm_public_ip" "azfw-pip-primary" {
  name                = "${var.primary-location}-azfw-pip"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "azfw-primary" {
  name                = "${var.primary-location}-azfw"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"

  firewall_policy_id = azurerm_firewall_policy.primary-azfw-policy.id

  ip_configuration {
    name                 = "ipconfig"
    subnet_id            = azurerm_subnet.primary-hub-azurefirewallsubnet.id
    public_ip_address_id = azurerm_public_ip.azfw-pip-primary.id
  }
}


##############################
# Azure Firewall - Secondary
##############################

resource "azurerm_public_ip" "azfw-pip-secondary" {
  name                = "${var.secondary-location}-azfw-pip"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "azfw-secondary" {
  name                = "${var.secondary-location}-azfw"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"

  firewall_policy_id = azurerm_firewall_policy.secondary-azfw-policy.id

  ip_configuration {
    name                 = "ipconfig"
    subnet_id            = azurerm_subnet.secondary-hub-azurefirewallsubnet.id
    public_ip_address_id = azurerm_public_ip.azfw-pip-secondary.id
  }
}


##############################
# IP Groups
##############################

resource "azurerm_ip_group" "primary-hub" {
  name                = "${var.primary-location}-hub-vnet"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.primary-hub-prefix
}

resource "azurerm_ip_group" "primary-hub-vmsubnet" {
  name                = "${var.primary-location}-hub-vmsubnet"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.primary-hub-vmsubnet
}

resource "azurerm_ip_group" "primary-spoke1" {
  name                = "${var.primary-location}-spoke1"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.primary-spoke1-prefix
}

resource "azurerm_ip_group" "primary-spoke1-fesubnet" {
  name                = "${var.primary-location}-spoke1-fesubnet"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.primary-spoke1-fesubnet
}

resource "azurerm_ip_group" "primary-spoke1-besubnet" {
  name                = "${var.primary-location}-spoke1-besubnet"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.primary-spoke1-besubnet
}

resource "azurerm_ip_group" "primary-spoke2" {
  name                = "${var.primary-location}-spoke2"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.primary-spoke2-prefix
}

resource "azurerm_ip_group" "primary-spoke2-fesubnet" {
  name                = "${var.primary-location}-spoke2-fesubnet"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.primary-spoke2-fesubnet
}

resource "azurerm_ip_group" "primary-spoke2-besubnet" {
  name                = "${var.primary-location}-spoke2-besubnet"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.primary-spoke2-besubnet
}

resource "azurerm_ip_group" "secondary-hub" {
  name                = "${var.secondary-location}-hub-vnet"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.secondary-hub-prefix
}

resource "azurerm_ip_group" "secondary-hub-vmsubnet" {
  name                = "${var.secondary-location}-hub-vmsubnet"
  location            = azurerm_resource_group.hubandspoke-secondary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-secondary-rg.name

  cidrs = local.secondary-hub-vmsubnet
}

resource "azurerm_ip_group" "secondary-spoke1" {
  name                = "${var.secondary-location}-spoke1"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.secondary-spoke1-prefix
}

resource "azurerm_ip_group" "secondary-spoke1-fesubnet" {
  name                = "${var.secondary-location}-spoke1-fesubnet"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.secondary-spoke1-fesubnet
}

resource "azurerm_ip_group" "secondary-spoke1-besubnet" {
  name                = "${var.secondary-location}-spoke1-besubnet"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.secondary-spoke1-besubnet
}

resource "azurerm_ip_group" "secondary-spoke2" {
  name                = "${var.secondary-location}-spoke2"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.secondary-spoke2-prefix
}

resource "azurerm_ip_group" "secondary-spoke2-fesubnet" {
  name                = "${var.secondary-location}-spoke2-fesubnet"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.secondary-spoke2-fesubnet
}

resource "azurerm_ip_group" "secondary-spoke2-besubnet" {
  name                = "${var.secondary-location}-spoke2-besubnet"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.secondary-spoke2-besubnet
}

resource "azurerm_ip_group" "onprem-site-1" {
  name                = "onprem-site-1"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.onprem-site-1-prefix
}

resource "azurerm_ip_group" "onprem-site-1-vmsubnet" {
  name                = "onprem-site-1-vmsubnet"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.onprem-site-1-vmsubnet
}

resource "azurerm_ip_group" "onprem-site-2" {
  name                = "onprem-site-2"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.onprem-site-2-prefix 
}

resource "azurerm_ip_group" "onprem-site-2-vmsubnet" {
  name                = "onprem-site-2-vmsubnet"
  location            = azurerm_resource_group.hubandspoke-primary-rg.location
  resource_group_name = azurerm_resource_group.hubandspoke-primary-rg.name

  cidrs = local.onprem-site-2-vmsubnet 
}

