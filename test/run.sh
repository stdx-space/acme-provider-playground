#!/usr/bin/env bash
docker run --rm -p 8000:8000 -v $PWD/Caddyfile:/etc/caddy/Caddyfile -v $PWD/certs:/etc/caddy/certs caddy
