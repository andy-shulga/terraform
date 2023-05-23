####################################
#
# Just demo of some knowledges in Terraform
#
# Create an simple ec2 with using a user data to apload index.html 
#
# Owner Andy Shulga
####################################

# Creare an Launch Configurations
resource "aws_launch_configuration" "web" {
  name            = "WebServer-Highly-Available"
  image_id        = data.aws_ami.ami_name.image_id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.my_webserver.id]
  user_data       = file("user_data.txt")

  lifecycle {
    create_before_destroy = true
  }
}

# Create Auto Scaling Group and attache it to Launch Conf. and multy VPC Zones
resource "aws_autoscaling_group" "web" {
  name                 = "WebServer-Highly-Available-ASG"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.web.name]
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]

  dynamic "tag" {
    for_each = {
      Name  = "WebServer in ASG"
      Owner = "Andy Shulga"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create Elastic Load Balancer
resource "aws_elb" "web" {
  name               = "WebServerAndyCV-HA-ELB"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.my_webserver.id]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = {
    Name = "WebServer-HA-ELB"
  }
}

# Creat an EC2 without any automations. With auto assigning AMI
resource "aws_instance" "my_ec2" {
  count                  = 2
  ami                    = data.aws_ami.ami_name.image_id
  instance_type          = "t2.micro"
  user_data              = file("user_data.txt")
  vpc_security_group_ids = [aws_security_group.my_webserver.id]



  tags = {
    Name    = "Web Server Build by Terraform ${count.index}"
    Owner   = "Andy Shulga"
    Content = "Andy CV from S3 Static"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Create Elastic IP address 
resource "aws_eip" "my_eip" {
  count = 2
  vpc   = true
}

resource "aws_eip_association" "eip_to_ec2" {
  count         = 2
  instance_id   = aws_instance.my_ec2[count.index].id
  allocation_id = aws_eip.my_eip[count.index].id
}


#Create a Security Groupe with ports by Dynamic block
resource "aws_security_group" "my_webserver" {
  name = "Dynamic Security Group"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Dynamic SecurityGroup"
    Owner = "Andy Shulga"
  }
}

# Create a resource to get my Availabilyty Zones
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

#--------------------------------------------------------------------------
# S3 section

resource "aws_instance" "web_s3" {
  ami                  = "ami-06a0cd9728546d178"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  user_data            = file("user_data_s3.txt")

  tags = {
    Name = "Web using S3"
  }
}


resource "aws_iam_instance_profile" "test_profile" {
  name = "example-profile" # Replace with your desired profile name

  role = aws_iam_role.s3_ec2_role.name
}