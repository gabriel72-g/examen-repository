terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "gabrieldaw"

  tags = {
    Name        = "TerraformStateBucket"
    Environment = "Dev"
  }

}
resource "aws_vpc" "mi_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "MiVPC"
  }
}

resource "aws_subnet" "subnet_publica" {
  vpc_id                  = aws_vpc.mi_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet"
  }
}
resource "aws_internet_gateway" "gatewaay" {
  vpc_id = aws_vpc.mi_vpc.id
  tags = {
    Name = "example-igw"
  }
}

resource "aws_route_table" "tabla" {
  vpc_id = aws_vpc.mi_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gatewaay.id
  }

  tags = {
    Name = "example-public-route-table"
  }
}

resource "aws_route_table_association" "asociacion" {
  subnet_id      = aws_subnet.subnet_publica.id
  route_table_id = aws_route_table.tabla.id
}

resource "aws_eip" "elatico" {
  domain = "vpc"
}

/* resource "aws_eip_association" "example_association" {
  instance_id   = aws_instance.web_instance.id
  allocation_id = aws_eip.elatico.id
} */
