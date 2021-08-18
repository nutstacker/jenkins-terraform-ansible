variable profile{
    default = "default"
}
variable region{
    default = "us-east-1"
}
variable s3_bucket{
    default = "iactools"
}
variable state_key{
    default = "terraform_state/terraform.tfstate"
}
variable dynamodb_table{
    default = "terraform-state-lock"
}
variable vpc_name{
    default = "ust_VPC"
}
variable subnet_name{
    default = "ust_subnet"
}
variable gateway_name{
    default = "ust_gw"
}
variable route_table_name{
    default = "ust_rt"
}
variable eip_name{
    default = "ust_eip"
}
variable network_interface_name{
    default = "ust_ni"
}
variable ebs_volume_name{
    default = "manu_volume"
}
variable ebs_volume_size{
    default = "10"
}
variable instance_type{
    default = "t2.micro"
}
variable instance_index{
    default = "10"
}
variable instance_name{
    default = "Deploy-VM"
}
variable route_cidr_block{
    default = "0.0.0.0/0"
}
variable security_cidr_blocks{
    default = ["0.0.0.0/0"]
}
variable vpc_cidr_block{
    default = "172.16.0.0/16"
}
variable subnet_cidr_block{
    default = "172.16.10.0/24"
}
variable aws_az{
    default = "us-east-1a"
}
variable aws_ami{
    default = "ami-0dc2d3e4c0f9ebd18"
}
variable aws_key_name{
    default = "ust-test"
}
variable aws_subnet_id{
    default = "subnet-0de6381deb870a130"
}
variable private_ip{
    default = "172.16.10.200"
}
variable ingress_1{
    default = "80"
}
variable ingress_2{
    default = "22"
}
variable ingress_3{
    default = "443"
}
variable ingress_test_from{
    default = "8081"
}
variable ingress_test_to{
    default = "8095"
}
variable egress{
    default = "0"
}
