provider "aws" {
  profile = var.profile
  region  = var.region
}

terraform {
  backend "s3" {
    bucket = var.s3_bucket
    key    = var.state_key
    region = var.region
    dynamodb_table = var.dynamodb_table
  }
}

#VPC

resource "aws_vpc" "ust_Manu" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }

}

#Subnet

resource "aws_subnet" "ust_subnet" {
  vpc_id            = aws_vpc.ust_Manu.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.aws_az

  tags = {
    Name = var.subnet_name
  }

}

#gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ust_Manu.id

  tags = {
    Name = var.gateway_name
  }
}

#route table

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.ust_Manu.id

  route {
      cidr_block = var.route_cidr_block
      gateway_id = aws_internet_gateway.gw.id
    }

  tags = {
    Name = var.route_table_name
  }
}

#Route table association

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.ust_subnet.id
  route_table_id = aws_route_table.rt.id
}

#Elastic IP

resource "aws_eip" "ust_eip" {
  instance = aws_instance.ustInstance.id
  vpc      = true
  associate_with_private_ip = var.private_ip

  tags = {
    Name = var.eip_name
  }

}

#security groups

resource "aws_security_group" "ust_sg" {
  name   = "HTTP, HTTPS and  SSH"
  vpc_id = aws_vpc.ust_Manu.id

  ingress {
    description = "HTTP"
    from_port   = var.ingress_1
    to_port     = var.ingress_1
    protocol    = "tcp"
    cidr_blocks = var.security_cidr_blocks
  }
  
  ingress {
    description = "HTTP"
    from_port   = var.ingress_test_from
    to_port     = var.ingress_test_to
    protocol    = "tcp"
    cidr_blocks = var.security_cidr_blocks
  }

  ingress {
    description = "SSH"
    from_port   = var.ingress_2
    to_port     = var.ingress_2
    protocol    = "tcp"
    cidr_blocks = var.security_cidr_blocks
  }

  ingress {
    description = "HTTPS"
    from_port   = var.ingress_3
    to_port     = var.ingress_3
    protocol    = "tcp"
    cidr_blocks = var.security_cidr_blocks
  }

  egress {
    from_port   = var.egress
    to_port     = var.egress
    protocol    = -1
    cidr_blocks = var.security_cidr_blocks
  }
}

# Network interface

resource "aws_network_interface" "ani" {
  subnet_id       = aws_subnet.ust_subnet.id
  private_ips     = [var.private_ip]
  security_groups = [aws_security_group.ust_sg.id]

  tags = {
    Name = var.network_interface_name
  }

}

#ebs_volume

resource "aws_ebs_volume" "ebs" {
  availability_zone = var.aws_az
  size              = var.ebs_volume_size

  tags = {
    Name = var.ebs_volume_name
  }
}

#ebs_volume attachment

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs.id
  instance_id = aws_instance.ustInstance.id
}

#Instance

resource "aws_instance" "ustInstance" {
  ami           = var.aws_ami
  instance_type = var.instance_type
  key_name      = var.aws_key_name
  network_interface {
     network_interface_id = aws_network_interface.ani.id
     device_index = var.instance_index
  }
   tags = {
     Name = var.instance_name
  }
}
