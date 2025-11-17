###########################################################
# PROVIDER
###########################################################

provider "aws" {
  region = "us-east-1"   # Change if your region is different
}

###########################################################
# SECURITY GROUP (SSH Only)
###########################################################

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-free-tier-sg"
  description = "Allow SSH"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open SSH to everyone (ok for testing)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

###########################################################
# KEY PAIR (Uses your local public key)
###########################################################

resource "aws_key_pair" "mykey" {
  key_name   = "akhil-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

###########################################################
# EC2 INSTANCE (Free Tier)
###########################################################

resource "aws_instance" "free_tier_ec2" {
  ami           = "ami-0c7217cdde317cfec"  # Amazon Linux 2 (us-east-1)
  instance_type = "t2.micro"               # FREE TIER instance

  key_name               = aws_key_pair.mykey.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "akhil-free-tier-ec2"
  }
}

