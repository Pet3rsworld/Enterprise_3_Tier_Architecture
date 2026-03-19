# 1. Create the VPC
resource "aws_vpc" "vpc_creation" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# 2. Create Public Subnets
resource "aws_subnet" "our_public_subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc_creation.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

# 3. Create Private Subnets
resource "aws_subnet" "our_private_subnets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.vpc_creation.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-private-subnets-${count.index + 1}"
  }
}

# 4. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_creation.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# 5. Public Route Table
resource "aws_route_table" "pu_rt" {
  vpc_id = aws_vpc.vpc_creation.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-pu-rt"
  }
}

# 6. Associate Pu Route Table to Public Subnet
resource "aws_route_table_association" "public_associate" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.our_public_subnets[count.index].id
  route_table_id = aws_route_table.pu_rt.id
}

# 7. Elastic IP
resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-eip"
  }
}

# 8. NAT Gateway
resource "aws_nat_gateway" "nat_g" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.our_public_subnets[0].id

  tags = {
    Name = "${var.project_name}-nat-g"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# 9. Private Route Table
resource "aws_route_table" "pr_rt" {
  vpc_id = aws_vpc.vpc_creation.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_g.id
  }

  tags = {
    Name = "${var.project_name}-pr-t"
  }
}

# 10. Associate Pr Route Table to Private Subnet
resource "aws_route_table_association" "private_associate" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.our_private_subnets[count.index].id
  route_table_id = aws_route_table.pr_rt.id
}
