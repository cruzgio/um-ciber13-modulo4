#!/bin/bash
# Demo de parchado — Cóndor Tech · Módulo 4
# Planta un paquete 'condor-sshd' en versión VULNERABLE (9.6p1) y deja una versión
# CORREGIDA (9.8p1) disponible en un repositorio apt LOCAL. Así el 'apt upgrade' es
# real y seguro. NO toca el OpenSSH real del sistema.
export DEBIAN_FRONTEND=noninteractive
LOG=/root/.demo-setup.log
exec >>"$LOG" 2>&1
set +e

REPO=/opt/condor-repo
mkdir -p "$REPO"

# --- construir un .deb de práctica para una versión dada ---
build_pkg() {   # $1=version  $2=descripción  $3=línea de changelog
  local ver="$1" desc="$2" chlog="$3" d
  d=$(mktemp -d)
  mkdir -p "$d/DEBIAN" "$d/usr/share/doc/condor-sshd"
  cat > "$d/DEBIAN/control" <<CTRL
Package: condor-sshd
Version: $ver
Section: net
Priority: optional
Architecture: all
Maintainer: Cóndor Tech <seguridad@condor.tech>
Description: Build de OpenSSH de Cóndor Tech (paquete de práctica)
 Paquete de práctica para la demo de parchado del Módulo 4.
 $desc
CTRL
  { echo "condor-sshd ($ver) stable; urgency=high"; echo; \
    echo "  * $chlog"; echo; \
    echo " -- Cóndor Tech <seguridad@condor.tech>  $(date -R)"; } \
    > "$d/usr/share/doc/condor-sshd/changelog"
  gzip -9n "$d/usr/share/doc/condor-sshd/changelog"
  dpkg-deb --build "$d" "$REPO/condor-sshd_${ver}_all.deb" >/dev/null
  rm -rf "$d"
}

build_pkg "9.6p1-condor1" "VULNERABLE a regreSSHion (CVE-2024-6387)." "Versión con regreSSHion (CVE-2024-6387) sin corregir."
build_pkg "9.8p1-condor1" "Corrige regreSSHion (CVE-2024-6387)." "Corrige regreSSHion (CVE-2024-6387): actualizar a esta versión."

# --- indexar el repo local (sin dpkg-dev: se arma el Packages a mano) ---
cd "$REPO"
: > Packages
for deb in condor-sshd_*.deb; do
  dpkg-deb -f "$deb" >> Packages
  echo "Filename: ./$deb" >> Packages
  echo "Size: $(stat -c %s "$deb")" >> Packages
  echo "SHA256: $(sha256sum "$deb" | cut -d' ' -f1)" >> Packages
  echo >> Packages
done
gzip -9kf Packages
echo "deb [trusted=yes] file:$REPO ./" > /etc/apt/sources.list.d/condor-demo.list
apt-get update -qq >/dev/null 2>&1

# --- instalar la versión VULNERABLE: el estado inicial de la demo ---
apt-get install -y --allow-downgrades condor-sshd=9.6p1-condor1 >/dev/null 2>&1

# ---------- helpers ----------
V="\033[1;32m"; A="\033[1;33m"; C="\033[1;36m"; N="\033[0m"

cat > /usr/local/bin/ct-listo <<'EOF'
#!/bin/bash
V="\033[1;32m"; R="\033[1;31m"; A="\033[1;33m"; N="\033[0m"
echo -e "\n== ¿Está lista la demo? =="
f=0
dpkg -s condor-sshd >/dev/null 2>&1 && echo -e "  ${V}[OK]${N} paquete de práctica instalado" || { echo -e "  ${R}[--]${N} preparando el paquete"; f=1; }
apt-cache policy condor-sshd 2>/dev/null | grep -q "9.8p1-condor1" && echo -e "  ${V}[OK]${N} versión corregida disponible en el repo local" || { echo -e "  ${R}[--]${N} preparando el repo"; f=1; }
if [ $f = 0 ]; then echo -e "\n${V}Todo listo. Empezá con: apt update && apt list --upgradable${N}\n"; else echo -e "\n${A}Esperá 20 segundos y volvé a correr ct-listo.${N}\n"; fi
EOF
chmod +x /usr/local/bin/ct-listo

cat > /usr/local/bin/ct-estado <<'EOF'
#!/bin/bash
echo "== Paquete de práctica (el de la demo) =="
apt-cache policy condor-sshd 2>/dev/null | sed -n '1,3p'
echo
echo "== OpenSSH real del sistema (para contrastar) =="
command -v ssh >/dev/null 2>&1 && ssh -V 2>&1 || echo "(cliente ssh no instalado en este equipo)"
apt-cache policy openssh-server 2>/dev/null | sed -n '1,3p'
echo
echo "Recordá: en Ubuntu/Debian el número de 'ssh -V' puede no cambiar aunque esté parchado."
echo "Lo que vale es la versión del PAQUETE (apt-cache policy) y el aviso del proveedor (USN)."
EOF
chmod +x /usr/local/bin/ct-estado

cat > /usr/local/bin/ct-reset <<'EOF'
#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get install -y --allow-downgrades condor-sshd=9.6p1-condor1 >/dev/null 2>&1
apt-get update -qq >/dev/null 2>&1
echo "Listo: condor-sshd volvió a 9.6p1-condor1 (vulnerable). Ya podés repetir la demo."
apt-cache policy condor-sshd 2>/dev/null | sed -n '1,3p'
EOF
chmod +x /usr/local/bin/ct-reset

cat > /root/LEEME.txt <<'EOF'
Demo de parchado — Cóndor Tech (Módulo 4)
Un paquete 'condor-sshd' plantado en versión vulnerable (9.6p1), con la corregida
(9.8p1) en un repo apt LOCAL. No toca el OpenSSH real del sistema.

  ct-listo     ¿está lista la demo?
  ct-estado    estado del paquete de práctica + OpenSSH real
  ct-reset     vuelve a la versión vulnerable para repetir la demo

El ciclo:
  1) apt update && apt list --upgradable
  2) (priorizar) servicio expuesto + RCE como root -> primero
  3) apt-get install --only-upgrade condor-sshd
  4) apt-cache policy condor-sshd ; zcat /usr/share/doc/condor-sshd/changelog.gz
EOF

touch /root/.demo-ready
echo "SETUP DONE $(date)"
