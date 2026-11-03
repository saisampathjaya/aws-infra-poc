variable "cluster_name" {
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

variable "ebs_csi_version" {
  type = string
}

variable "pod_identity_version" {
  type = string
}

variable "ebs_csi_role_arn" {
  type = string
}