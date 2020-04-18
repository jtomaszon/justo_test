#---------storage/main.tf---------

# Creates a RDS
resource "aws_db_instance" "tf_rds_main" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = var.db_name
  username             = "foo"
  password             = "foobarbaz"
  skip_final_snapshot = true
  db_subnet_group_name   = aws_db_subnet_group.tf_subnet.id
}

resource "aws_db_subnet_group" "tf_subnet" {
  name        = "tf_subnet_group"
  description = "Used for deploy the private RDS" 
  subnet_ids  = var.subnets
}
