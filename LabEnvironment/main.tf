resource "azurerm_resource_group" "TFWS_Labstations" {
  name     = "${var.rg_labstation}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "TFWS_Labstations-vn" {
  name                = "${var.rg_labstation}-vn"
  address_space       = ["${var.vn_labstations_cidr}"]
  location            = "${azurerm_resource_group.TFWS_Labstations.location}"
  resource_group_name = "${azurerm_resource_group.TFWS_Labstations.name}"
 }

 resource "azurerm_subnet" "subnet" {
  name                 = "${var.rg_labstation}-vn-subnet-labstations"
  resource_group_name  = "${azurerm_resource_group.TFWS_Labstations.name}"
  virtual_network_name = "${azurerm_virtual_network.TFWS_Labstations-vn.name}"
  address_prefix       = "${var.vn_subnetlabstations_cidr}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
}

resource "azurerm_network_interface" "nics" {
  count               = "${var.vm_count}"
  name                = "${var.labstation_prefix}-nic-${count.index+1}"
  location            = "${azurerm_resource_group.TFWS_Labstations.location}"
  resource_group_name = "${azurerm_resource_group.TFWS_Labstations.name}"

  ip_configuration {
    name                          = "labipconfiguration1"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.pip.*.id, count.index)}"
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.labstation_prefix}-nsg"
  location            = "${azurerm_resource_group.TFWS_Labstations.location}"
  resource_group_name = "${azurerm_resource_group.TFWS_Labstations.name}"

  security_rule {
    name                       = "RDPGW"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${var.rdpgwsource}"
    destination_address_prefix = "VirtualNetwork"
  }
}
resource "azurerm_subnet_network_security_group_association" "nsgtosubnet" {
  subnet_id                 = "${azurerm_subnet.subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
}

resource "azurerm_public_ip" "pip" {
  count                 = "${var.vm_count}"
  name                = "${var.labstation_prefix}-pip-${count.index+1}"
  location            = "${azurerm_resource_group.TFWS_Labstations.location}"
  resource_group_name = "${azurerm_resource_group.TFWS_Labstations.name}"
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.labstation_prefix}-vm-${count.index+1}"
}

resource "azurerm_virtual_machine" "labstations" {
  count                 = "${var.vm_count}"
  name                  = "${var.labstation_prefix}-vm-${count.index+1}"
  location              = "${azurerm_resource_group.TFWS_Labstations.location}"
  resource_group_name   = "${azurerm_resource_group.TFWS_Labstations.name}"
  network_interface_ids = ["${element(azurerm_network_interface.nics.*.id, count.index)}"]
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
    name              = "${var.labstation_prefix}-vm-${count.index+1}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }
  os_profile {
    computer_name  = "${var.labstation_prefix}-vm-${count.index+1}"
    admin_username = "testadmin-${count.index+1}"
    admin_password = "Welcome2019!"
  }
  os_profile_windows_config{
    timezone = "W. Europe Standard Time"
  }
}

# resource "azurerm_virtual_machine_extension" "extension" {
#     count              = "${var.vm_count}"
#   name                 = "${var.labstation_prefix}-vm-${count.index+1}-extension"
#   location              = "${azurerm_resource_group.TFWS_Labstations.location}"
#   resource_group_name   = "${azurerm_resource_group.TFWS_Labstations.name}"
#   virtual_machine_name = "${element(azurerm_virtual_machine.labstations.*.id, count.index)}"
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "1.9.3"

#   settings = <<SETTINGS
#     {
#         "commandToExecute": "powershell -ExecutionPolicy Unrestricted -command 'new-item -Type Directory -path \"C:\\" -Name "temporaer"'"
#     }
# SETTINGS

#   tags = {
#     environment = "Production"
#   }
# }