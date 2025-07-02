resource "aws_iam_role" "terraform" {
  name               = "murp-us-terraform"
  assume_role_policy = data.aws_iam_policy_document.account_trust.json
}

resource "aws_iam_role_policy_attachment" "terraform-terraform" {
  role       = aws_iam_role.terraform.name
  policy_arn = aws_iam_policy.terraform.arn
}

resource "aws_iam_policy" "terraform" {
  name   = aws_iam_role.terraform.name
  policy = data.aws_iam_policy_document.terraform.json
}

data "aws_iam_policy_document" "terraform" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = ["arn:aws:s3:::murp-us-tfstates/*"]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]
    resources = ["arn:aws:s3:::murp-us-tfstates"]
  }
}
