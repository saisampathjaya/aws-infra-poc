data "aws_region" "current" {}

resource "aws_sqs_queue" "karpenter" {

  name = var.queue_name

  tags = {
    Name = var.queue_name
  }
}


resource "aws_iam_role" "karpenter" {

  name = "${var.cluster_name}-karpenter-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "karpenter_ssm" {

  role = aws_iam_role.karpenter.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "kubernetes_namespace" "karpenter" {
  metadata {
    name = "karpenter"
  }
}

resource "helm_release" "karpenter_crd" {
  name       = "karpenter-crd"
  namespace  = "karpenter"

  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter-crd"

  depends_on = [
    kubernetes_namespace.karpenter
  ]
}


resource "helm_release" "karpenter" {

  name       = "karpenter"
  namespace  = "karpenter"

  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"

  set {
    name  = "settings.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "settings.interruptionQueue"
    value = aws_sqs_queue.karpenter.name
  }

  set {
    name  = "controller.env[0].name"
    value = "AWS_REGION"
  }

  set {
    name  = "controller.env[0].value"
    value = data.aws_region.current.name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter_controller.arn
  }

  depends_on = [
    helm_release.karpenter_crd,
    aws_iam_role_policy_attachment.karpenter_controller
  ]
}

data "aws_iam_policy_document" "karpenter_assume_role" {

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        var.oidc_provider_arn
      ]
    }

    condition {
      test = "StringEquals"

      variable = "${replace(var.oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:karpenter:karpenter"
      ]
    }
  }
}

resource "aws_iam_role" "karpenter_controller" {

  name = "${var.cluster_name}-karpenter-controller-role"

  assume_role_policy = data.aws_iam_policy_document.karpenter_assume_role.json
}


resource "aws_iam_policy" "karpenter_controller" {

  name = "${var.cluster_name}-karpenter-controller-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "ec2:Describe*",
          "ec2:GetInstanceTypesFromInstanceRequirements",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:CreateTags",
          "ec2:DeleteTags"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "ssm:GetParameter"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "pricing:GetProducts"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "eks:DescribeCluster"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "iam:PassRole"
        ]

        Resource = aws_iam_role.karpenter.arn
      },

      {
        Effect = "Allow"

        Action = [
          "sqs:GetQueueUrl",
          "sqs:GetQueueAttributes",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage"
        ]

        Resource = aws_sqs_queue.karpenter.arn
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "karpenter_controller" {

  role       = aws_iam_role.karpenter_controller.name

  policy_arn = aws_iam_policy.karpenter_controller.arn
}

resource "aws_eks_access_entry" "karpenter_nodes" {
  cluster_name  = var.cluster_name
  principal_arn = aws_iam_role.karpenter.arn

  type = "EC2_LINUX"
}
