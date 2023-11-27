# ACME Provider Experiment

This repository is used as a experiment to test out [ACME terraform provider](https://registry.terraform.io/providers/vancluever/acme/latest/docs). It issues a certificate for the local domain `local.stdx.space` through Let's Encrypt DNS challenge.

## Generating Certificates

The secrets required for running Terraform apply is stored in `secrets.json`. You may create a shell populated with the secrets for running Terraform commands. The resultant certificates are stored in `test/certs`.

```bash
sops exec-env secrets.json zsh
terraform init
terraform apply
```

## Running Test Server

The test script will spin up a caddy server docker container and serve a 'Hello world' server with certificates generated.

```bash
cd test
./run.sh
```
