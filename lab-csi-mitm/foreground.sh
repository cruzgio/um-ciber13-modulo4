#!/usr/bin/env bash
printf "\n  Preparando el caso de Cóndor Tech (instala tshark, ~1 minuto)"
for i in $(seq 1 90); do [ -f /opt/ct/LISTO ] && break; printf "."; sleep 2; done
echo
if [ -f /opt/ct/LISTO ]; then
  echo "  Caso listo. La captura está en /root/caso/condor_incidente2.pcap"
  echo "  Empezá con:  ct-mapa"
  echo
else
  echo "  El montaje tarda. Revisá /var/log/ct-background.log"
fi
