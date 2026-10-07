# B2 · Cerrar el segundo y verificar (nivel completo · 2 pts)

El segundo del top: `requests`. Sube `requests` y `urllib3` a las últimas versiones que aún soportan Python 3.8 (`ct-pista b2` las dice), reconstruye y verifica:

```plain
nano /root/lab6/carrito/requirements.txt
```{{exec}}

```plain
ct-construir && ct-check
```{{exec}}

Ahora el **antes/después** para el ticket de remediación:

```plain
ct-escanear legacy --paquetes > /root/lab6/antes.txt; ct-escanear v2 --paquetes > /root/lab6/despues.txt; diff /root/lab6/antes.txt /root/lab6/despues.txt
```{{exec}}

Ese `diff` es la evidencia que exige la auditoría: *«el hallazgo X ya no aparece en el re-escaneo de la fecha Y»*. Pégalo en el ticket.
