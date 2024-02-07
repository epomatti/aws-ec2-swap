terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.35.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  workload = "swap"
}

module "vpc" {
  source   = "./modules/vpc"
  region   = var.aws_region
  workload = local.workload
}

module "ssm" {
  source = "./modules/ssm"
}

module "server" {
  source        = "./modules/server"
  workload      = local.workload
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_id
  instance_type = var.instance_type
  ami           = var.ami
  user_data     = var.user_data

  depends_on = [module.ssm]
}
