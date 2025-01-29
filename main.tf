provider "aws" {
  region = var.region
}

resource "aws_vpc" "jenkins_vpc" {
  cidr_block = var.jenkins_vpc_cidr
  tags = {
    Name = var.tags["jenkins_vpc"]
  }
}

resource "aws_subnet" "jenkins_subnet" {
  vpc_id                  = aws_vpc.jenkins_vpc.id
  cidr_block              = var.jenkins_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.jenkins_subnet_az
  tags = {
    Name = var.tags["jenkins_subnet"]
  }
}

resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = aws_vpc.jenkins_vpc.id
  tags = {
    Name = var.tags["jenkins_igw"]
  }
}

resource "aws_route_table" "jenkins_route_table" {
  vpc_id = aws_vpc.jenkins_vpc.id
  route {
    cidr_block = var.jenkins_route_table_cidr
    gateway_id = aws_internet_gateway.jenkins_igw.id
  }
  tags = {
    Name = var.tags["jenkins_route_table"]
  }
}

resource "aws_route_table_association" "jenkins_rta" {
  subnet_id      = aws_subnet.jenkins_subnet.id
  route_table_id = aws_route_table.jenkins_route_table.id
}


resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow HTTP/S"
  vpc_id      = aws_vpc.jenkins_vpc.id


  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.tags["jenkins_sg"]
  }
}

data "aws_ami" "jenkins_ami" {
  most_recent = true
  filter {
    name   = var.jenkins_ami_filter_parameter
    values = ["jenkins-*"] # match the name from packer
  }
  owners = ["self"]
}

resource "aws_instance" "jenkins_ec2" {
  ami                    = data.aws_ami.jenkins_ami.id
  instance_type          = var.jenkins_ec2_instance_type
  subnet_id              = aws_subnet.jenkins_subnet.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = var.tags["jenkins_ec2"]
  }
}

resource "aws_eip_association" "jenkins_eip" {
  instance_id   = aws_instance.jenkins_ec2.id
  allocation_id = var.jenkins_eip
}


