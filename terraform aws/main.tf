
provider "aws" {
  region     = "us-west-2"
  access_key = "claves del usuario"
  secret_key = "claves del usuario"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "example-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.example.id
  availability_zone = "us-west-2a"
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.example.id
  availability_zone = "us-west-2b"
  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "example-igw"
  }
}

resource "aws_security_group" "ec2" {
  name        = "ec2-sg"
  description = "Grupo de seguridad para las ec2"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_1" {
  ami                    = "ami-023e152801ee4846a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2.id]
  subnet_id              = aws_subnet.public_subnet_1.id
  tags = {
    Name = "EC2-1"
  }
}

resource "aws_instance" "ec2_2" {
  ami                    = "ami-023e152801ee4846a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2.id]
  subnet_id              = aws_subnet.public_subnet_2.id
  tags = {
    Name = "EC2-2"
  }
}

resource "aws_route" "public_subnet_1_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.example.id
}

resource "aws_route" "public_subnet_2_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.example.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_1_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_1.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_2.id
}

#terraform init iniciar
#terraform apply aplicar
#terraform apply -destroy destruir