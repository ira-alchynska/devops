variable "name" {
  description = "Назва інстансу або кластера"
  type        = string
}

variable "engine" {
  type        = string
  default     = "postgres"
  description = "Database engine. For RDS: 'postgres', 'mysql', etc. For Aurora: 'aurora-postgresql', 'aurora-mysql', etc."
}
variable "aurora_replica_count" {
  type    = number
  default = 0  # Default to 0 (only writer), task requires "Aurora Cluster + writer"
}

variable "aurora_instance_count" {
  type    = number
  default = 2 # 1 primary + 1 replica
}
variable "engine_version" {
  type        = string
  default     = "14.7"
  description = "Database engine version. Used for both RDS and Aurora."
}

variable "instance_class" {
  type    = string
  default = "db.t3.medium"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}

variable "vpc_id" {
  type = string
}

variable "subnet_private_ids" {
  type = list(string)
}

variable "subnet_public_ids" {
  type = list(string)
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "parameters" {
  type    = map(string)
  default = {
    max_connections            = "200"
    log_statement              = "all"
    work_mem                   = "4194304"  # 4MB in bytes
  }
  description = "Database parameters. Default includes max_connections, log_statement, and work_mem as per task requirements"
}

variable "use_aurora" {
  type    = bool
  default = false
}

variable "backup_retention_period" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "parameter_group_family_aurora" {
  type    = string
  default = "aurora-postgresql15"
}
variable "parameter_group_family_rds" {
  type    = string
  default = "postgres15"
}

variable "vpc_cidr_block" {
  description = "CIDR блок для VPC"
  type        = string
}

variable "db_port" {
  description = "Database port. Default: 5432 for PostgreSQL, 3306 for MySQL"
  type        = number
  default     = 5432
}