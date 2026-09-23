#!/usr/bin/env bash
# Biblioteca común de las herramientas ct-* del Lab 2 · Cóndor Tech S.A.S.
CT_DIR=/opt/ct
ESTADO="$CT_DIR/estado"
RULESET=/root/fw-borde.nft
# shellcheck disable=SC1090
source "$CT_DIR/flags.env"

C_OK=$'\e[32m'; C_MAL=$'\e[31m'; C_NOTA=$'\e[33m'; C_B=$'\e[1m'; C_N=$'\e[0m'

titulo() { echo; echo "${C_B}── $* ${C_N}"; echo; }
ok()     { echo "  ${C_OK}✔${C_N} $*"; }
mal()    { echo "  ${C_MAL}✘${C_N} $*"; }
info()   { echo "  ${C_NOTA}·${C_N} $*"; }

nftf() { ip netns exec fwborde nft "$@"; }

# Nombres amables -> zona e IP
zona_de() { case "$1" in
    internet) echo internet ;;
    tienda|dmz|tienda-01) echo dmz ;;
    erp|erp-prod|interna) echo interna ;;
    usuarios|pc|contabilidad) echo usuarios ;;
    *) echo "" ;; esac; }
ip_de() { case "$1" in
    internet|externo|sitio-externo) echo 203.0.113.50 ;;
    tienda|dmz|tienda-01) echo 192.168.10.10 ;;
    erp|erp-prod|interna) echo 192.168.20.10 ;;
    usuarios|pc|contabilidad) echo 192.168.30.50 ;;
    *) echo "" ;; esac; }

# flujo <origen> <destino> <puerto>  -> 0 pasa, 1 cae
flujo() {
  local ns; ns="$(zona_de "$1")"
  local dst; dst="$(ip_de "$2")"
  [ -z "$ns" ] || [ -z "$dst" ] && return 2
  ip netns exec "$ns" timeout 3 bash -c "echo > /dev/tcp/$dst/$3" 2>/dev/null
}

marcar() { grep -qxF "$1" "$ESTADO" 2>/dev/null || echo "$1" >> "$ESTADO"; }
hecho()  { grep -qxF "$1" "$ESTADO" 2>/dev/null; }

MIS="$CT_DIR/mis-banderas.txt"

# bandera <valor> <nombre del reto en CTFd>
bandera() {
  echo
  echo "  ${C_OK}${C_B}BANDERA${C_N}   ${C_B}$1${C_N}"
  echo "  ${C_NOTA}Reto de CTFd:${C_N} $2"
  echo
  grep -qF "$1" "$MIS" 2>/dev/null || printf '%s\t%s\n' "$2" "$1" >> "$MIS"
}

exigir_escenario() {
  if ! ip netns list 2>/dev/null | grep -q fwborde; then
    mal "El escenario todavía se está montando. Espera unos segundos y reintenta."
    exit 1
  fi
}
