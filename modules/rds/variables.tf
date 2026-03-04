variable "db_identifier" {
  type = string
}

variable "engine" {
  type    = string
  default = "postgres"
}

variable "engine_version" {
  type    = string
  default = "16"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}

variable "subnet_ids" {
  type = list(string)
}


variable "vpc_id" { type = string }
variable "ec2_sg_id" { type = string }
variable "eks_nodes_sg_id" { type = string }