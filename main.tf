provider "aws" {
  region = "us-east-1"
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Security Group
resource "aws_security_group" "mk1_sg" {
  name        = "mk1-security-group"
  description = "Allow SSH, HTTP, Jenkins"

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

  ingress {
    from_port   = 8080
    to_port     = 8080
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

# EC2 Instance
resource "aws_instance" "mk1_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = "mk1-key"
  vpc_security_group_ids = [aws_security_group.mk1_sg.id]

  user_data = <<-EOF
#!/bin/bash
yum update -y

# Install Java 17
yum install java-17-amazon-corretto -y
alternatives --set java /usr/lib/jvm/java-17-amazon-corretto/bin/java

# Install Git
yum install git -y

# Install Docker
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Install Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins -y

systemctl enable jenkins
systemctl start jenkins

# Give Jenkins Docker access
usermod -aG docker jenkins

# Restart services to apply group permissions
systemctl restart docker
systemctl restart jenkins
EOF

  tags = {
    Name = "mk1-devops-instance"
  }
}

output "public_ip" {
  value = aws_instance.mk1_instance.public_ip
}
