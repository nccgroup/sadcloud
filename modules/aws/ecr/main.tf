resource "aws_ecr_repository" "main" {
  count = (var.ecr_scanning_disabled || var.ecr_repo_public) ? 1 : 0

  name = var.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = !var.ecr_scanning_disabled
  }

}

resource "aws_ecr_repository_policy" "mainecrpolicy" {
  count = var.ecr_repo_public ? 1 : 0

  repository = aws_ecr_repository.main[0].name

  policy = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "AllowPull",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:DeleteRepository",
          "ecr:BatchDeleteImage",
          "ecr:SetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy"
        ]
      }
    ]
  }
EOF
}
