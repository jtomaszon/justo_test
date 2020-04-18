aws_region   = "us-west-1"
vpc_cidr     = "10.123.0.0/16"
public_cidrs = [
  "10.123.1.0/24",
  "10.123.2.0/24"
]
vpc_private_cidr = "10.124.0.0/16"
private_cidrs    = [
  "10.124.1.0/24",
  "10.124.2.0/24"
]
accessip    = "0.0.0.0/0"
key_name = "tf_key"
public_key_path = ".\\compute\\key_ec2s.pub"
server_instance_type = "t2.micro"
db_name = "mydb"
instance_count = 2