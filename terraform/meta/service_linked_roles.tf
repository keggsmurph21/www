resource "aws_iam_service_linked_role" "elasticloadbalancing" {
  aws_service_name = "elasticloadbalancing.amazonaws.com"
}
