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
  vpc_security_group_ids = [var.rds_security_group_id]
  db_subnet_group_name   = var.db_subnet_group_name
}





resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}




resource "aws_ssm_parameter" "db_password" {
  name  = "/my-app/db_password"
  type  = "SecureString"
  value = random_password.db_password.result

}

