#----networking/variables.tf----
variable "vpc_cidr" {
}

variable "public_cidrs" {
  type = list(string)
}

variable "vpc_private_cidr" {
}

variable "private_cidrs" {
  type = list(string)
}

variable "accessip" {
}
