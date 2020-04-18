#----root/outputs.tf-----

#---Networking Outputs -----

output "Private_Subnets" {
  value = join(", ", module.networking.private_subnets)
}

output "Subnet_IPs" {
  value = join(", ", module.networking.subnet_ips)
}

output "Private_Security_Group" {
  value = module.networking.private_sg
}

#---Compute Outputs ------

output "Private_Instance_IDs" {
  value = module.compute.server_id
}

output "Private_Instance_IPs" {
  value = module.compute.server_ip
}

