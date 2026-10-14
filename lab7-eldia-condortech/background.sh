#!/bin/bash
# Lab 7 — EL DÍA · Cóndor Tech · prepara evidencias (Bloque A) y repositorio restic (Bloque B)
exec > /var/log/ct-background.log 2>&1
set -u
export DEBIAN_FRONTEND=noninteractive
for t in /opt/ct/ct-*; do ln -sf "$t" /usr/local/bin/$(basename "$t"); done
chmod +x /opt/ct/*.sh /opt/ct/ct-* 2>/dev/null
apt-get update -qq
apt-get install -y -qq restic jq openssl >/dev/null
bash /opt/ct/gen-evidencias.sh
bash /opt/ct/gen-repo.sh
touch /opt/ct/.listo
echo "LISTO $(date)"
