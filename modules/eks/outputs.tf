output "cluster_name" {
  value = aws_eks_cluster.poc.name
}

output "cluster_arn" {
  value = aws_eks_cluster.poc.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.poc.endpoint
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.eks.url
}


output "oidc_issuer_url" {
  value = aws_eks_cluster.poc.identity[0].oidc[0].issuer
}

output "oidc_issuer" {
  value = aws_eks_cluster.poc.identity[0].oidc[0].issuer
}