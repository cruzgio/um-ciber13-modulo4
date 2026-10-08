# Bloque B — La segunda ola

> El atacante del Bloque A **nunca se fue**. El ransomware moderno no se conforma con cifrar los datos: busca los respaldos que están a su alcance y los destruye primero. Tu respaldo del Bloque A vive **en el mismo servidor**. Hoy vas a comprobar qué pasa con él… y vas a tener lista una copia que el atacante **no puede borrar**.

## 0. Si no terminaste el Bloque A

Entra con tu bandera (A Mínimo, A Completo o A Rescate) y el escenario reconstruye el estado por ti:

```
ct-retomar CT{...tu-bandera...}
```{{copy}}

## 1. Levanta un servidor de respaldo inmutable

`rest-server` es el servidor HTTP oficial de restic. Con `--append-only` acepta subir datos pero **rechaza cualquier borrado**:

```
rest-server --path /srv/inmutable --append-only --no-auth --listen 127.0.0.1:8080 > /var/log/rest-server.log 2>&1 &
```{{exec}}

(`--no-auth` es solo para el laboratorio; en producción va con usuario y contraseña o detrás de TLS).

## 2. Respalda el ERP hacia la copia inmutable

Misma llave de Cóndor Tech, otro destino:

```
restic -r rest:http://127.0.0.1:8080/erp -p /root/llave-condortech.txt init
```{{exec}}

```
restic -r rest:http://127.0.0.1:8080/erp -p /root/llave-condortech.txt backup /srv/condortech/erp
```{{exec}}

Comprueba que la copia está lista (y que rechaza el borrado):

```
ct-check b1
```{{exec}}

## 3. La segunda ola

```
ct-ransom
```{{exec}}

Lee lo que hace el atacante: cifra el ERP, **encuentra tu respaldo local y lo cifra**, e intenta borrar la copia inmutable.

## 4. Intenta recuperar con el respaldo local

```
restic -r /srv/respaldo/erp -p /root/llave-condortech.txt restore latest --target /srv/restaurado
```{{exec}}

No funciona. El respaldo que vive en el mismo servidor cayó con el servidor.

## 5. Recupera desde la copia inmutable

```
restic -r rest:http://127.0.0.1:8080/erp -p /root/llave-condortech.txt restore latest --target /srv/restaurado
```{{exec}}

```
ct-rto
```{{exec}}

`ct-rto` verifica hash por hash, mide el RTO de la segunda ola, vuelve a poner el ERP en producción, agrega la segunda ola a tu certificado y te entrega la bandera **B Inmutable**.

> **Sello DIE — Immutable:** esto es el pilar *Immutable* aplicado a la recuperación. En la nube el equivalente es *Object Lock* (S3), *immutability policies* (Azure Blob) o *retention lock* (GCS). Lo que no se puede borrar, no se puede extorsionar.

¿Atascado? `ct-pista b1` / `ct-pista b2` · ¿Sin tiempo? `ct-rescate B`
