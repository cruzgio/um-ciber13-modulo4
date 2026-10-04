#!/bin/bash
# Lab 5 Cóndor Tech — preparación del escenario (corre en segundo plano al arrancar)
LOG=/root/lab5/setup.log
mkdir -p /root/lab5 /etc/condor /opt/condor /var/log/condor
exec >>"$LOG" 2>&1
echo "[$(date +%T)] inicio"

# 1. Esperar el clúster
for i in $(seq 1 60); do
  kubectl get nodes 2>/dev/null | grep -q " Ready" && break
  sleep 5
done
echo "[$(date +%T)] nodo listo"

# 2. Herramientas ct-* y archivos del lab (vienen en /root/lab5 por assets)
for i in $(seq 1 30); do [ -f /root/lab5/ct-check ] && break; sleep 2; done
chmod +x /root/lab5/ct-* 2>/dev/null
cp /root/lab5/ct-* /usr/local/bin/
touch /root/lab5/.banderas

# 3. El servicio de Cóndor Tech que vamos a confinar
cat >/etc/condor/app.conf <<'EOF'
# Configuración del servicio leer-config de Cóndor Tech (Zona B)
tienda.url=https://tienda.condortech.uy
pasarela.timeout=30
moneda=UYU
EOF
cp /root/lab5/leer-config /opt/condor/leer-config
chmod 755 /opt/condor/leer-config
chmod 644 /etc/condor/app.conf
touch /var/log/condor/app.log; chmod 666 /var/log/condor/app.log

# 4. AppArmor: utilidades (aa-status, aa-enabled, aa-unconfined)
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq apparmor apparmor-utils >/dev/null
systemctl start apparmor 2>/dev/null
echo "[$(date +%T)] apparmor: $(aa-enabled 2>&1)"

# 5. kube-bench (binario oficial, no necesita el clúster para instalarse)
cd /tmp && curl -sSL -o kube-bench.deb \
  https://github.com/aquasecurity/kube-bench/releases/download/v0.16.0/kube-bench_0.16.0_linux_amd64.deb \
  && dpkg -i kube-bench.deb >/dev/null 2>&1 && echo "[$(date +%T)] kube-bench instalado" \
  || echo "[$(date +%T)] AVISO: kube-bench no se pudo instalar (sin internet?)"

# 6. La Zona B de Cóndor Tech: namespace tienda con tres Pods (uno privilegiado)
ctr -n k8s.io images pull docker.io/library/busybox:1.36 >/dev/null 2>&1 || true
kubectl create namespace tienda 2>/dev/null
kubectl apply -f /root/lab5/zona-b.yaml
echo "[$(date +%T)] zona B desplegada"

touch /root/lab5/.listo
echo "[$(date +%T)] LISTO"
