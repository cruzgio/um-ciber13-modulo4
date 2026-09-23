#!/usr/bin/env bash
set -u
exec >>/var/log/ct-background.log 2>&1
echo "== ct background $(date -u) =="
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq nftables iproute2 socat curl python3 vim nano >/dev/null 2>&1
mkdir -p /opt/ct
chmod +x /opt/ct/* 2>/dev/null
for h in ct-shell ct-check ct-regla ct-retomar ct-rescate ct-informe ct-mapa ct-probar ct-banderas; do
  ln -sf /opt/ct/$h /usr/local/bin/$h
done
: > /opt/ct/estado
bash /opt/ct/topologia.sh
bash /opt/ct/servicios.sh
[ -f /root/fw-borde.nft ] || cp /opt/ct/reglas-clase4.nft /root/fw-borde.nft
touch /opt/ct/LISTO
echo "== ct background OK =="
