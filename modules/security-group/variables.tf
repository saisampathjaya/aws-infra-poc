variable "sg_name" {
  type = string
}

variable "sg_description" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ssh_port" {
  type = number
}

variable "http_port" {
  type = number
}

variable "https_port" {
  type = number
}

variable "ssh_cidrs" {
  type = list(string)
}

variable "http_cidrs" {
  type = list(string)
}

variable "https_cidrs" {
  type = list(string)
}