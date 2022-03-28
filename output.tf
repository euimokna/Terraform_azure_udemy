
output "rgname" {
  value = azurerm_resource_group.resourcegroup.name
}

output "storage" {
  value = azurerm_storage_account.storage.name
}

output "container" {
  value = azurerm_storage_container.example[*].name
}

output "dnszone" {
  value = [for i in var.dnsname : upper(i)]
}

output "random_password" {
  value = random_password.azurepw.result
  sensitive = true
}

output "public_ip" {
  value = azurerm_public_ip.azurepuip.*.ip_address
}

output "virtual_machine" {
  value = azurerm_virtual_machine.azurevm.*.name
}