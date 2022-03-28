resourcename  = "Azurermresourcegroup"
location      = "Korea Central"
storagename   = "azurermteststorage"
tags          = { environment = "demo", owner = "euimok", purpose = "demotest" }
tag2          = { resource = "virtualmachine", costcentre = "demotfcourse" }
containername = "tfdemocontainer"
dnsname       = ["euimok.com", "euimok2.com", "euimok3.com"]
networkname   = "Azurenetworksecuritygrouprules"
networkrule = [ 
  {
    name                       = "testrule1"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "testrule2"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "443"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "testrule3"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3389"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]

environment   = "dev"
account_type  = "Standard_GRS"
loc           = ["Korea", "Central"]
address_space = ["10.0.0.0/16", "10.0.0.1/32", "10.0.0.1/24", "10.0.2.0/24"]