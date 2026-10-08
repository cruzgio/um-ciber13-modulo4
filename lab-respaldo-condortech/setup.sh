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
