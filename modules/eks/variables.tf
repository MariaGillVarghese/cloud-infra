variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = "1.29"  # default to latest supported
}

variable "cluster_role_arn" {
  type = string
}

variable "node_role_arn" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "node_group_name" {
  type    = string
  default = "phoenix-dev-eks-node-group"
}

variable "node_instance_type" {
  type    = string
  default = "t3.micro"  # free-tier t3.micro is possible but small
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "max_capacity" {
  type    = number
  default = 3
}

variable "min_capacity" {
  type    = number
  default = 1
}
variable "ssh_key_name" {
  description = "SSH key name for EKS node group"
  type        = string
}