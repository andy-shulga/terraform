##################################
#
# Create an ec2 - for 
#
#
#
# owner Andy
####################################


resource "aws_instance" "my_ec2" {
  ami           = data.aws_ami.ami_name.image_id
  instance_type = "t2.micro"
  user_data     = file("user_data.txt")
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name = "Andy EC2"
  }
}

resource "aws_eip" "my_eip" {
  instance = aws_instance.my_ec2.id
  vpc      = true
}

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
}

