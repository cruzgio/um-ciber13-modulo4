#!/usr/bin/env bash
printf "\n  Montando las zonas de Cóndor Tech"
for i in $(seq 1 90); do [ -f /opt/ct/LISTO ] && break; printf "."; sleep 2; done
echo
if [ -f /opt/ct/LISTO ]; then
  echo; bash /opt/ct/topologia.sh --mostrar; echo
  echo "  Listo. fw-borde ya tiene los renglones 10, 20 y 90 del lunes."
  echo "  Entra con:  ct-shell"
  echo
else
  echo "  El montaje tarda. Revisa /var/log/ct-background.log"
fi
