data "aws_iam_policy_document" "account_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::253722192782:root"]
    }
  }
}
