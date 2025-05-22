resource "aws_security_group" "Allow_port_22_and_80" {
  name        = "Allow_port_22_and_80"
  description = "Allow SSH and web traffic"
  vpc_id      = aws_vpc.webapp-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")
}
resource "aws_instance" "webapp-1" {
  ami                         = "ami-0e35ddab05955cf57"
  instance_type               = "t3a.small"
  subnet_id                   = aws_subnet.webapp-subnet_1.id
  vpc_security_group_ids      = [aws_security_group.Allow_port_22_and_80.id]
  associate_public_ip_address = true
  user_data                   = data.template_file.user_data.rendered
  tags = {
    Name = "webapp-1"
  }
}
resource "aws_instance" "webapp-2" {
  ami                         = "ami-0e35ddab05955cf57"
  instance_type               = "t3a.small"
  subnet_id                   = aws_subnet.webapp-subnet_2.id
  vpc_security_group_ids      = [aws_security_group.Allow_port_22_and_80.id]
  associate_public_ip_address = true
  user_data                   = data.template_file.user_data.rendered
  tags = {
    Name = "webapp-2"
  }
}
