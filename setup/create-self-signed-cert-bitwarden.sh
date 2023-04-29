#!/usr/bin/env bash

set -euxo pipefail

CERT_IDENTIFIER=$1

openssl req \
  -x509 \
  -nodes \
  -days 365 \
  -newkey rsa:4096 \
  -keyout ${CERT_IDENTIFIER}.key \
  -out ${CERT_IDENTIFIER}.crt \
  -reqexts SAN \
  -extensions SAN \
  -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:bitwarden.hole\nbasicConstraints=CA:TRUE,pathlen:0"))

sudo cp ${CERT_IDENTIFIER}.key /etc/ssl/private/${CERT_IDENTIFIER}.key
sudo cp ${CERT_IDENTIFIER}.crt /etc/ssl/certs/${CERT_IDENTIFIER}.crt
