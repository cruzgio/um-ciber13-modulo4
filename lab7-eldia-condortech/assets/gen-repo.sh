#!/bin/bash
# Construye el repositorio restic de Cóndor Tech (Bloque B) con la llave de la Clase 12.
export RESTIC_PASSWORD='CondorTech-Restic-2026'
O=/srv/erp-original; R=/srv/respaldo/erp
bash /opt/ct/gen-datos-erp.sh $O
rm -rf $R /srv/restaurado; mkdir -p $(dirname $R)
restic -r $R init -q
# el respaldo se hizo el 13-oct a las 22:00 desde /srv/erp (misma ruta que el ERP), por eso se arma ahí
mkdir -p /srv/erp.bak && cp -a /srv/erp/. /srv/erp.bak/ 2>/dev/null
rm -rf /srv/erp && cp -a $O /srv/erp
restic -r $R backup /srv/erp --tag erp --tag clase12 --time "2026-10-08 19:20:00" -q
rm -rf /srv/erp && mv /srv/erp.bak /srv/erp
( cd $O && sha256sum * ) > /opt/ct/hashes-erp.txt
chmod 600 /opt/ct/hashes-erp.txt
rm -rf $O
unset RESTIC_PASSWORD
echo "repo ok"
