#!/usr/bin/env bash
# background.sh — Sprint de remediación (Clase 8). Deja srv-legacy-01 con las inseguridades del Lab 1,
# instala las herramientas ct-* y mide en segundo plano el índice Lynis del servidor sin remediar.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; A="$DIR/assets"; [ -d "$A" ] || A=/root/assets
for f in ct-check ct-estado ct-rescate ct-retomar ct-informe; do install -m 0755 "$A/$f" /usr/local/bin/$f; done
mkdir -p /opt/checker; rm -f /opt/checker/rescate_*; touch /opt/checker/.midiendo
export DEBIAN_FRONTEND=noninteractive
hostnamectl set-hostname srv-legacy-01 2>/dev/null || true
# V1 cuenta sin contraseña
id soporte >/dev/null 2>&1 || useradd -m -s /bin/bash soporte; passwd -d soporte >/dev/null
# V2 sudo total sin contraseña
echo 'soporte ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/90-condor; chmod 440 /etc/sudoers.d/90-condor
# V3 y V4 sin política ni bloqueo
sed -i '/^[[:space:]]*minlen/d' /etc/security/pwquality.conf 2>/dev/null; sed -i '/pam_faillock/d' /etc/pam.d/common-auth
# V6 /etc/shadow legible por todos
chmod 644 /etc/shadow
# V7 script heredado con credencial, escribible por todos
mkdir -p /opt/app/config
cat > /opt/app/config/backup.sh <<'S'
#!/bin/bash
# Respaldo del ERP — dejado por el proveedor anterior, sin documentar
DB_HOST=erp-prod.condortech.local
DB_USER=backup
DB_PASS=Cond0r2024!
mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" erp > /var/backups/erp.sql
S
chmod 777 /opt/app/config/backup.sh
# V8 SSH permisivo
sed -i '/^[[:space:]]*#\?[[:space:]]*PermitRootLogin/d;/^[[:space:]]*#\?[[:space:]]*PermitEmptyPasswords/d' /etc/ssh/sshd_config
printf 'PermitRootLogin yes\nPermitEmptyPasswords yes\n' >> /etc/ssh/sshd_config
# Paquetes (después de plantar los hallazgos: así nadie remedia antes de que existan)
command -v socat >/dev/null && command -v lynis >/dev/null && [ -f /etc/security/pwquality.conf ] || \
  { apt-get update -qq; apt-get install -y -qq socat lynis libpam-pwquality >/dev/null 2>&1; }
sed -i '/^[[:space:]]*minlen/d' /etc/security/pwquality.conf 2>/dev/null
# V5 servicio heredado en tcp/2323
cat > /etc/systemd/system/condor-legacy.service <<'U'
[Unit]
Description=Condor Legacy Admin (heredado, sin uso)
[Service]
ExecStart=/usr/bin/socat TCP-LISTEN:2323,fork,reuseaddr SYSTEM:"echo Condor Legacy Admin"
Restart=always
[Install]
WantedBy=multi-user.target
U
if pidof systemd >/dev/null 2>&1; then
  systemctl daemon-reload >/dev/null 2>&1; systemctl enable --now condor-legacy >/dev/null 2>&1
else
  nohup socat TCP-LISTEN:2323,fork,reuseaddr SYSTEM:"echo Condor Legacy Admin" </dev/null >/dev/null 2>&1 &
fi
# Línea base: índice Lynis del servidor sin remediar (equivale al estado de la clase 2)
( lynis audit system --quick --no-colors >/dev/null 2>&1
  grep '^hardening_index=' /var/log/lynis-report.dat | cut -d= -f2 > /opt/checker/baseline_index
  rm -f /var/log/lynis-report.dat /opt/checker/.midiendo ) </dev/null >/dev/null 2>&1 &
echo "srv-legacy-01 listo."
