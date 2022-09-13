#########################################################
# Variables
#########################################################

variable primary-rg {
  description = "Resource group for primary Azure region"
  type        = string
  default     = "HSLAB-primary-rg"
}

variable secondary-rg {
  description = "Resource group for secondary Azure region"
  type        = string
  default     = "HSLAB-secondary-rg"
}

variable onprem-site1-rg {
  description = "Resource group for simulated on-prem site 1"
  type        = string
  default     = "HSLAB-onprem1-rg"
}

variable onprem-site2-rg {
  description = "Resource group for simulated on-prem site 2"
  type        = string
  default     = "HSLAB-onprem2-rg"
}

variable "primary-location" {
  description   = "Azure location for primary region"
  type          = string
  default       = "westeurope"
}

variable "secondary-location" {
  description = "Azure location for secondary region"
  type        = string
  default       = "northeurope"
}

variable "vpngw-shared-key" {
    description = "Shared key for VNet 2  VNet connections"
    type = string
    default = "abcdef123"
}

variable "vm-user" {
    description = "Admin username for all VMs in the lab"
    type = string
    default = "azureuser"
}

variable "vm-password" {
    description = "Password for all VMs in the lab"
    type = string
}

variable "vm-size" {
    description = "Azure VM size for all VMs in the lab"
    type = string
    default = "Standard_B1s"
}



#########################################################
# Locals
#########################################################

locals {
    primary-region-prefix = "10.1.0.0/16"
    primary-hub-prefix = [ "10.1.0.0/24" ]
    primary-hub-gatewaysubnet = [ "10.1.0.0/27" ]
    primary-hub-azurebastionsubnet = [ "10.1.0.32/27" ]
    primary-hub-azurefirewallsubnet = [ "10.1.0.64/26" ]
    primary-hub-vmsubnet = [ "10.1.0.128/27" ] 
    primary-spoke1-prefix = [ "10.1.1.0/24" ]
    primary-spoke1-fesubnet = [ "10.1.1.0/25" ]
    primary-spoke1-besubnet = [ "10.1.1.128/25" ]
    primary-spoke2-prefix = [ "10.1.2.0/24" ]
    primary-spoke2-fesubnet = [ "10.1.2.0/25" ]
    primary-spoke2-besubnet = [ "10.1.2.128/25" ]
    secondary-region-prefix = "10.2.0.0/16"
    secondary-hub-prefix = [ "10.2.0.0/24" ]
    secondary-hub-gatewaysubnet = [ "10.2.0.0/27" ]
    secondary-hub-azurebastionsubnet = [ "10.2.0.32/27" ]
    secondary-hub-azurefirewallsubnet = [ "10.2.0.64/26" ]
    secondary-hub-vmsubnet = [ "10.2.0.128/27" ]
    secondary-spoke1-prefix = [ "10.2.1.0/24" ]
    secondary-spoke1-fesubnet = [ "10.2.1.0/25" ]
    secondary-spoke1-besubnet = [ "10.2.1.128/25" ]
    secondary-spoke2-prefix = [ "10.2.2.0/24" ]
    secondary-spoke2-fesubnet = [ "10.2.2.0/25" ]
    secondary-spoke2-besubnet = [ "10.2.2.128/25" ]
    onprem-site-1-prefix = [ "192.168.1.0/24" ]
    onprem-site-1-gatewaysubnet = [ "192.168.1.0/27" ]
    onprem-site-1-azurebastionsubnet = [ "192.168.1.32/27" ]
    onprem-site-1-vmsubnet = [ "192.168.1.64/27" ]
    onprem-site-2-prefix = [ "192.168.2.0/24" ]
    onprem-site-2-gatewaysubnet = [ "192.168.2.0/27" ]
    onprem-site-2-azurebastionsubnet = [ "192.168.2.32/27" ]
    onprem-site-2-vmsubnet = [ "192.168.2.64/27" ]
}