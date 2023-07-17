  terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 4.0"
      }
    }
  }
  provider "aws"{
     region = "us-east-1"
  }
  
  variable "ami" {
         type = string
  }

  variable "instance_type"{
      type = string
  }

  variable "instance_name"{
      type = string
  }

  variable "bucket_name"{
      type = string
  }

  variable "dynamo_table_name"{
      type = string
  }

  variable "my_environment"{
     type = string
  }

  resource "aws_instance" "my_instance"{
      count = 2
      ami = var.ami
      instance_type = var.instance_type
      tags = {
           Name = "${var.my_environment}-${var.instance_name}"
     }
  }
  resource "aws_s3_bucket" "my_bucket"{
       bucket = "${var.my_environment}-${var.bucket_name}"
  }
  resource "aws_dynamodb_table" "my_table"{
       name = "${var.my_environment}-${var.dynamo_table_name}"
       billing_mode = "PAY_PER_REQUEST"
       hash_key = "UserID"
       attribute{
           name = "UserID"
           type = "S"
       }
  }

  module "dev-app"{
     source = "./modules/my-app"
     my_environment = "dev"
     ami = "ami-06ca3ca175f37dd66 "
     instance_type = "t2.micro"
     instance_name = "Server"
     bucket_name = "day70-bucket-my-app1"
     dynamo_table_name = "day70-table-my-app1"
  }

  module "prd-app"{
     source = "./modules/my-app"
     my_environment = "prd"
     ami = "ami-06ca3ca175f37dd66 "
     instance_type = "t2.micro"
     instance_name = "Server"
     bucket_name = "day70-bucket-my-app1"
     dynamo_table_name = "day70-table-my-app1"
  }
  output "my_ec2_ip"{
    value = aws.instance.my_instance[*].public_ip
  }
