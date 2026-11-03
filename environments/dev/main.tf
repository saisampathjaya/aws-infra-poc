module "vpc" {
  source = "../../modules/vpc"

  vpc_name     = var.vpc_name
  vpc_cidr     = var.vpc_cidr
  cluster_name = var.cluster_name

  igw_name = var.igw_name

  public_route_table_name  = var.public_route_table_name
  private_route_table_name = var.private_route_table_name

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "iam" {

  source = "../../modules/iam"

  cluster_name = var.cluster_name

  eks_cluster_role_name = var.eks_cluster_role_name

  eks_node_role_name = var.eks_node_role_name

  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_issuer_url   = module.eks.oidc_issuer_url
}

module "eks" {

  source = "../../modules/eks"

  cluster_name = var.cluster_name

  cluster_role_arn = module.iam.eks_cluster_role_arn

  node_role_arn = module.iam.eks_node_role_arn

  security_group_id = module.security_group.eks_sg_id

  private_subnet_ids = module.vpc.private_subnet_ids

  eks_version = var.eks_version

  node_groups = var.node_groups
}
module "s3" {

  source = "../../modules/s3"

  bucket_names = var.bucket_names

  environment = var.environment
}

module "security_group" {

  source = "../../modules/security-group"

  sg_name        = var.sg_name
  sg_description = var.sg_description

  vpc_id = module.vpc.vpc_id

  ssh_port   = var.ssh_port
  http_port  = var.http_port
  https_port = var.https_port

  ssh_cidrs   = var.ssh_cidrs
  http_cidrs  = var.http_cidrs
  https_cidrs = var.https_cidrs
}

module "ec2" {

  source = "../../modules/ec2"

  instance_name = var.instance_name

  ami_id = var.ami_id

  instance_type = var.instance_type

  subnet_id = module.vpc.public_subnet_ids[0]

  security_group_ids = [
    module.security_group.security_group_id
  ]

  associate_public_ip = var.associate_public_ip
}


module "eks_addons" {
  source = "../../modules/eks-addons"

  cluster_name = var.cluster_name

  coredns_version      = var.coredns_version
  kube_proxy_version   = var.kube_proxy_version
  vpc_cni_version      = var.vpc_cni_version
  ebs_csi_version      = var.ebs_csi_version
  pod_identity_version = var.pod_identity_version

  ebs_csi_role_arn = module.iam.ebs_csi_role_arn
}

module "alb_controller" {

  source = "../../modules/alb-controller"

  release_name = var.alb_release_name

  repository = var.alb_repository

  chart = var.alb_chart

  namespace = var.alb_namespace

  cluster_name = var.cluster_name

  region = var.region

  vpc_id = module.vpc.vpc_id

  service_account_create = var.alb_service_account_create

  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
}

#vpc_id = module.vpc.vpc_id

#service_account_create = var.alb_service_account_create
#}

module "karpenter" {

  source = "../../modules/karpenter"

  cluster_name = var.cluster_name

  queue_name = var.queue_name

  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_issuer       = module.eks.oidc_issuer
}

module "argocd" {

  source = "../../modules/argocd"

  namespace = var.argocd_namespace
}
module "ecr" {

  source = "../../modules/ecr"

  repository_name = var.repository_name

  image_tag_mutability = var.image_tag_mutability

  environment = var.environment
}

