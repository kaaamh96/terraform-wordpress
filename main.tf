resource "aws_vpc" "customvpc" {

  cidr_block = var.vpc_cidr

  enable_dns_support = true

  enable_dns_hostnames = true

  tags = {
    Name = "custom-vpc"
  }
}

resource "aws_internet_gateway" "custom_igw" {

  vpc_id = aws_vpc.customvpc.id

  tags = {
    Name = "custom-igw"
  }
}

resource "aws_subnet" "public_subnet" {

  vpc_id = aws_vpc.customvpc.id

  cidr_block = var.public_subnet_cidr

  availability_zone = "eu-west-1a"

  map_public_ip_on_launch = true

}

resource "aws_subnet" "private_subnet" {

  vpc_id = aws_vpc.customvpc.id

  cidr_block = var.private_subnet_cidr

  availability_zone = "eu-west-1a"


}


resource "aws_eip" "nat_eip" {

  domain = "vpc"
}


resource "aws_nat_gateway" "custom_nat" {

  allocation_id = aws_eip.nat_eip.id

  subnet_id = aws_subnet.public_subnet.id

}





resource "aws_route_table" "public_route_table" {

  vpc_id = aws_vpc.customvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }



}

resource "aws_route_table" "private_route_table" {

  vpc_id = aws_vpc.customvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.custom_nat.id
  }

}

resource "aws_route_table_association" "public_subnet_association" {

  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_security_group" "wordpress_sg" {
  name = "wordpress_sg"

  vpc_id = aws_vpc.customvpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["92.239.117.84/32"]



  }

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

  egress {
    from_port = 0
    to_port   = 0

    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



## ec2 instance


resource "aws_instance" "wordpress_instance" {

  ami = "ami-01a47a61359451e7d"

  instance_type = var.instance_type

  key_name = var.key_name

  subnet_id = aws_subnet.public_subnet.id

  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]

  associate_public_ip_address = true

  user_data = file("userdatawordpress.sh")

  tags = {
    Name = "wordpress_instance"
  }


}


