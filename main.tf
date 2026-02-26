provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu_24" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "maria_ec2_2" {

  ami                    = data.aws_ami.ubuntu_24.id
  instance_type          = "t3.micro"
  subnet_id              = "subnet-0137d996f48270231"
  vpc_security_group_ids = ["sg-0718bde13c3a1a1e4"]
  availability_zone      = "us-east-1a"
  key_name               = "maria_keypair"

  tags = {
    Name = "maria_ec2_2"
  }
}