#!/bin/bash
# setup.sh — Prepara el escenario "Misión de respaldo — Cóndor Tech" (Clase 12)
# Corre en segundo plano al iniciar Killercoda. No requiere interacción.
export DEBIAN_FRONTEND=noninteractive
CT=/var/lib/ct
mkdir -p $CT /srv/condortech/erp /srv/respaldo /srv/inmutable /srv/restaurado
echo "iniciando" > $CT/estado

# ---------- 0. Herramientas ct-* (embebidas: no dependen de la copia de assets de Killercoda) ----------
base64 -d <<'CTEOF' | tar xzf - -C /usr/local/bin
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
CTEOF
chmod +x /usr/local/bin/ct-*

# ---------- 1. restic (binario oficial; respaldo: apt) ----------
if ! command -v restic >/dev/null 2>&1; then
  ( cd /tmp && curl -fsSL -o restic.bz2 \
      https://github.com/restic/restic/releases/download/v0.17.3/restic_0.17.3_linux_amd64.bz2 \
    && bunzip2 -f restic.bz2 && install -m 755 restic /usr/local/bin/restic ) \
  || ( apt-get update -qq && apt-get install -y -qq restic >/dev/null 2>&1 )
fi

# ---------- 2. rest-server (para la copia inmutable, Bloque B) ----------
if ! command -v rest-server >/dev/null 2>&1; then
  ( cd /tmp && curl -fsSL -o rs.tgz \
      https://github.com/restic/rest-server/releases/download/v0.13.0/rest-server_0.13.0_linux_amd64.tar.gz \
    && tar xzf rs.tgz && install -m 755 rest-server_0.13.0_linux_amd64/rest-server /usr/local/bin/rest-server )
fi
command -v jq >/dev/null 2>&1 || ( apt-get update -qq >/dev/null 2>&1; apt-get install -y -qq jq >/dev/null 2>&1 ) || true

# ---------- 3. La llave de Cóndor Tech (vive FUERA del repositorio) ----------
echo "CondorTech-Restic-2026" > /root/llave-condortech.txt
chmod 600 /root/llave-condortech.txt

# ---------- 4. Datos críticos del ERP de Cóndor Tech ----------
E=/srv/condortech/erp
mkdir -p $E/facturas $E/clientes $E/contratos $E/config
cat > $E/clientes/clientes.csv <<'EOF'
id,razon_social,rut,contacto,ciudad
C-001,Frigorífico del Este S.A.,211234560018,compras@frigoeste.uy,Montevideo
C-002,Agro Litoral SRL,214455660011,admin@agrolitoral.uy,Salto
C-003,Textil Pando S.A.,215566770014,finanzas@textilpando.uy,Pando
C-004,Logística Oriental,216677880017,ops@logoriental.uy,Rivera
C-005,Clínica Punta del Sol,217788990010,gerencia@clinicapds.uy,Maldonado
EOF
for m in 2026-07 2026-08 2026-09; do
  {
    echo "nro,fecha,cliente,concepto,monto_uyu,estado"
    n=1; for c in C-001 C-002 C-003 C-004 C-005; do
      printf 'F-%s-%03d,%s-%02d,%s,Servicio ERP mensual,%d,pagada\n' "${m//-/}" $n "$m" $((n*3)) "$c" $((48000 + n*3500))
      n=$((n+1))
    done
  } > $E/facturas/facturas_$m.csv
done
cat > $E/contratos/contrato_C-001.txt <<'EOF'
CONTRATO DE SERVICIO ERP — Cóndor Tech S.A.S. / Frigorífico del Este S.A.
Vigencia: 01-ene-2026 a 31-dic-2026. Nivel de servicio: 99,5 % mensual.
RPO comprometido con el cliente: 24 horas. RTO comprometido: 8 horas.
Penalidad por incumplimiento de RTO: 2 % de la facturación mensual por cada hora excedida.
EOF
cat > $E/contratos/contrato_C-005.txt <<'EOF'
CONTRATO DE SERVICIO ERP — Cóndor Tech S.A.S. / Clínica Punta del Sol
Vigencia: 01-mar-2026 a 28-feb-2027. Datos de salud: cifrado en reposo obligatorio.
RPO comprometido: 4 horas. RTO comprometido: 2 horas.
EOF
cat > $E/config/erp.conf <<'EOF'
# Configuración del ERP de Cóndor Tech — NO borrar
db_host=10.10.30.5
db_name=condor_erp
listen=0.0.0.0:8443
backup_window=02:00-04:00
EOF
# Manifiesto de integridad (sha256 de cada archivo) — lo usa ct-rto para verificar la restauración
( cd $E && find . -type f | sort | xargs sha256sum ) > $CT/manifiesto.sha256
cp $CT/manifiesto.sha256 $CT/manifiesto.original

# ---------- 5. Entorno cómodo para el estudiante ----------
echo 'export RESTIC_PASSWORD_FILE=/root/llave-condortech.txt' > /etc/profile.d/condortech.sh
grep -q RESTIC_PASSWORD_FILE /root/.bashrc || echo 'export RESTIC_PASSWORD_FILE=/root/llave-condortech.txt' >> /root/.bashrc

touch $CT/banderas
echo "listo" > $CT/estado
