provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.45.0"
    }
  }
}
data "azurerm_virtual_network" "VNET-Test" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_vnet_name
}

data "azurerm_subnet" "ACR-Subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_vnet_name
  virtual_network_name = var.virtual_network_name
}

resource "azurerm_resource_group" "aks-rg" {
  name     = var.resource_group_name
  location = var.location
}
resource "azurerm_container_registry" "acr" {
  name                = var.azure_container_registry_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Premium"
  public_network_access_enabled = false
  admin_enabled       = false

  # dynamic "georeplications" {
  #   for_each = var.georeplications
  #   content {
  #     location                = georeplications.value.location
  #     zone_redundancy_enabled = georeplications.value.zone_redundancy_enabled
  #     tags                    = georeplications.value.tags
  #   }
  # }
network_rule_set {
  ip_rule{
    ip_range = "20.254.31.21"
    action =  "Allow"
  }
    
    # virtual_network  { 
    #   action =  "Allow"
    #   subnet_id = data.azurerm_subnet.ACR-Subnet.id
    # }

}

}


resource "azurerm_private_dns_zone" "dnszone" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_dnszone_name

}


resource "azurerm_private_dns_zone_virtual_network_link" "vnl" {
  name                  = var.private_dns_zone_virtual_network_link_name
  resource_group_name   = var.resource_group_dnszone_name
  virtual_network_id    = data.azurerm_virtual_network.VNET-Test.id
  private_dns_zone_name = azurerm_private_dns_zone.dnszone.name
}
# resource "azurerm_dns_a_record" "private_acr_record" {
#   name = azurerm_container_registry.acr.name
#   zone_name = azurerm_private_dns_zone.dnszone.name
#   resource_group_name = azurerm_resource_group.aks-rg.name
#   ttl = 300
#   records = [azurerm_container_registry.acr.login_server]
# }

resource "azurerm_private_endpoint" "acrpe" {
  name                = var.private_endpoint_acr_name
  location            = var.location
  resource_group_name = azurerm_resource_group.aks-rg.name
  subnet_id           = data.azurerm_subnet.ACR-Subnet.id
  private_dns_zone_group {

   name = azurerm_private_dns_zone.dnszone.name
   private_dns_zone_ids = [azurerm_private_dns_zone.dnszone.id]

  }

  private_service_connection {
    name                           = "acr-connection"
    is_manual_connection           = true
    request_message                   = "PL"
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
    
  }


}

