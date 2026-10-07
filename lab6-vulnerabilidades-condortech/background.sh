#!/bin/bash
# Prepara el escenario en segundo plano: instala Trivy, construye carrito:legacy y baja la base de CVE.
exec >>/root/lab6-prep.log 2>&1
set -x
export DEBIAN_FRONTEND=noninteractive
mkdir -p /root/lab6 /root/lab6/carrito /root/lab6/.estado /usr/local/bin
# esperar a que los assets estén copiados
for i in $(seq 1 60); do [ -f /root/lab6-assets/ct-check ] && break; sleep 2; done
cp /root/lab6-assets/ct-* /usr/local/bin/ && chmod +x /usr/local/bin/ct-*
cp /root/lab6-assets/app.py /root/lab6/carrito/
cp /root/lab6-assets/requirements.legacy.txt /root/lab6/carrito/requirements.txt
cp /root/lab6-assets/Dockerfile /root/lab6/carrito/Dockerfile
cp /root/lab6-assets/requirements.remediado.txt /root/lab6/.estado/requirements.remediado.txt
cp /root/lab6-assets/ctfd_access.ejemplo.log /root/lab6/ctfd_access.log
cp /root/lab6-assets/siem_correlar.py /root/lab6/.estado/siem_correlar.py
chmod 600 /root/lab6/.estado/* 2>/dev/null

# 1) Trivy (paquete .deb oficial, versión fija)
if ! command -v trivy >/dev/null 2>&1; then
  for i in 1 2 3; do
    curl -fsSL -o /tmp/trivy.deb "https://github.com/aquasecurity/trivy/releases/download/v0.75.0/trivy_0.75.0_Linux-64bit.deb" && break
    sleep 5
  done
  dpkg -i /tmp/trivy.deb || apt-get install -y -f
fi
touch /root/lab6/.estado/trivy.ok

# 2) base de datos de vulnerabilidades (una sola vez, para que el escaneo sea instantáneo)
for i in 1 2 3; do trivy image --download-db-only --quiet && break; sleep 5; done
touch /root/lab6/.estado/db.ok

# 3) imagen legacy del carrito, ya en ejecución en el puerto 8080
systemctl start docker 2>/dev/null || true
for i in $(seq 1 30); do docker info >/dev/null 2>&1 && break; sleep 2; done
docker build -t carrito:legacy /root/lab6/carrito && touch /root/lab6/.estado/build.ok
docker rm -f carrito-legacy >/dev/null 2>&1 || true
docker run -d --name carrito-legacy -p 8080:8080 --restart unless-stopped carrito:legacy
touch /root/lab6/.estado/listo
