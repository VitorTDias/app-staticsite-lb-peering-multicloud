variable "rg_name" {
    type    = string
    default = "rg-staticsitelbpeering2"
}

variable "location" {
    type    = string
    default = "brazilsouth"
}

variable "vnet10_cidr" {
    type    = string
    default = "10.0.0.0/16"
}

variable "subnet_vnet10_cidr" {
    type    = string
    default = "10.0.1.0/24"
}

variable "vnet20_cidr" {
    type    = string
    default = "20.0.0.0/16"
}

variable "subnet_vnet20_cidr" {
    type    = string
    default = "20.0.1.0/24"
}

variable "fqdn" {
    type    = string
    default = "staticsitelbpeeringvt2"
}