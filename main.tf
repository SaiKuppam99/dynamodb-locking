terraform {
  backend "s3" {
    bucket         = "s3-backend-saivaiku"
    key            = "Sai/sai.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "dynamodb-state-locking"

  }
}

resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name  = var.vpc_name
    Owner = "SaiKuppam"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = var.IGW_name
  }
}

resource "aws_subnet" "subnet1-public" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.public_subnet1_cidr
  availability_zone = "eu-west-2a"

  tags = {
    Name = var.public_subnet1_name
  }
}

# resource "aws_subnet" "subnet2-public" {
#   vpc_id            = aws_vpc.default.id
#   cidr_block        = var.public_subnet2_cidr
#   availability_zone = "eu-west-2b"

#   tags = {
#     Name = var.public_subnet2_name
#   }
# }

# resource "aws_subnet" "subnet3-public" {
#   vpc_id            = aws_vpc.default.id
#   cidr_block        = var.public_subnet3_cidr
#   availability_zone = "eu-west-2c"

#   tags = {
#     Name = var.public_subnet3_name
#   }

# }


resource "aws_route_table" "terraform-public" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name = var.Main_Routing_Table
  }
}

resource "aws_route_table_association" "terraform-public" {
  subnet_id      = aws_subnet.subnet1-public.id
  route_table_id = aws_route_table.terraform-public.id
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# data "aws_ami" "my_ami" {
#   most_recent = true
#   #name_regex       = "^sai"
#   owners = ["232323232323232323"]
# }







##output "ami_id" {
#  value = "${data.aws_ami.my_ami.id}"
#}
#!/bin/bash
# echo "Listing the files in the repo."
# ls -al
# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
# echo "Running Packer Now...!!"
# packer build -var=aws_access_key=AAAAAAAAAAAAAAAAAA -var=aws_secret_key=BBBBBBBBBBBBB packer.json
# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
# echo "Running Terraform Now...!!"
# terraform init
# terraform apply --var-file terraform.tfvars -var="aws_access_key=AAAAAAAAAAAAAAAAAA" -var="aws_secret_key=BBBBBBBBBBBBB" --auto-approve
