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
