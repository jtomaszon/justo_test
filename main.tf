#----root/main.tf-----
provider "aws" {
  region = var.aws_region
}

# Deploy Networking Resources
module "networking" {
  source           = "./networking"
  vpc_cidr         = var.vpc_cidr
  vpc_private_cidr = var.vpc_private_cidr
  private_cidrs    = var.private_cidrs
  public_cidrs     = var.public_cidrs
  accessip         = var.accessip
}

# Deploy Compute Resources
module "compute" {
  source          = "./compute"
  instance_count  = var.instance_count
  key_name        = var.key_name
  public_key_path = var.public_key_path
  instance_type   = var.server_instance_type
  private_subnets = module.networking.private_subnets
  public_subnets  = module.networking.public_subnets
  private_sgroup  = module.networking.private_sg
  public_sgroup   = module.networking.public_sg
  main_vpc        = module.networking.main_vpc
  subnet_ips      = module.networking.subnet_ips
  redis_subnet    = module.networking.redis_subnet
}

# Deploy Storage Resources
module "storage" {
  source  = "./storage"
  db_name = var.db_name
  subnets = module.networking.private_subnets
}
