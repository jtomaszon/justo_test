#-----compute/main.tf#-----

resource "aws_elasticache_cluster" "tf_redis" {
  cluster_id           = "tf-redis"
  engine               = "redis"
  node_type            = "cache.r5.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
  subnet_group_name    = var.redis_subnet
  security_group_ids   = [var.public_sgroup]
}

data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "tf_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

data "template_file" "user-init" {
  count    = 2
  template = file("${path.module}/userdata.tpl")

  vars = {
    firewall_subnets = element(var.subnet_ips, count.index)
	redis_address = aws_elasticache_cluster.tf_redis.cache_nodes.0.address
  }
}

resource "aws_instance" "tf_server" {
  count                       = var.instance_count
  instance_type               = var.instance_type
  associate_public_ip_address = true
  ami                         = data.aws_ami.server_ami.id

  tags = {
    Name = "tf_server-${count.index + 1}"
  }

  key_name               = aws_key_pair.tf_auth.id
  vpc_security_group_ids = [var.public_sgroup]
  subnet_id              = element(var.public_subnets, count.index)
  user_data              = data.template_file.user-init[count.index].rendered
}

resource "aws_instance" "tf_private_server" {
  count                       = var.instance_count
  instance_type               = var.instance_type
  associate_public_ip_address = false
  ami                         = data.aws_ami.server_ami.id

  tags = {
    Name = "tf_priv_server-${count.index + 1}"
  }

  key_name               = aws_key_pair.tf_auth.id
  vpc_security_group_ids = [var.private_sgroup]
  subnet_id              = element(var.private_subnets, count.index)
}

resource "aws_lb_target_group" "tf_target_group" {
  name     = "tf-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.main_vpc
}

resource "aws_lb" "tf_load_balancer" {
  name               = "main-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sgroup]
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group_attachment" "tf_target_registers" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.tf_target_group.arn
  target_id        = aws_instance.tf_server[count.index].id
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.tf_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf_target_group.arn
  }
}

resource "aws_cloudwatch_metric_alarm" "alarms" {
  count                     = var.instance_count
  alarm_name                = "tf-cpu-${count.index + 1}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
	InstanceId = aws_instance.tf_server[count.index].id
  }
}

  
