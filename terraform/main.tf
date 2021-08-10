provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "iactools"
    key    = "terraform_state/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}

#VPC

resource "aws_vpc" "ust_Manu" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "ust_VPC"
  }

}

#Subnet

resource "aws_subnet" "ust_subnet" {
  vpc_id            = aws_vpc.ust_Manu.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.aws_az

  tags = {
    Name = "ust_subnet"
  }

}

#gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ust_Manu.id

  tags = {
    Name = "ust_gw"
  }
}

#route table

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.ust_Manu.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
    }

  tags = {
    Name = "ust_rt"
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
    Name = "ust_eip"
  }

}

#security groups

resource "aws_security_group" "ust_sg" {
  name   = "HTTP, HTTPS and  SSH"
  vpc_id = aws_vpc.ust_Manu.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 90
    to_port     = 90
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Network interface

resource "aws_network_interface" "ani" {
  subnet_id       = aws_subnet.ust_subnet.id
  private_ips     = [var.private_ip]
  security_groups = [aws_security_group.ust_sg.id]

  tags = {
    Name = "ust_ni"
  }

}

#ebs_block_size

resource "aws_ebs_volume" "ebs" {
  availability_zone = var.aws_az
  size              = 10

  tags = {
    Name = "ust_volume"
  }
}

#Instance

resource "aws_instance" "ustInstance" {
  ami           = var.aws_ami
  instance_type = "t2.micro"
  key_name      = var.aws_key_name
  network_interface {
     network_interface_id = aws_network_interface.ani.id
     device_index = 0
  }
   tags = {
     Name = "Deploy-VM"
  }
}