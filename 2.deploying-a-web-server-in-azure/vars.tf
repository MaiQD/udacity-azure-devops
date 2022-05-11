variable "prefix" {
	type = string
	description = "Prefix for the resources"
	default = "udacity-project1"
}
variable "location" {
	type = string
	description = "Location you want to deploy"
	default = "eastasia"
}
variable "packer_image_name" {
	type = string
	description = "Packer image name"
	default = "udacity-vm-image"
}
variable "packer_image_resource_group_name" {
	type = string
	description = "Packer image resource group name"
	default = "udacity-vm-images"
}
variable "username" {
  description = "The username of the vm."
}
variable "password" {
  type = string
  description = "The password of the vm."
}
variable "number_of_vms" {
	type = number
	description = "Number of VMs to deploy"
}