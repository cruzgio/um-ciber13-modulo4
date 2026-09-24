#!/usr/bin/env bash
# Preparación del caso. Corre en segundo plano al abrir el escenario.
set -u
exec >>/var/log/ct-background.log 2>&1
echo "== ct background $(date -u) =="
export DEBIAN_FRONTEND=noninteractive
echo "wireshark-common wireshark-common/install-setuid boolean false" | debconf-set-selections
apt-get update -qq
apt-get install -y -qq tshark >/dev/null 2>&1
mkdir -p /opt/ct /root/caso
chmod +x /opt/ct/ct-* 2>/dev/null
for h in ct-abrir ct-mapa ct-pista ct-bandera ct-retomar ct-rescate; do
  ln -sf /opt/ct/$h /usr/local/bin/$h
done
cp /opt/ct/condor_incidente2.pcap /root/caso/condor_incidente2.pcap
touch /opt/ct/LISTO
echo "== ct background OK =="
