resource "aws_eks_cluster" "poc" {

  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.eks_version

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true

    security_group_ids = [
      var.security_group_id
    ]
  }

  tags = {
    Name = var.cluster_name
  }
}

resource "aws_eks_node_group" "poc" {

  for_each = var.node_groups

  cluster_name = aws_eks_cluster.poc.name

  #version = var.eks_version

  launch_template {
  id      = aws_launch_template.eks_nodes.id
  version = "$Latest"
}

  node_group_name = each.key

  node_role_arn = var.node_role_arn

  subnet_ids = var.private_subnet_ids

  scaling_config {
    desired_size = each.value.desired_size
    min_size     = each.value.min_size
    max_size     = each.value.max_size
  }

  instance_types = each.value.instance_types

  tags = {
    Name = each.key
  }
}