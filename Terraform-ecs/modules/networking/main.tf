locals {
  certificate_domains = toset([
    var.domain_name
  ])
}



resource "aws_acm_certificate_validation" "cert_validation" {


  certificate_arn         = aws_acm_certificate.cert.arn
 

}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/22" # 1,024 IPs - right-sized
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "my-app-vpc"
    Environment = "production" 
  }
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 3, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "public-${count.index + 1}"
    Type = "public"
  }
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 3, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-${count.index + 1}"
    Type = "private"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Only create NAT Gateway for production
resource "aws_eip" "nat" {
  count  = var.environment == "production" ? 1 : 0
  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  count         = var.environment == "production" ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[0].id

  }

}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_db_subnet_group" "main" {
  name       = "my-app-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "my-app-db-subnet-group"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}



