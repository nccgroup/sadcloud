resource "aws_eks_cluster" "example" {
  name     = "example"
  role_arn = aws_iam_role.main.arn
  version =  var.out_of_date ? "1.14" : null

  vpc_config {
    subnet_ids =  ["${var.main_subnet_id}","${var.secondary_subnet_id}"]
    endpoint_public_access = var.publicly_accessible
    # public_access_cidrs = "${var.globally_accessible ? ["0.0.0.0/0"] : ["127.0.0.0/8"]}"
  }

  enabled_cluster_log_types = var.no_logs ? [] : ["api","audit","authenticator","controllerManager","scheduler"]

  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSServicePolicy,
  ]

  count = (var.out_of_date || var.no_logs || var.publicly_accessible || var.globally_accessible) ? 1 : 0

}

resource "aws_iam_role" "main" {
  name = "eks-cluster-sadcloud-example"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.main.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.main.name
}
