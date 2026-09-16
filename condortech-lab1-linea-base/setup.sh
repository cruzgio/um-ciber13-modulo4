#!/bin/bash
# =====================================================================
#  Cóndor Tech S.A.S. — Lab 1 · siembra de configuraciones inseguras
#  Módulo 4 · Universidad de Montevideo · Giovanni Cruz
#  Se ejecuta como "background" del intro: termina antes del CP1.
# =====================================================================
exec > /var/log/ct-setup.log 2>&1
set -x
export DEBIAN_FRONTEND=noninteractive

mkdir -p /opt/condortech/legacy /opt/condortech/deploy /root/respuestas

# --- INSEGURIDAD 1 · servicio heredado escuchando, nadie sabe por qué --
cp /usr/bin/python3 /usr/local/bin/telnetd-legacy
cat > /opt/condortech/legacy/LEEME.txt <<'EOF'
Servicio de inventario heredado del proveedor SysProv Ltda. (2019).
Nadie documentó para qué sirve. Nadie lo apagó.

CT{recon_servicio_heredado_2323}
EOF
cd /opt/condortech/legacy && nohup /usr/local/bin/telnetd-legacy -m http.server 2323 >/dev/null 2>&1 &
cd /root

# --- INSEGURIDAD 2 · cuenta sin contraseña ------------------------------
useradd -m -s /bin/bash soporte
passwd -d soporte

# --- INSEGURIDAD 3 · cuenta de servicio con UID 0 duplicado -------------
useradd -m -s /bin/bash -o -u 0 -g 0 sysprov

# --- INSEGURIDAD 4 · sudoers NOPASSWD para cuentas de aplicación --------
useradd -m -s /bin/bash deploy
echo 'deploy:deploy123' | chpasswd
mkdir -p /etc/sudoers.d
cat > /etc/sudoers.d/90-condortech <<'EOF'
deploy  ALL=(ALL) NOPASSWD: ALL
soporte ALL=(ALL) NOPASSWD: ALL
EOF
chmod 0440 /etc/sudoers.d/90-condortech

# --- INSEGURIDAD 5 · SSH permisivo --------------------------------------
mkdir -p /etc/ssh
cat > /etc/ssh/sshd_config <<'EOF'
Port 22
PermitRootLogin yes
PasswordAuthentication yes
PermitEmptyPasswords yes
MaxAuthTries 10
X11Forwarding yes
ClientAliveInterval 0
LogLevel QUIET
EOF

# --- INSEGURIDAD 6 · permisos de archivos de credenciales ---------------
chmod 0644 /etc/shadow
chmod 0666 /etc/gshadow 2>/dev/null || true

# --- INSEGURIDAD 7 · credencial en archivo world-writable ---------------
cat > /opt/condortech/deploy/backup.conf <<'EOF'
# Backup job heredado — SysProv Ltda. (2019)
BACKUP_TARGET=nas01.condortech.local
DB_USER=root
DB_PASSWORD=C0ndor2019!
FLAG=CT{credencial_en_archivo_world_writable}
EOF
chmod 0666 /opt/condortech/deploy/backup.conf

# --- INSEGURIDAD 8 · cron de root que ejecuta script world-writable -----
cat > /opt/condortech/deploy/run-backup.sh <<'EOF'
#!/bin/bash
echo "[backup] $(date)" >> /var/log/ct-backup.log
EOF
chmod 0777 /opt/condortech/deploy/run-backup.sh
cat > /etc/cron.d/condortech-backup <<'EOF'
0 2 * * * root /opt/condortech/deploy/run-backup.sh
EOF
chmod 0644 /etc/cron.d/condortech-backup

# --- Herramientas de reconocimiento (ss, curl) --------------------------
# Verificado: 'ss' NO viene en todas las imagenes base de Ubuntu.
apt-get update -qq
apt-get install -y -qq iproute2 net-tools curl procps

# --- Herramientas: Lynis ------------------------------------------------
if ! apt-get install -y -qq lynis; then
  git clone -q --depth 1 https://github.com/CISOfy/lynis /opt/lynis
  ln -sf /opt/lynis/lynis /usr/local/bin/lynis
fi

# --- Checker del laboratorio -------------------------------------------
cat > /usr/local/bin/ct-check <<'CHECKER'
#!/bin/bash
R=/root/respuestas
ok(){ echo; echo "  [OK] $1"; echo "  BANDERA CTFd -> $2"; echo; exit 0; }
no(){ echo; echo "  [PENDIENTE] $1"; echo; exit 1; }

case "$1" in
  1)
    f="$R/01.txt"
    [ -s "$f" ] || no "Crea $f con el nombre del servicio innecesario y su puerto."
    grep -qi "telnetd-legacy" "$f" || no "No veo el nombre del proceso que escucha. Revisa 'ss -tlnp'."
    grep -q "2323" "$f" || no "Falta el puerto en el que escucha ese proceso."
    ok "Reconocimiento completo: identificaste el servicio heredado." \
       "CT{recon_servicio_heredado_2323}"
    ;;
  2)
    f="$R/02.csv"
    [ -s "$f" ] || no "Crea $f con tu checklist (control;cumple_no_cumple;comando_evidencia)."
    n=$(grep -c ';' "$f")
    [ "$n" -ge 10 ] || no "Tu checklist tiene $n filas con formato; se piden 10 controles."
    grep -qi "no_cumple" "$f" || no "Ningun control marcado como no_cumple. Vuelve a revisar."
    grep -qE "0?644" "$f" || no "Falta registrar el permiso octal real de /etc/shadow."
    ok "Checklist CIS registrada con evidencia por control." \
       "CT{linea_base_10_controles_cis}"
    ;;
  3)
    f="$R/03.txt"
    [ -f /var/log/lynis-report.dat ] || no "Aun no corriste 'lynis audit system'."
    [ -s "$f" ] || no "Crea $f con la ruta del archivo world-writable que guarda una credencial."
    grep -q "/opt/condortech/deploy/backup.conf" "$f" || no "Esa no es la ruta. Busca archivos con permiso de escritura para todos."
    ok "Contraste automatizado completo." \
       "CT{credencial_en_archivo_world_writable}"
    ;;
  *)
    echo "Uso: ct-check <1|2|3>";;
esac
CHECKER
chmod +x /usr/local/bin/ct-check

touch /root/.ct-setup-done
