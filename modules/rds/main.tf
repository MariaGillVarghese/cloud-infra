resource "aws_db_subnet_group" "this" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier              = var.db_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.username
  password                = var.password

  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible     = false
  skip_final_snapshot     = true
  multi_az                = false

  storage_type            = "gp3"
  backup_retention_period = 0

  tags = {
    Name = var.db_identifier
  }
}
resource "aws_security_group" "rds_sg" {
  name        = "${var.db_identifier}-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    description = "MySQL from EC2"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [var.ec2_sg_id,var.eks_nodes_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}