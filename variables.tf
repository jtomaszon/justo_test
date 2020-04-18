#----root/variables.tf-----
variable "aws_region" {
}

#----storage/variables.tf----
variable "db_name" {
}

#-------networking variables
variable "vpc_cidr" {
}

variable "vpc_private_cidr" {
}

variable "private_cidrs" {
  type = list(string)
}

variable "public_cidrs" {
  type = list(string)
}

variable "accessip" {
}

#-------compute variables
variable "key_name" {
}

variable "public_key_path" {
}

variable "server_instance_type" {
}

variable "instance_count" {
  default = 1
}

