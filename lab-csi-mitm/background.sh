#!/usr/bin/env bash
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq >/dev/null 2>&1
apt-get install -y -qq tshark >/dev/null 2>&1
mkdir -p /opt/ct /root/caso
PCAP=/root/caso/condor_incidente2.pcap
cp /opt/pcap/condor_incidente2.pcap "$PCAP" 2>/dev/null || cp assets/condor_incidente2.pcap "$PCAP" 2>/dev/null || true
touch /opt/ct/estado
echo "listo" > /opt/ct/.bg-done
