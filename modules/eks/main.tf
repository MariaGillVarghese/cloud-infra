########################################
# EKS Cluster
########################################
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]  # ADD THIS
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

########################################
# EKS Node Group
########################################
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }

  instance_types = [var.node_instance_type]
  ami_type       = "AL2_x86_64"

  remote_access {
    ec2_ssh_key               = var.ssh_key_name
    source_security_group_ids = [aws_security_group.eks_nodes_sg.id]
  }

  depends_on = [aws_eks_cluster.this]
}
resource "aws_security_group" "eks_cluster_sg" {
  name   = "${var.cluster_name}-cluster-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group" "eks_nodes_sg" {
  name   = "${var.cluster_name}-nodes-sg"
  vpc_id = var.vpc_id
}