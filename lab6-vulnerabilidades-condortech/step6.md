# B3 · Quitar lo que sobra (extra · 1 pt)

Pillow: decenas de hallazgos y cero uso. Borra su línea de `requirements.txt`, reconstruye y verifica:

```plain
nano /root/lab6/carrito/requirements.txt
```{{exec}}

```plain
ct-construir && ct-check
```{{exec}}

Mira la última línea de `ct-check`: lo que **queda** después de remediar (gunicorn, Werkzeug, Flask, urllib3…) no se cierra con `pip` en esta imagen porque la base `python:3.8` ya no recibe parches. Eso no se esconde: va al ticket como **causa raíz** (imagen base obsoleta) con su fecha comprometida, o como riesgo aceptado con dueño.

Compuerta de CI para que no vuelva a pasar (opcional, va al artefacto):

```plain
trivy image --scanners vuln --severity CRITICAL --ignore-unfixed --exit-code 1 carrito:v2; echo "código de salida: $?"
```{{exec}}

```plain
ct-banderas
```{{exec}}
