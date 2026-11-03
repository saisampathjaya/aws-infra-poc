resource "aws_security_group" "this" {

  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"

    from_port = var.ssh_port
    to_port   = var.ssh_port

    protocol = "tcp"

    cidr_blocks = var.ssh_cidrs
  }

  ingress {
    description = "HTTP"

    from_port = var.http_port
    to_port   = var.http_port

    protocol = "tcp"

    cidr_blocks = var.http_cidrs
  }

  ingress {
    description = "HTTPS"

    from_port = var.https_port
    to_port   = var.https_port

    protocol = "tcp"

    cidr_blocks = var.https_cidrs
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }
}


resource "aws_security_group" "eks_sg" {
  name        = "eks-node-sg"
  description = "EKS worker node security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS"

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description = "Node communication"

    from_port = 0
    to_port   = 65535
    protocol  = "tcp"

    self = true
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "eks-node-sg"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}