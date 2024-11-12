variable "vpc10_cidr" {
    type    = string
    default = "10.0.0.0/16"
}

variable "subnet_pub_cidr" {
    type    = string
    default = "10.0.1.0/24"
}

variable "vpc20_cidr" {
    type    = string
    default = "20.0.0.0/16"
}

variable "subnet_pri_cidr" {
    type    = string
    default = "20.0.1.0/24"
}