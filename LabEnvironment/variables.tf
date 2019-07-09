variable "provider_subscription_id" {
  description = "Subscription ID"
}
variable "provider_client_id" {
  description = "Application ID"
}
variable "provider_client_secret" {
  description = "Application Token"
}
variable "provider_tenant_id" {
  description = "Azure Active Directory ID"
}

variable "location" {
  description = "Location of Terraform Lab"
  default = "northeurope"
}

variable "rg_labstation" {
  description = "Name of Terraform Lab Resource Group"
  default = "TFWS_Labstations"
}

variable "vn_labstations_cidr" {
  description = "CIDR of Terraform Lab Virtual Network"
  default = "10.0.0.0/26"
}
variable "vn_subnetlabstations_cidr" {
  description = "CIDR of Subnet of Terraform Lab Virtual Network"
  default = "10.0.0.0/26"
}
variable "vm_count" {
  description = "Number of VMs"
  default = "1"
}
variable "labstation_prefix" {
  description = "Prefix for Labstation naming"
  default = "labstation"
}