variable "vpc10_id" {}
variable "subnet_pub_id" {}
variable "rede_pub_cidr" {}

variable "vpc20_id" {}
variable "subnet_pri_id" {}
variable "rede_pri_cidr" {}

variable "ami" {
    type    = string
    default = "ami-02e136e904f3da870"
    validation {
        condition     = length(var.ami) > 4 && substr(var.ami, 0, 4) == "ami-"
        error_message = "The ami value must be a valid AMI id, starting with \"ami-\"."
    }
}