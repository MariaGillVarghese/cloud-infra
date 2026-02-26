provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr

  subnet_name = var.subnet_name
  subnet_cidr = var.subnet_cidr

  igw_name         = var.igw_name
  route_table_name = var.route_table_name
  sg_name          = var.sg_name
}
data "aws_ami" "ubuntu_24" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
module "ec2" {
  source = "../../modules/ec2"

  instance_name = "phoneix-dev-ec2-1"
  ami_id        = data.aws_ami.ubuntu_24.id
  instance_type = "t3.micro"

  subnet_id          = module.vpc.subnet_id
  security_group_id  = module.vpc.security_group_id

  key_name = "maria_keypair"
}