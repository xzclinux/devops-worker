provider "cloudflare" {
  api_token = var.cloudflare_api_key
}

data "cloudflare_zone" "this" {
  name = var.domain
}





resource "cloudflare_record" "jenkins" {
  zone_id         = data.cloudflare_zone.this.id
  name            = "jenkins.${var.prefix}.${var.domain}"
  value           = tencentcloud_instance.cvm_postpaid[0].public_ip
  type            = "A"
  ttl             = 60
  allow_overwrite = true
}


resource "cloudflare_record" "argocd" {
  zone_id         = data.cloudflare_zone.this.id
  name            = "argocd.${var.prefix}.${var.domain}"
  value           = tencentcloud_instance.cvm_postpaid[0].public_ip
  type            = "A"
  ttl             = 60
  allow_overwrite = true
}


