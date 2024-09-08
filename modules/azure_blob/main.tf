resource "random_id" "rg" {
  byte_length = 8
  prefix      = "api"
}

resource "random_id" "sa" {
  byte_length = 8
  prefix      = "api"
}

resource "random_id" "sc" {
  byte_length = 8
  prefix      = "api"
}

resource "azurerm_resource_group" "rg" {
  name     = random_id.rg.hex
  location = var.azure_location
}

resource "azurerm_storage_account" "sa" {
  name                     = random_id.sa.hex
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "sc" {
  name                  = random_id.sc.hex
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}
