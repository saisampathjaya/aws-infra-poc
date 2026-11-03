output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "ebs_csi_role_arn" {
  value = aws_iam_role.ebs_csi_role.arn
}

output "jenkins_irsa_role_arn" {
  value = aws_iam_role.jenkins_irsa.arn
}