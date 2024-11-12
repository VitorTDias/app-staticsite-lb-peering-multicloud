output "vpc10_id" {
    value = "${aws_vpc.vpc10.id}"
}

output "sn_vpc10_pub" {
    value = "${aws_subnet.sn_vpc10_pub.id}"
}


output "vpc20_id" {
    value = "${aws_vpc.vpc20.id}"
}

output "sn_vpc20_pri" {
    value = "${aws_subnet.sn_vpc20_pri.id}"
}
