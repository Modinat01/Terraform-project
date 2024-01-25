provider "aws" {
  region = "us-east-1"
}


# Create custom vpc
resource "aws_vpc" "app-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "${var.env_prefix}-vpc"
  }
}

module "myapp-subnet" {
  source                 = "./modules/subnet"
  subnet_cidr_block      = var.subnet_cidr_block
  avail_zone             = var.avail_zone
  env_prefix             = var.env_prefix
  vpc_id                 = aws_vpc.app-vpc.id
  default_route_table_id = aws_vpc.app-vpc.default_route_table_id
}

module "app-server" {
  source              = "./modules/webserver"
  vpc_id              = aws_vpc.app-vpc.id
  subnet_id           = module.myapp-subnet.subnet.id
  public_key_location = var.public_key_location
  env_prefix          = var.env_prefix
  my_ip               = var.my_ip
  instance_type       = var.instance_type
  image_name          = var.image_name
  avail_zone          = var.avail_zone
}