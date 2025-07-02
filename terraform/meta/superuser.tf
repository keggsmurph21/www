resource "aws_iam_role" "superuser" {
  name               = "murp-us-superuser"
  assume_role_policy = data.aws_iam_policy_document.account_trust.json
}

resource "aws_iam_role_policy_attachment" "superuser-superuser" {
  role       = aws_iam_role.superuser.name
  policy_arn = aws_iam_policy.superuser.arn
}

resource "aws_iam_policy" "superuser" {
  name   = aws_iam_role.superuser.name
  policy = data.aws_iam_policy_document.superuser.json
}

data "aws_iam_policy_document" "superuser" {
  statement {
    actions = [
      "iam:Get*",
      "iam:List*",
      "iam:*Policy",
      "iam:*PolicyVersion",
      "iam:*Role",
      "iam:*ServiceLinkedRole",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "sts:AssumeRole",
    ]
    resources = [
      "arn:aws:iam::253722192782:role/murp-us-terraform",
    ]
  }

  statement {
    actions = [
      "s3:*",
    ]
    resources = ["*"]
  }
}
