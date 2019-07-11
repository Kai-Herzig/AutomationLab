# Resource Group for Virtual Machine
resource "azurerm_resource_group" "resourcegroup" {
  name     = "tfws-${var.participant}-rg"
  location = "${var.location}"
    
  tags = {
    participant = "${var.participant}"
    environment = "${var.environment}"
  }
}

resource "azurerm_virtual_network" "virtualnetwork" {
  name                = "${var.participant}-vn"
  address_space       = ["${var.virtualnetwork_cidr}"]
  location            = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"

  tags = {
    participant = "${var.participant}"
    environment = "${var.environment}"
  }
 }

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.participant}-nsg"
  location            = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"

  security_rule {
    name                       = "CustomRule_RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }
  tags = {
    participant = "${var.participant}"
    environment = "${var.environment}"
  }
}

 resource "azurerm_subnet" "subnet" {
  name                 = "${var.participant}-vn-subnet1"
  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.virtualnetwork.name}"
  address_prefix       = "${var.subnet_cidr}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.participant}-pip"
  location            = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.participant}pipdnsname"

  tags = {
    participant = "${var.participant}"
    environment = "${var.environment}"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.participant}-nic1"
  location            = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"

  ip_configuration {
    name                          = "ipconfiguration1"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.pip.id}"
  }
  tags = {
    participant = "${var.participant}"
    environment = "${var.environment}"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation" {
  subnet_id                 = "${azurerm_subnet.subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
}

resource "azurerm_virtual_machine" "virtualmachine" {
  name                  = "${var.participant}-vm"
  location              = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name   = "${azurerm_resource_group.resourcegroup.name}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "Standard_D2s_v3"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true
  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.participant}-vm-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }
  os_profile {
    computer_name  = "${var.participant}-vm"
    admin_username = "${var.participant}-adm"
    admin_password = "Welcome2019!"
  }
  os_profile_windows_config{
    timezone = "W. Europe Standard Time"
  }
  tags = {
    participant = "${var.participant}"
    environment = "${var.environment}"
  }
}