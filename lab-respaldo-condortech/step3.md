# Bloque B — La copia que el atacante no puede borrar

> El ransomware moderno busca y borra los respaldos **antes** de cifrar. Con las credenciales de respaldo en la mano, el atacante hace `restic forget` y adiós. La defensa: una copia **inmutable** (*append-only*): se puede escribir, nunca borrar.

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

## 2. Respalda hacia la copia inmutable

```
restic -r rest:http://127.0.0.1:8080/erp -p /root/llave-condortech.txt init
```{{exec}}

```
restic -r rest:http://127.0.0.1:8080/erp -p /root/llave-condortech.txt backup /srv/condortech/erp
```{{exec}}

## 3. Ahora eres el atacante: intenta borrar el respaldo

Toma el ID del snapshot y trata de olvidarlo:

```
restic -r rest:http://127.0.0.1:8080/erp -p /root/llave-condortech.txt snapshots
```{{exec}}

```
restic -r rest:http://127.0.0.1:8080/erp -p /root/llave-condortech.txt forget <ID_DEL_SNAPSHOT>
```{{copy}}

Debe fallar con **`403 Forbidden`** (si ves el mensaje repetirse, corta con `Ctrl+C`: el servidor ya dijo que no). Confirma que el snapshot sigue ahí:

```
restic -r rest:http://127.0.0.1:8080/erp -p /root/llave-condortech.txt unlock; restic -r rest:http://127.0.0.1:8080/erp -p /root/llave-condortech.txt snapshots
```{{exec}}

(`unlock` quita el candado que el atacante dejó a medias; los candados son lo único que un servidor *append-only* sí deja borrar).

## 4. Reclama la bandera B Inmutable

`ct-check b1` repite el ataque por su cuenta (un `DELETE` directo por HTTP) y comprueba que el servidor lo rechace:

```
ct-check b1
```{{exec}}

> **Sello DIE — Immutable:** esto es el pilar *Immutable* aplicado a la recuperación. En la nube el equivalente es *Object Lock* (S3), *immutability policies* (Azure Blob) o *retention lock* (GCS). Lo que no se puede borrar, no se puede extorsionar.

¿Atascado? `ct-pista b1` · ¿Sin tiempo? `ct-rescate B`
