provider "aws" {
  region = "us-east-1"
}

# --------------------------
# SSH Keypair for EC2
# --------------------------
resource "aws_key_pair" "akhil_keypair" {
  key_name   = "akhil-key"
  public_key = file("~/.ssh/new-akhil-key.pub")
}

# --------------------------
# Security Group
# --------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "free-tier-ec2-sg"
  description = "Allow SSH & HTTP"

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

# --------------------------
# Free-Tier EC2 Instance
# --------------------------
resource "aws_instance" "free_tier_ec2" {
  ami           = "ami-0c02fb55956c7d316"   # Amazon Linux 2 (us-east-1)
  instance_type = "t3.micro"
  key_name      = aws_key_pair.akhil_keypair.key_name
  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "free-ec2"
  }
}

