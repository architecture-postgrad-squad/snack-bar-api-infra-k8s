resource "aws_vpc" "snack_bar_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "snack-bar-vpc"
  }
}

resource "aws_subnet" "snack_bar_subnet_1" {
  vpc_id            = aws_vpc.snack_bar_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "snack-bar-subnet-1"
  }
}

resource "aws_subnet" "snack_bar_subnet_2" {
  vpc_id            = aws_vpc.snack_bar_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "snack-bar-subnet-2"
  }
}

resource "aws_internet_gateway" "snack_bar_igw" {
  vpc_id = aws_vpc.snack_bar_vpc.id

  tags = {
    Name = "snack-bar-igw"
  }
}

resource "aws_route_table" "snack_bar_route_table" {
  vpc_id = aws_vpc.snack_bar_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.snack_bar_igw.id
  }

  tags = {
    Name = "snack-bar-route-table"
  }
}

resource "aws_route_table_association" "snack_bar_rta_1" {
  subnet_id      = aws_subnet.snack_bar_subnet_1.id
  route_table_id = aws_route_table.snack_bar_route_table.id
}

resource "aws_route_table_association" "snack_bar_rta_2" {
  subnet_id      = aws_subnet.snack_bar_subnet_2.id
  route_table_id = aws_route_table.snack_bar_route_table.id
}

# EKS cluster setup
resource "aws_eks_cluster" "snack_bar_eks" {
  name     = "snack-bar-cluster"
  role_arn = "arn:aws:iam::245351862810:role/LabRole"

  vpc_config {
    subnet_ids = [aws_subnet.snack_bar_subnet_1.id, aws_subnet.snack_bar_subnet_2.id]
  }
}

# EKS worker node group using LabRole
resource "aws_eks_node_group" "snack_bar_worker_group" {
  cluster_name    = aws_eks_cluster.snack_bar_eks.name
  node_group_name = "snack-bar-worker-group"
  node_role_arn   = "arn:aws:iam::245351862810:role/LabRole"
  subnet_ids      = [aws_subnet.snack_bar_subnet_1.id, aws_subnet.snack_bar_subnet_2.id]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  depends_on = [
    aws_eks_cluster.snack_bar_eks
  ]
}
