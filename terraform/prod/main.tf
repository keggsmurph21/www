module "app" {
  source = "../modules/app"

  env            = "prod"
  domain_name    = "murp.us"
  hosted_zone_id = "Z0820612WDPQTJK2N3ER"
}
