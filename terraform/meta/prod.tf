resource "aws_iam_role" "prod" {
  name               = "murp-us-prod"
  assume_role_policy = data.aws_iam_policy_document.account_trust.json
}

resource "aws_iam_role_policy_attachment" "prod-prod" {
  role       = aws_iam_role.prod.name
  policy_arn = aws_iam_policy.prod.arn
}

resource "aws_iam_policy" "prod" {
  name   = aws_iam_role.prod.name
  policy = data.aws_iam_policy_document.prod.json
}

data "aws_iam_policy_document" "prod" {
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
