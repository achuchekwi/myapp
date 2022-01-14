provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key

}
variable "region" {}
variable "access_key" {}
variable "secret_access" {}
variable "myvpc_cidr" {}
variable "mysubnet_cidr" {}
variable "myzone" {}
variable "route_cidr" {}
variable "from_port" {}
variable "to_port" {}
variable "protocol" {}
variable "cidr_for_security" {}
variable "master_ami" {}
variable "slave_ami" {}
variable "type" {}
variable "security_key" {}
variable "public_ip" {}
variable "master_count" {}
variable "slave_count" {}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.myvpc_cidr
  tags = {
     Name = "myvpc"
  }
}

resource "aws_subnet" "my_subnet" {
  cidr_block = var.mysubnet_cidr
  vpc_id = aws_vpc.my_vpc.id
  availability_zone = var.myzone
  tags = {
    Name = "mysubnet"
  }
}

resource "aws_internet_gateway" "my_gateway" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "mygateway"
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.my_gateway.id
  }
  tags = {
    Name = "myroute table"
  }
}
resource "aws_route_table_association" "my_association" {
  route_table_id = aws_route_table.my_route_table.id
  subnet_id = aws_subnet.my_subnet.id

}

resource "aws_security_group" "my_security" {
  name = "my_security"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port = var.from_port
    protocol = var.protocol
    to_port = var.to_port
    cidr_blocks = [var.cidr_for_security]
  }
  egress {
    from_port = var.from_port
    protocol = var.protocol
    to_port = var.to_port
    cidr_blocks = [var.cidr_for_security]
  }
  tags = {
    Name = "mysecurity"
  }
}

resource "aws_instance" "master_server" {
  count = var.master_count
  ami = var.master_ami
  instance_type = var.type
  subnet_id = aws_subnet.my_subnet.id
  availability_zone = var.myzone
  vpc_security_group_ids = [aws_security_group.my_security.id]
  key_name = var.security_key
  associate_public_ip_address = var.public_ip
  tags = {
    Name = "koho_master"
  }
}

resource "aws_instance" "slave_server" {
  count = var.slave_count
  ami = var.slave_ami
  instance_type = var.type
  subnet_id = aws_subnet.my_subnet.id
  availability_zone = var.myzone
  vpc_security_group_ids = [aws_security_group.my_security.id]
  key_name = var.security_key
  associate_public_ip_address = var.public_ip
  tags = {
    Name = "koho_slave"
  }
}

