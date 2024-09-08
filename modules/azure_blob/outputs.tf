output "container_name" {
  value = azurerm_storage_container.sc.name
}

output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}

output "storage_account_primary_connection_string" {
  value = azurerm_storage_account.sa.primary_connection_string
}
