// outputs of the VPC and subnets, including nat gateway and route tables

output "vpc_id" {
  value = aws_vpc.iac-vpc.id
}

output "public_subnet_1_id" {
  value = aws_subnet.public-subnet-1.id
}

output "public_subnet_2_id" {
  value = aws_subnet.public-subnet-2.id
}

output "private_subnet_1_id" {
  value = aws_subnet.private-subnet-1.id
}

output "private_subnet_2_id" {
  value = aws_subnet.private-subnet-2.id
}

output "public_route_table_id" {
  value = aws_route_table.public-route-table.id
}

output "private_route_table_id" {
  value = aws_route_table.private-route-table.id
}

output "public_route_table_association_1_id" {
  value = aws_route_table_association.public-route-1-association.id
}

output "public_route_table_association_2_id" {
  value = aws_route_table_association.public-route-2-association.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat-gw.id
}

output "nat_gateway_public_ip" {
  value = aws_nat_gateway.nat-gw.public_ip
}

output "nat_gateway_private_ip" {
  value = aws_nat_gateway.nat-gw.private_ip
}

output "nat_gateway_network_interface_id" {
  value = aws_nat_gateway.nat-gw.network_interface_id
}

output "nat_gateway_subnet_id" {
  value = aws_nat_gateway.nat-gw.subnet_id
}

output "private_subnet_group_name" {
  value = aws_db_subnet_group.private_subnet_group.name
}
