provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr

  subnet_name = var.subnet_name
  subnet_cidr = var.subnet_cidr
  subnet_cidr_2 = var.subnet_cidr_2

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

  subnet_id = module.vpc.subnet_id
  vpc_id    = module.vpc.vpc_id

  key_name = "maria_keypair"
}
module "rds" {
  source = "../../modules/rds"

  db_identifier = "phoenix-dev-rds"
  db_name       = "phoenixdb"

  username = "phoenix123"
  password = "phoenix123"

  subnet_ids = module.vpc.subnet_ids
  vpc_id     = module.vpc.vpc_id

  ec2_sg_id       = module.ec2.security_group_id
  eks_nodes_sg_id = module.eks.eks_nodes_sg_id   
}
module "iamroles" {
  source = "../../modules/iamroles"

  cluster_role_name = "eksClusterRole"
  node_role_name    = "eksNodeRole"
}
module "eks" {
  source = "../../modules/eks"

  cluster_name          = "phoenix-dev-eks"
  kubernetes_version    = "1.29"

  cluster_role_arn      = module.iamroles.cluster_role_arn
  node_role_arn         = module.iamroles.node_role_arn

  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.subnet_ids
  ssh_key_name = var.ssh_key_name

  node_instance_type    = "t3.micro"
  desired_capacity      = 2
  min_capacity          = 1
  max_capacity          = 3
}