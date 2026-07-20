variable "db_subnet_group_name" {
  type = string
}

variable "rds_security_group_id" {
  type = string
}



variable "db_name" {
  type = string
  default = "myappdb"
}

variable "db_username" {
  type = string
  default = "admin"
}

variable "private_subnet_ids" {
  type = list(string)
}