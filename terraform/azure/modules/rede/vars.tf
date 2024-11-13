variable "rg_name" {
    type    = string
    default = "rg-default"
}

variable "location" {
    type    = string
    default = "brazilsouth"
}

variable "vnet10_cidr" {
    type    = string
    default = "10.0.0.0/16"
}

variable "subnet_vnet10a_cidr" {
    type    = string
    default = "10.0.1.0/24"
}

variable "subnet_vnet10b_cidr" {
    type    = string
    default = "10.0.2.0/24"
}

variable "vnet20_cidr" {
    type    = string
    default = "20.0.0.0/16"
}

variable "subnet_vnet20_cidr" {
    type    = string
    default = "20.0.1.0/24"
}