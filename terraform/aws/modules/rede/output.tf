output "vpc_id" {
    value = "${aws_vpc.vpc10.id}"
}

output "subnet_id" {
    value = "${aws_subnet.sn_vpc10_pub.id}"
}


output "vpc_id" {
    value = "${aws_vpc.vpc20.id}"
}

output "subnet_id" {
    value = "${aws_subnet.sn_vpc20_pri.id}"
}
