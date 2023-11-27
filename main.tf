terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.19.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "2.18.0"
    }
  }
  cloud {
    organization = "stdx-space"

    workspaces {
      name = "acme-provider-playground"
    }
  }
}

provider "acme" {
  # server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

data "cloudflare_zone" "stdx_space" {
  name = "stdx.space"
}

resource "cloudflare_record" "local" {
  zone_id = data.cloudflare_zone.stdx_space.id
  name    = "local"
  value   = "127.0.0.1"
  type    = "A"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "lab@stdx.space"
}

resource "acme_certificate" "certificate" {
  account_key_pem = acme_registration.reg.account_key_pem
  common_name     = cloudflare_record.local.hostname

  dns_challenge {
    provider = "cloudflare"
  }
}

resource "local_sensitive_file" "test_cert" {
  # concat CA certificate for full chain
  # as explained in https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/certificate#certificate_pem
  content  = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
  filename = "test/certs/cert.pem"
}

resource "local_sensitive_file" "test_key" {
  content  = acme_certificate.certificate.private_key_pem
  filename = "test/certs/key.pem"
}
