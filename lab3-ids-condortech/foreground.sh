#!/usr/bin/env bash
printf "\n  Montando el puesto de detección de Cóndor Tech"
printf "\n  (instala Suricata y procesa las capturas con ET Open, ~2 min)"
for i in $(seq 1 150); do [ -f /opt/ct/LISTO ] && break; printf "."; sleep 2; done
echo
if [ -f /opt/ct/LISTO ]; then
  echo "  Puesto listo. Las capturas están en /opt/ct/pcaps/"
  echo "  Empezá con:  ct-mapa"
  echo
else
  echo "  El montaje tarda más de lo normal. Revisá /var/log/ct-background.log"
fi
