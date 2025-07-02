resource "aws_iam_role" "dev" {
  name               = "murp-us-dev"
  assume_role_policy = data.aws_iam_policy_document.account_trust.json
}

resource "aws_iam_role_policy_attachment" "dev-dev" {
  role       = aws_iam_role.dev.name
  policy_arn = aws_iam_policy.dev.arn
}

resource "aws_iam_policy" "dev" {
  name   = aws_iam_role.dev.name
  policy = data.aws_iam_policy_document.dev.json
}

data "aws_iam_policy_document" "dev" {
  statement {
    actions = [
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:Get*",
      "elasticloadbalancing:*Listener",
      "elasticloadbalancing:*LoadBalancer",
      "elasticloadbalancing:*LoadBalancerAttributes",
      "elasticloadbalancing:*Rule",
      "elasticloadbalancing:*Tags",
      "ec2:Describe*",
      "ec2:Get*",
      "ec2:*InternetGateway",
      "ec2:*Route",
      "ec2:*RouteTable",
      "ec2:*SecurityGroup",
      "ec2:*SecurityGroupEgress",
      "ec2:*SecurityGroupIngress",
      "ec2:*Subnet",
      "ec2:*Tags",
      "ec2:*Vpc",
      "route53:Get*",
      "route53:List*",
      "route53:*ResourceRecordSets",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "s3:*",
    ]
    resources = [
      "arn:aws:s3:::murp-us-public",
    ]
  }
}
