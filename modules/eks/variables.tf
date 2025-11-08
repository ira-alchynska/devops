variable "cluster_name" {
  type = string
}

variable "node_group_name" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

# Multiple instance types for fallback capacity
variable "instance_types" {
  type    = list(string)
  default = ["t3.micro", "t3a.micro", "t2.micro"]
}

# Optional single instance type if you need one
variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "cluster_version" {
  type    = string
  default = ""
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 3
}
