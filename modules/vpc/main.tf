resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.subnet_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true   # ✅ THIS IS THE FIX

  tags = {
    Name = var.subnet_name
  }
}
resource "aws_subnet" "this_2" {
  vpc_id            = aws_vpc.this.id
  cidr_block = var.subnet_cidr_2
  availability_zone = "us-east-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.subnet_name}-2"
  }
}

# ✅ Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.igw_name
  }
}

# ✅ Route Table
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.route_table_name
  }
}


# ✅ Default Route to Internet
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# ✅ Associate Subnet with Route Table
resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}
resource "aws_route_table_association" "this_2" {
  subnet_id      = aws_subnet.this_2.id
  route_table_id = aws_route_table.this.id
}

