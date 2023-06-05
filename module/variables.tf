variable "azure_container_registry_name" {
  description = "Name of the ACR to be created."
  type        = string
  default     = "acrprivatenewtestregistry"
}

variable "resource_group_name" {
  description = "Name of the resource group to create the ACR in."
  type        = string
  default     = "acrtestRG"
}

variable "location" {
  description = "Location for the ACR to be created."
  type        = string
  default     = "UK South"
}

# variable "georeplications" {
#   type = map(object({
#     location                = string
#     zone_redundancy_enabled = bool
#     tags                    = map(string)
#   }))
#   default = {
#     east_asia = {
#       location                = "East Asia"
#       zone_redundancy_enabled = false
#       tags                    = {}
#     },
#     north_europe = {
#       location                = "North Europe"
#       zone_redundancy_enabled = false
#       tags                    = {}
#     }
#   }
# }
variable "virtual_network_name" {
  type = string
  default = "VNET-Test"
}

variable "resource_group_vnet_name" {
  type = string
  default = "MVP-RG"
}

variable "subnet_name" {
  type = string
  default = "ACR-Subnet"
}

# variable "container_registry_name" {
#   type = string
#   default = ""
# }

# variable "resource_group_acr_name" {
#   type = string
#   default = ""
# }

variable "private_dns_zone_name" {
  type = string
  default = "acr.privatedns"
}

variable "resource_group_dnszone_name" {
  type = string
  default = "MVP-RG"
}

variable "private_dns_zone_virtual_network_link_name" {
  type = string
  default = "dnszonevirtualnetworklink"
}

variable "private_endpoint_acr_name" {
  type = string
  default = "privateendpointacr"
}

# variable "resource_group_pe_name" {
#   type = string
#   default = ""
# }
