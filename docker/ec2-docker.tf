# Please change the key_name and your config file 
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region  = "us-east-1"
}

locals {
  instance-type = "t2.micro"
  key-name = "end-key-pair"
  secgr-dynamic-ports = [22,80,443,1433]
  user = "yakin"
}

resource "aws_security_group" "allow_ssh" {
  name        = "${local.user}-docker-instance-sg"
  description = "Allow SSH inbound traffic"

  dynamic "ingress" {
    for_each = local.secgr-dynamic-ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "al2023" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "name"
    values = ["*ubuntu-jammy-22.04-amd64-server*"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "tf-ec2" {
  ami           = data.aws_ami.al2023.id
  instance_type = local.instance-type
  key_name = local.key-name
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  tags = {
      Name = "${local.user}-Docker-instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname docker_instance
              apt-get update -y
              apt-get install docker -y
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ubuntu
              # install docker-compose
              curl -SL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              apt-get install git -y
              cd /home/ubuntu && git clone https://github.com/yakin68/task.git
							cd /home/ubuntu/tasg && docker-compose up
	          EOF
}  
output "myec2-public-ip" {
  value = aws_instance.tf-ec2.public_ip
}

output "ssh-connection-command" {
  value = "ssh -i ${local.key-name}.pem ubuntu@${aws_instance.tf-ec2.public_ip}"
}
