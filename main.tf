terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resourcegroup" {
  #name = "AzureRMResourcegroup"
  name = var.resourcename
  #location = "North Europe"
  #location = "Korea Central"
  location = var.location
  tags     = var.tags
  timeouts {
    create = "60m"
    delete = "2h"
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storagename
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = azurerm_resource_group.resourcegroup.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags                     = var.tags
}

resource "azurerm_storage_container" "example" {
  count = 4
  name  = "${var.containername}${count.index}"
  #resource_group_name = azurerm_resource_group.resourcegroup.name   : 강의에는 있으나 실제로는 안됨.
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_dns_zone" "dnszone" {
  count               = length(var.dnsname)
  name                = var.dnsname[count.index]
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

resource "azurerm_network_security_group" "netrule" {
  #name                = "Azurenetworksecuritygrouprules"
  name                = var.networkname
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location

  dynamic "security_rule" {
    iterator = rule
    for_each = var.networkrule
    content {
      name                       = rule.value.name
      priority                   = rule.value.priority
      direction                  = rule.value.direction
      access                     = rule.value.access
      protocol                   = rule.value.protocol
      source_port_range          = rule.value.source_port_range
      destination_port_range     = rule.value.destination_port_range
      source_address_prefix      = rule.value.source_address_prefix
      destination_address_prefix = rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_cosmosdb_account" "db" {
  count               = var.environment == "prod" ? 2 : 1
  name                = "test-cosmos-db${count.index}"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  enable_automatic_failover = true

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    #prefix            = "tfex-cosmos-db-customid"
    location          = azurerm_resource_group.resourcegroup.location
    failover_priority = 0
  }
}

resource "azurerm_storage_account" "teststrg" {
  name                     = "euimokteststrg"
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = azurerm_resource_group.resourcegroup.location
  #account_tier             = trim(var.account_type, "_GRS")
  account_tier             = "Standard"
  account_replication_type = element(split("_", var.account_type), 1) # split을 쓰면 standard와 GRS가 추출되기 때문에 eliment function을 써야 한다. 
}

resource "azurerm_virtual_network" "azurevirtualnet" {
  name                = "euimokvirnet"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  #location = join("", var.loc)   섹션 3의 6에서 실습한 내용
  address_space = [element(var.address_space, 0)]
}

resource "azurerm_subnet" "azuresubnet" {
  name                 = "euimoksubnet"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.azurevirtualnet.name
  address_prefixes     = [element(var.address_space, 3)]
}

resource "azurerm_public_ip" "azurepuip" {
  count               = 3
  name                = "euimokpuip${count.index}"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  allocation_method   = "Static"
}
resource "azurerm_network_interface" "azurenic" {
  count               = 3
  name                = "euimok-nic${count.index}"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "euimoktestip"
    subnet_id                     = azurerm_subnet.azuresubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.azurepuip.*.id, count.index)
  }
}

resource "random_password" "azurepw" {
  length  = 8
  special = true
}

resource "azurerm_virtual_machine" "azurevm" {
  count                 = 3
  name                  = "euimokvm${count.index}"
  location              = azurerm_resource_group.resourcegroup.location
  resource_group_name   = azurerm_resource_group.resourcegroup.name
  network_interface_ids = [element(azurerm_network_interface.azurenic.*.id, count.index)]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = random_password.azurepw.result
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = merge(var.tags, var.tag2)
}
