#!/usr/bin/env bash
# Biblioteca común de las herramientas ct-* del Lab 3 · Cóndor Tech S.A.S.
CT_DIR=/opt/ct
PCAPS="$CT_DIR/pcaps"
REGLAS="$CT_DIR/reglas"
ESTADO="$CT_DIR/estado"
MIS="$CT_DIR/mis-banderas.txt"
REGLA_ALUMNO=/root/mi-regla.rules
TRIAJE=/root/triaje.txt
source "$CT_DIR/flags.env"

C_OK=$'\e[32m'; C_MAL=$'\e[31m'; C_NOTA=$'\e[33m'; C_B=$'\e[1m'; C_N=$'\e[0m'
titulo(){ echo; echo "${C_B}── $* ${C_N}"; echo; }
ok(){ echo "  ${C_OK}✔${C_N} $*"; }
mal(){ echo "  ${C_MAL}✘${C_N} $*"; }
info(){ echo "  ${C_NOTA}·${C_N} $*"; }

norm(){ echo "$1" | tr 'A-Z' 'a-z' | tr -d ' ' | sed 's/^ct{//; s/}$//'; }
marcar(){ grep -qxF "$1" "$ESTADO" 2>/dev/null || echo "$1" >> "$ESTADO"; }
hecho(){ grep -qxF "$1" "$ESTADO" 2>/dev/null; }

# bandera <valor> <nombre del reto en CTFd>
bandera(){
  echo
  echo "  ${C_OK}${C_B}BANDERA${C_N}   ${C_B}$1${C_N}"
  echo "  ${C_NOTA}En CTFd:${C_N} categoría «${CT_CATEGORIA}» → reto «${C_B}$2${C_N}»"
  echo
  grep -qF "$1" "$MIS" 2>/dev/null || printf '%s\t%s\n' "$2" "$1" >> "$MIS"
}

exigir_listo(){
  if [ ! -f "$CT_DIR/LISTO" ]; then
    mal "El escenario todavía se está montando (descarga de reglas ET Open)."
    info "Espera a que la terminal diga «Caso listo» y reintenta."
    exit 1
  fi
}
