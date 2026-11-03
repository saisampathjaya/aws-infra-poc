variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "igw_name" {
  type = string
}

variable "public_route_table_name" {
  type = string
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_route_table_name" {
  type = string
}

variable "cluster_name" {
  type = string
}