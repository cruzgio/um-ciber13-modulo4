# B1 · Remediar el crítico (nivel mínimo · 2 pts)

Regla del bloque: **la remediación no toca `app.py`** — se cambia la versión en `requirements.txt`, se reconstruye la imagen y se re-escanea. Así se remedia en DIE: cambia la imagen, no el contenedor.

Edita la versión de PyYAML (la versión que corrige está en la columna *CORRIGE EN* del escaneo; la última compatible con Python 3.8 es `6.0.2`):

```plain
nano /root/lab6/carrito/requirements.txt
```{{exec}}

Reconstruye y pon a correr la imagen remediada (equivale a `docker build -t carrito:v2 . && docker run -d -p 8080:8080 carrito:v2`):

```plain
ct-construir
```{{exec}}

Re-escanea y verifica — el servicio tiene que seguir respondiendo, si no, no remediaste: rompiste.

```plain
ct-escanear v2 --paquetes
ct-probar
ct-check
```{{exec}}

> Si la construcción falla por una versión que no existe o incompatible, pip te dice cuál. `ct-pista b1`.
