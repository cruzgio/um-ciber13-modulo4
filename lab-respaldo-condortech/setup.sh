#!/bin/bash
# setup.sh — Prepara el escenario "Misión de respaldo — Cóndor Tech" (Clase 12)
# Corre en segundo plano al iniciar Killercoda. No requiere interacción.
export DEBIAN_FRONTEND=noninteractive
CT=/var/lib/ct
mkdir -p $CT /srv/condortech/erp /srv/respaldo /srv/inmutable /srv/restaurado
echo "iniciando" > $CT/estado

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
cat >> /root/.bashrc <<'EOF'
export RESTIC_PASSWORD_FILE=/root/llave-condortech.txt
export RESTIC_REPOSITORY=/srv/respaldo/erp
EOF

touch $CT/banderas
echo "listo" > $CT/estado
