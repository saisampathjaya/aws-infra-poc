output "queue_name" {
  value = aws_sqs_queue.karpenter.name
}

output "queue_arn" {
  value = aws_sqs_queue.karpenter.arn
}

