# Biblioteca común Lab 7 — EL DÍA
CT_DIR=/opt/ct; CT_STATE=/root/.ct-lab7; mkdir -p $CT_STATE
N='\033[0m'; B='\033[1m'; G='\033[32m'; Y='\033[33m'; R='\033[31m'; C='\033[36m'
declare -A CT_FLAG=( [a1]="CT{c13-a1-9f3b72}" [a2]="CT{c13-a2-4d81c0}" [a3]="CT{c13-a3-b27e55}" [a4]="CT{c13-a4-60c9ad}" [ares]="CT{c13-a-res-e13f48}" [b1]="CT{c13-b-rto-7a5d19}" [bres]="CT{c13-b-res-2c84fb}" )
declare -A CT_HASH=( [a1]="c24eb906662bdf16b82895eea5a6f7e180a64f2bdba225e44e2efa3d8063193f" [a2]="6ae9cc4f2e14f73a383fb31a7ab5669aedb73e557736580b8f4b3630fccb0385" [a3]="a6353bfbe92ae34a8544b367820743d0175595f96dcad8b904c39583f24c3eec" [a4]="cc789c03e230890e6b487900de7c628dd9e19782b525dad1404a03a808a05d33" )
declare -A CT_NOMBRE=( [a1]="13.1 Paciente cero" [a2]="13.2 Cuenta comprometida" [a3]="13.3 IP de C2" [a4]="13.4 Nota de rescate" [ares]="A Rescate" [b1]="13.5 Restauración validada" [bres]="B Rescate" )
ct_listo() { [ -f $CT_DIR/.listo ]; }
ct_espera() { if ! ct_listo; then echo -e "${Y}Preparando el escenario (evidencias + repositorio)... espera a que ct-listo diga LISTO.${N}"; exit 1; fi; }
ct_otorga() { local id=$1; touch $CT_STATE/$id; echo -e "${G}${B}✔ Bandera ${CT_NOMBRE[$id]}: ${CT_FLAG[$id]}${N}"; echo -e "   Envíala en el CTFd (categoría «Clase 13»), cada integrante desde su propia cuenta."; }
ct_sha() { printf '%s' "$1" | tr 'A-Z' 'a-z' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | sha256sum | cut -d' ' -f1; }
