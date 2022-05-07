variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "udacity"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "eastus"
}
variable "username" {
  description = "The username of the vm."
}
variable "password" {
  type = string
  description = "The password of the vm."
}
variable "resource_group_name" {
  description = "The name of the resource group."
}