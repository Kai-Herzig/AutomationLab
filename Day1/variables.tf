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
  description = "Location"
  default = "northeurope"
}

variable "virtualnetwork_cidr" {
  description = "CIDR of Virtual Network"
  default = "10.0.0.0/26"
}
variable "subnet_cidr" {
  description = "CIDR of Subnet"
  default = "10.0.0.0/27"
}
variable "participant" {
  description = "Name of the Lab participant"
  default = "deckard"
}
variable "environment" {
  description = "Environment "
  default = "Test"
}