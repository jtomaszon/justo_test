#----storage/variables.tf----
variable "db_name" {
}

variable "subnets" {
  type = list(string)
}
