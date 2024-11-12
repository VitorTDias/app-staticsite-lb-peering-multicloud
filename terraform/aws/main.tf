module "rede" {
    source      = "./modules/rede"
    vpc10_cidr   = "${var.vpc10_cidr}"
    subnet_pub_cidr = "${var.subnet_pub_cidr}"
    vpc20_cidr   = "${var.vpc20_cidr}"
    subnet_pri_cidr = "${var.subnet_pri_cidr}"
   
}

module "compute" {
    source     = "./modules/compute"
    vpc10_id    = "${modules.rede.vpc10_id}"
    vpc20_id    = "${modules.rede.vpc20_id}"
    sn_vpc10_pub_id  = "${modules.rede.subnet_pub_id}"
    sn_vpc20_pri_id  = "${modules.rede.subnet_pri_id}"
    vpc10_cidr  = "${var.vpc10_cidr}"
    vpc20_cidr  = "${var.vpc20_cidr}"
    ami        = "${var.ami}"
    depends_on = [modules.rede]
}