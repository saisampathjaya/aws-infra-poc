output "security_group_id" {
  value = aws_security_group.this.id
}

output "eks_sg_id" {
  value = aws_security_group.eks_sg.id
}