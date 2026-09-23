#!/usr/bin/env bash
# Monta las cuatro zonas de Cóndor Tech alrededor de fw-borde.
#
#   [internet] 203.0.113.50 ─┐
#   [dmz] tienda-01 192.168.10.10 ─┤
#                                  ├─ fw-borde ─┤
#   [interna] erp-prod 192.168.20.10 ─┘
#   [usuarios] pc-conta 192.168.30.50 ─┘
#
# El estudiante configura la cadena FORWARD de fw-borde: el tráfico que
# CRUZA de una zona a otra. El terminal de Killercoda no pasa por ahí.
set -u

if [ "${1:-}" = "--mostrar" ]; then
cat <<'MAPA'
  Zonas de Cóndor Tech en este escenario

    ZONA         RED                HOST              IP               ESCUCHA
    internet     203.0.113.0/24     api-pagos         203.0.113.50     443
    dmz          192.168.10.0/24    tienda-01         192.168.10.10    443
    interna      192.168.20.0/24    erp-prod          192.168.20.10    1433, 445
    usuarios     192.168.30.0/24    pc-contabilidad   192.168.30.50    —

    fw-borde tiene una pata en cada zona (siempre el .1) y filtra
    todo lo que cruza entre ellas en la cadena  forward.

    api-pagos es la pasarela de pagos del proveedor con el que cobra
    la tienda. Vive en internet: la tienda tiene que poder alcanzarla.

    Probar un flujo:   ct-probar <origen> <destino> <puerto>
    Ejemplo:           ct-probar tienda pagos 443
    Nombres válidos:   internet · pagos · tienda · erp · usuarios
MAPA
exit 0
fi

for ns in fwborde internet dmz interna usuarios; do
  ip netns del $ns 2>/dev/null
  ip netns add $ns
  ip netns exec $ns ip link set lo up
done
ip netns exec fwborde sysctl -qw net.ipv4.ip_forward=1

# pata(zona, nombre-if, red)
pata() {
  local ns="$1" ifn="$2" red="$3" ipz="$4"
  ip link add "b-$ns" type veth peer name "z-$ns"
  ip link set "b-$ns" netns fwborde
  ip link set "z-$ns" netns "$ns"
  ip netns exec fwborde ip addr add "$red.1/24" dev "b-$ns"
  ip netns exec fwborde ip link set "b-$ns" up
  ip netns exec "$ns" ip addr add "$red.$ipz/24" dev "z-$ns"
  ip netns exec "$ns" ip link set "z-$ns" up
  ip netns exec "$ns" ip route add default via "$red.1"
}

pata internet 0 203.0.113  50
pata dmz      0 192.168.10 10
pata interna  0 192.168.20 10
pata usuarios 0 192.168.30 50

# El escenario arranca con las reglas que la clase escribió el lunes.
ip netns exec fwborde nft flush ruleset 2>/dev/null
ip netns exec fwborde nft -f /opt/ct/reglas-clase4.nft
