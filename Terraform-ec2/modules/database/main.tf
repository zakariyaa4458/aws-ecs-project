resource "aws_db_instance" "mydb" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "myappdb"
  username               = "admin"
  password               = random_password.db_password.result
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
}

resource "aws_db_subnet_group" "main" {
  name       = "my-app-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "my-app-db-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "RDS security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Traffic from ECS tasks only"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id] # Reference SG
  }

}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# ECS Security Group - ONLY accepts traffic from ALB
resource "aws_security_group" "ecs" {
  name        = "ecs-tasks-sg"
  description = "ECS tasks security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Traffic from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id] # Reference SG
  }

}


# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/22" # 1,024 IPs - right-sized
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "my-app-vpc"
    Environment = "production"
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

data "aws_availability_zones" "available" {
  state = "available"
}



# ALB Security Group - accepts traffic from internet
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "ALB security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "alb-sg" }
}