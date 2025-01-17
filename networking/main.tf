#----networking/main.tf----

data "aws_availability_zones" "available" {
}

resource "aws_vpc" "tf_private_vpc" {
  cidr_block           = var.vpc_private_cidr
  enable_dns_hostnames = false
  enable_dns_support   = false

  tags = {
    Name = "tf_private_vpc"
  }
}

resource "aws_vpc" "tf_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tf_vpc"
  }
}

resource "aws_internet_gateway" "tf_internet_gateway" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf_igw"
  }
}

resource "aws_route_table" "tf_public_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_internet_gateway.id
  }

  tags = {
    Name = "tf_public"
  }
}

resource "aws_subnet" "tf_private_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.tf_private_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "tf_private_${count.index + 1}"
  }
}

resource "aws_subnet" "tf_public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "tf_public_${count.index + 1}"
  }
}

resource "aws_elasticache_subnet_group" "tf_redis_subnet" {
  name       = "tf-redis-subnet"
  subnet_ids = aws_subnet.tf_public_subnet.*.id
}

resource "aws_route_table_association" "tf_public_assoc" {
  count          = length(aws_subnet.tf_public_subnet)
  subnet_id      = aws_subnet.tf_public_subnet[count.index].id
  route_table_id = aws_route_table.tf_public_rt.id
}

resource "aws_security_group" "tf_private_sg" {
  name        = "tf_sg"
  description = "Used for access to the private instances"
  vpc_id      = aws_vpc.tf_private_vpc.id

  #SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.accessip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "tf_public_sg" {
  name        = "tf_public_sg"
  description = "Used for access to the public instances"
  vpc_id      = aws_vpc.tf_vpc.id

  #SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.accessip]
  }

  #HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.accessip]
  }
  
  #Redis
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.accessip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
