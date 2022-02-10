##############################################################
# Terraform
##############################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70.0"
    }
  }
}

##########################################################
#  Provider
###########################################################


provider "aws" {
  region = "us-west-2"
  profile = "ecs"
}


##############################################################
# DATA
###############################################################

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_elb_service_account" "root" {}

data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}


################################################################
# Resources
#################################################################

# Networking
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    Name = "tf_vpc"
  }
}

resource aws_internet_gateway "igw" {
  vpc_id = aws_vpc.vpc.id

}

resource "aws_subnet"  "subnet1" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  availability_zone = "us-west-2b"
}

#Routing
resource "aws_route_table"  "rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }
}

resource "aws_route_table_association" "rta_subnet1" {
  subnet_id =  aws_subnet.subnet1.id
  route_table_id = aws_route_table.rtb.id
}

#Security Group
#Nginx
resource "aws_security_group" "cert-sg" {
  name = "ec2-sg"
  vpc_id =  aws_vpc.vpc.id

  ingress {
    from_port =  80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip_cidr]
    #security_groups = [aws_security_group.app_lb_sg]
  }


  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "s3_access_role" {

  assume_role_policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
  )
}


resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance"
  role = aws_iam_role.s3_access_role.name
}

#Instances
resource "aws_instance" "certinstance" {
  ami = data.aws_ami.ubuntu.id
  instance_type =  "t2.micro"
  subnet_id = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.cert-sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  key_name = "${var.key_name}"
  user_data = templatefile("${path.module}/startup_script.tpl" , {})

}