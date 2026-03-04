resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  associate_public_ip_address = true   # ✅ Important

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  key_name = var.key_name

  tags = {
    Name = var.instance_name
  }
}
resource "aws_security_group" "ec2_sg" {
  name        = "${var.instance_name}-sg"
  description = "Security group for EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # change later for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}