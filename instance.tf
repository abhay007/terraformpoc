#Security Group
resource "aws_security_group" "Paymentology-http-sg" {
  name        = "allow_http_access"
  description = "allow inbound http traffic"
  vpc_id      = aws_vpc.Paymentology.id

  ingress {
    description = "from my ip range"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    to_port     = "0"
  }
  tags = {
    "Name" = "Paymentology-sg"
  }
}
data "aws_ami" "amazon_ami" {
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20220606.1-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
  owners      = ["amazon"]
}
#AWS Ec2 Instance
resource "aws_instance" "Paymentology-Web-Server" {
  count                  = length(var.subnet_cidr_private)
  instance_type          = "t3a.micro"
  ami                    = data.aws_ami.amazon_ami.id
  vpc_security_group_ids = [aws_security_group.Paymentology-http-sg.id]
  subnet_id              = element(aws_subnet.private.*.id, count.index)
  
  associate_public_ip_address = true
  tags = {
    Name = "Paymentology-Ec2-instance"
  }
  user_data = file("user_data.sh")
}