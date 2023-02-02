resource "aws_vpc" "my_vpc" {
  cidr_block       = var.my_vpc
  instance_tenancy = "default"

  tags = {
    Name = "myvpc"
  }
}
resource "aws_subnet" "subnet_cidr" {
  vpc_id     = aws_vpc.my_vpc.id 
  count = length(var.my_sub)
  cidr_block = var.my_sub[count.index]
  availability_zone = "us-west-2a"
  tags = {
    Name = "subnets"
  }
  depends_on = [
    aws_vpc.my_vpc
  ]
}
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id 

  tags = {
    Name = "main"
  }
  depends_on = [
    aws_subnet.subnet_cidr
  ]
}
resource "aws_route_table" "my_routetable" {
  vpc_id = aws_vpc.my_vpc.id 
  count = length(var.my_route_tables)
  
  tags = {
    Name = var.my_tags[count.index]
  }
}
resource "aws_route_table_association" "my_route_subnet" {
  subnet_id      = aws_subnet.subnet_cidr[0].id 
  route_table_id = aws_route_table.my_routetable[0].id
  # gateway_id = aws_internet_gateway.my_igw.id 
}
resource "aws_route" "route" {
  route_table_id = aws_route_table.my_routetable[0].id
  destination_cidr_block    = var.destinationcidr
  gateway_id = aws_internet_gateway.my_igw.id 
}
resource "aws_security_group" "my_security" {
  name        = "my_security_group"
  description = "AlloW SSH"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "allow ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_security_group"
  }
}

resource "aws_security_group" "my_new_security" {
  name        = "my_security_group1"
  description = "Allow http"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_security_group"
  }
}

resource "aws_security_group" "my_new_security2" {
  name        = "my_security_group2"
  description = "Allow https"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_security_group"
  }
}
resource "aws_instance" "my_instane" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = true 
  availability_zone           = "us-west-2a"
  key_name                    = "key"
  subnet_id                   = aws_subnet.subnet_cidr[0].id
  security_groups             = [ aws_security_group.my_security.id ]
  tags = {
    "Name" = "instance_tags"
  }
}
resource "null_resource" "integration_ansible" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    "Name" = "3.0"
  
  }
  provisioner "remote-exec" {
    connection {
    type     = "ssh"
    user     = "devops"
    password = 1
    host     = var.hostname
  }
     inline = [
      "ansible -i hosts -m ping all",
      "ansible-playbook -i hosts playbook.yaml" 
    ]
  }
}






