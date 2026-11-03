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

variable "node_groups" {
  type = map(object({
    desired_size   = number
    min_size       = number
    max_size       = number
    instance_types = list(string)
  }))
}

variable "eks_cluster_role_name" {
  type = string
}

variable "eks_node_role_name" {
  type = string
}

variable "bucket_names" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "sg_name" {
  type = string
}

variable "sg_description" {
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

variable "instance_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "associate_public_ip" {
  type = bool
}

variable "alb_release_name" {
  type = string
}

variable "alb_repository" {
  type = string
}

variable "alb_chart" {
  type = string
}

variable "alb_namespace" {
  type = string
}

variable "alb_service_account_create" {
  type = string
}

variable "region" {
  type = string
}

variable "queue_name" {
  type = string
}

variable "argocd_namespace" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "image_tag_mutability" {
  type = string
}

variable "eks_version" {
  type = string
}

variable "coredns_version" {
  type = string
}

variable "kube_proxy_version" {
  type = string
}

variable "vpc_cni_version" {
  type = string
}

variable "pod_identity_version" {
  type = string
}

variable "ebs_csi_version" {
  type = string
}
