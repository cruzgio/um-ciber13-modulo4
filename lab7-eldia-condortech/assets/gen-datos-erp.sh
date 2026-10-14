#!/bin/bash
# >>> REEMPLAZAR por el generador de datos de la Clase 12 (lab-respaldo-condortech) para que los hashes coincidan <<<
# Genera los 7 archivos deterministas del ERP de Cóndor Tech en $1
D=${1:-/srv/erp-original}; mkdir -p $D; rm -f $D/*
printf 'id,empresa,contacto,rto_horas\n1,Frigorifico del Sur,ana.perez,8\n2,Logistica Rio Negro,juan.lima,4\n3,Clinica Carrasco,sofia.diaz,2\n4,Agro Salto,p.gomez,24\n' > $D/clientes.csv
for m in 07 08 09; do printf 'factura,cliente_id,monto_uyu,fecha\nF-%s-001,1,184500,2026-%s-05\nF-%s-002,3,99200,2026-%s-14\nF-%s-003,2,251000,2026-%s-27\n' $m $m $m $m $m $m > $D/facturas-2026-$m.csv; done
printf 'Contrato de servicio ERP - Condor Tech S.A.S.\nRTO comprometido: 4 horas. RPO comprometido: 1 hora.\nPenalidad por incumplimiento: 2%% de la facturacion mensual por hora.\n' > $D/contrato-ERP-rto.txt
printf 'Contrato con proveedor de nube\nRPO: 24 horas para copias secundarias. Retencion: 90 dias.\n' > $D/contrato-nube-rpo.txt
printf '[erp]\ndb=postgresql://erp@10.10.20.5/erp\nbackup=/srv/respaldo/erp\nschedule=cada 4h\n' > $D/erp.conf
