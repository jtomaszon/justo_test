#-----compute/variables.tf

variable "key_name" {
}

variable "public_key_path" {
}

variable "subnet_ips" {
  type = list(string)
}

variable "instance_count" {
}

variable "instance_type" {
}

variable "private_sgroup" {
}

variable "public_sgroup" {
}

variable "main_vpc" {
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "redis_subnet" {
}
