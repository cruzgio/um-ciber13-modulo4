#!/bin/bash
clear
echo "Preparando el escenario de Cóndor Tech (Trivy + imagen legacy)..."
echo "Puedes empezar a leer. Cuando la barra termine, ejecuta: ct-listo"
for i in $(seq 1 180); do
  [ -f /root/lab6/.estado/listo ] && break
  printf "."; sleep 2
done
echo
[ -f /root/lab6/.estado/listo ] && echo "✔ Escenario listo. Ejecuta: ct-listo" || echo "Sigue preparándose en segundo plano. Prueba ct-listo en un minuto."
