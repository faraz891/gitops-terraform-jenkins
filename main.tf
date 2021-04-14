# Terraform state will be stored in S3
terraform {
  backend "s3" {
    bucket = "gitops-terraform-jenkins"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}

# Use AWS Terraform provider
provider "aws" {
  region = "us-west-2"
  access_key = "AKIA5MZCKJMC6XAPYEBO"
  secret_key= "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"
}

# Create EC2 instance
resource "aws_instance" "default1" {
  ami                    = var.ami
  count                  = var.instance_count
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.default.id]
  source_dest_check      = false
  instance_type          = var.instance_type

  tags = {
    Name = "terraform-default1"
  }
}

# Create Security Group for EC2
resource "aws_security_group" "default1" {
  name = "terraform-default-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
