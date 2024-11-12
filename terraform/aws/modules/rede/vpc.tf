resource "aws_vpc" "vpc10" {
    cidr_block           = "${var.vpc10_cidr}"
    enable_dns_hostnames = "true"
}

resource "aws_vpc" "vpc20" {
    cidr_block           = "${var.vpc20_cidr}"
    enable_dns_hostnames = "true"
}

resource "aws_subnet" "sn_vpc10_pub" {
    vpc_id                  = aws_vpc.vpc10.id
    cidr_block              = "${var.subnet_pub_cidr}"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "sn_vpc20_pri" {
    vpc_id            = aws_vpc.vpc20.id
    cidr_block        = "${var.subnet_pri_cidr}"
    availability_zone = "us-east-1a"
}

resource "aws_vpc_peering_connection" "vpc_peering" {
    peer_vpc_id   = aws_vpc.vpc20.id
    vpc_id        = aws_vpc.vpc10.id
    auto_accept   = true  
}

resource "aws_internet_gateway" "igw_vpc10" {
    vpc_id = aws_vpc.vpc10.id
}

resource "aws_route_table" "rt_sn_vpc10_pub" {
    vpc_id = aws_vpc.vpc10.id
    route {
        cidr_block = "${var.vpc20_cidr}"
        gateway_id = aws_vpc_peering_connection.vpc_peering.id
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_vpc10.id
    }
}

resource "aws_route_table" "rt_sn_vpc20_pri" {
    vpc_id = aws_vpc.vpc20.id
    route {
        cidr_block = "${var.vpc10_cidr}"
        gateway_id = aws_vpc_peering_connection.vpc_peering.id
    }
}

resource "aws_route_table_association" "rt_sn_vpc10_pub_To_sn_vpc10_pub" {
  subnet_id      = aws_subnet.sn_vpc10_pub.id
  route_table_id = aws_route_table.rt_sn_vpc10_pub.id
}

resource "aws_route_table_association" "rt_sn_vpc20_priv_To_sn_vpc20_pri" {
  subnet_id      = aws_subnet.sn_vpc20_pri.id
  route_table_id = aws_route_table.rt_sn_vpc20_pri.id
}

