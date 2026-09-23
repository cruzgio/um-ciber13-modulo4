#!/usr/bin/env bash
# Levanta los servicios de cada zona.
set -u
mkdir -p /opt/ct/cuerpos
printf 'tienda-01 - Condor Tech (DMZ)'        > /opt/ct/cuerpos/tienda.txt
printf 'api-pagos - pasarela de pagos (internet)' > /opt/ct/cuerpos/externo.txt

http() { # ns, puerto, clave
  ip netns exec "$1" setsid socat TCP-LISTEN:$2,fork,reuseaddr \
      EXEC:"/opt/ct/servicio-http.sh $3" >/dev/null 2>&1 &
}
tcp() {  # ns, puerto, banner
  ip netns exec "$1" setsid socat TCP-LISTEN:$2,fork,reuseaddr \
      SYSTEM:"echo '$3'" >/dev/null 2>&1 &
}

http dmz      443  tienda
http internet 443  externo
tcp  interna  1433 "Microsoft SQL Server - erp-prod"
tcp  interna  445  "SMB - erp-prod (esto NUNCA debe cruzar desde la DMZ)"

sleep 1
