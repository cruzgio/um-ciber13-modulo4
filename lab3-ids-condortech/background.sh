#!/usr/bin/env bash
# Prepara el puesto de detección. Corre en segundo plano al abrir el escenario.
set -u
exec >>/var/log/ct-background.log 2>&1
echo "== ct background $(date -u) =="
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq suricata jq >/dev/null 2>&1

mkdir -p /opt/ct/pcaps /opt/ct/reglas /opt/ct/salidas /opt/ct/demo
# Killercoda copia los assets planos en /opt/ct: los ordenamos aquí
mv /opt/ct/escaneo.pcap /opt/ct/mitm_clase6.pcap /opt/ct/malware.pcap /opt/ct/pcaps/ 2>/dev/null
mv /opt/ct/local.rules /opt/ct/reglas/ 2>/dev/null
mv /opt/ct/demo_ids.pcap /opt/ct/demo_reglas.rules /opt/ct/demo/ 2>/dev/null
chmod 644 /opt/ct/pcaps/* /opt/ct/reglas/* /opt/ct/demo/* 2>/dev/null
: > /opt/ct/estado
chmod +x /opt/ct/ct-* 2>/dev/null
for h in ct-mapa ct-alertas ct-buscar ct-bandera ct-pista ct-mi-regla ct-check ct-triaje ct-rescate ct-banderas; do
  ln -sf /opt/ct/$h /usr/local/bin/$h
done

# Reglas: ET Open + la regla local del docente (clave= y CondorLoader).
# suricata-update baja ET Open; si no hay red, caemos a las que trae el paquete.
suricata-update --no-test >/dev/null 2>&1 || true
RULES=/var/lib/suricata/rules/suricata.rules
[ -s "$RULES" ] || RULES=/etc/suricata/rules/suricata.rules
cat "$RULES" /opt/ct/reglas/local.rules > /opt/ct/reglas/todas.rules 2>/dev/null

# Pre-procesar los tres pcaps UNA vez, para que el alumno lea sin esperar 30s.
for P in escaneo mitm_clase6 malware; do
  mkdir -p /opt/ct/salidas/$P
  suricata -S /opt/ct/reglas/todas.rules -r /opt/ct/pcaps/$P.pcap -l /opt/ct/salidas/$P -k none >/dev/null 2>&1
done

touch /opt/ct/LISTO
echo "== ct background OK =="
