provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "ngrinder-vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "ngrinder-vpc"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.ngrinder-vpc.id
  cidr_block              = "192.168.0.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_internet_gateway" "ngrinder_vpc_igw" {
  vpc_id = aws_vpc.ngrinder-vpc.id
  tags = {
    Name = "ngrinder-vpc-igw"
  }
}

resource "aws_route_table" "ngrinder_vpc" {
  vpc_id = aws_vpc.ngrinder-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ngrinder_vpc_igw.id
  }

  tags = {
    Name = "ngrinder-vpc-rt"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.ngrinder_vpc.id
}

resource "aws_security_group" "ngrinder_vpc_sg" {
  vpc_id = aws_vpc.ngrinder-vpc.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ICMP"
  }

  ingress {
    from_port   = 12000
    to_port     = 12050
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Ngrinder Controller"
  }

  ingress {
    from_port   = 16001
    to_port     = 16001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Ngrinder Agent"
  }

  ingress {
    from_port   = 13243
    to_port     = 13243
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Ngrinder Monitor"
  }

  # Controller HTTP(S) access for Public Users
  ingress {
    description      = "HTTP for nGrinder Controller"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # VPC 내부 모든 트래픽 허용
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["192.168.0.0/16"]
    description = "Allow all internal VPC traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ngrinder-vpc-sg"
  }
}

output "vpc_id" {
  value = aws_vpc.ngrinder-vpc.id
}

output "public_subnet_a_id" {
  value = aws_subnet.public_subnet_a.id
}


############################################
# EC2 Instances
############################################

variable "key_name" {
  default = "ec2-key"
}
variable "ami_id_master" {
  default = "ami-0dc44556af6f78a7b"
}
variable "ami_id_agent" {
  default = "ami-0dc44556af6f78a7b"
}

# Master Instance (t3.medium)
resource "aws_instance" "ngrinder_master" {
  ami           = var.ami_id_master
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.public_subnet_a.id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.ngrinder_vpc_sg.id]
  
  tags = {
    Name = "nGrinder-Master"
  }
}

# Agent Instances (c5.large) - 2개
resource "aws_instance" "ngrinder_agents" {
  count         = 2
  ami           = var.ami_id_agent
  instance_type = "c5.large"
  subnet_id     = aws_subnet.public_subnet_a.id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.ngrinder_vpc_sg.id]

  tags = {
    Name = "nGrinder-Agent-${count.index}"
  }
}

############################################
# Outputs
############################################
output "ngrinder_master_public_ip" {
  value = aws_instance.ngrinder_master.public_ip
}

output "ngrinder_agents_public_ips" {
  value = [for agent in aws_instance.ngrinder_agents : agent.public_ip]
}
