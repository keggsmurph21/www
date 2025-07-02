module "app" {
  source = "../modules/app"

  env            = "dev"
  domain_name    = "dev.murp.us"
  hosted_zone_id = "Z0820612WDPQTJK2N3ER"
}
