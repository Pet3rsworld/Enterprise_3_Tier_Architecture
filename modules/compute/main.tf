# 1. Application Load Balancer
resource "aws_lb" "my_alb" {
  name               = "enterprise-my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    name = "${var.project_name}-my-alb"
  }
}

# 2. Target Group for ALB
resource "aws_lb_target_group" "alb_tg" {
  name     = "enterprise-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

# 3. ALB Listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

# 4. Fetch the latest Amazon Linux 2 AMI dynamically
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# 5. Launch Template for the EC2 Instances
resource "aws_launch_template" "ec2_lt" {
  name_prefix            = "${var.project_name}-ec2-lt"
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [var.ec2_sg_id]

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install nginx1 -y
systemctl enable nginx
systemctl start nginx
echo "<h1>Welcome to the 3-Tier Enterprise Architecture</h1><p>Connected to Database Endpoint: $${var.db_endpoint}</p>" > /usr/share/nginx/html/index.html
EOF
  )


  tag_specifications {
    resource_type = "instance"
    tags = {
      name = "${var.project_name}-ec2-lt"
    }
  }
}

# 6. Auto Scaling Group that automaticallly provisions ec2 instances
resource "aws_autoscaling_group" "ec2_asg" {
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.alb_tg.arn]
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2

  launch_template {
    id      = aws_launch_template.ec2_lt.id
    version = "$Latest"
  }
}
