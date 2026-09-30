# Sprint de remediación · srv-legacy-01

El tablero de riesgos del Lab 1 sigue en rojo. Hoy tu equipo **endurece el mismo servidor** y lo **demuestra**.

**Espera 1 minuto antes de empezar:** el escenario está instalando las herramientas y midiendo el índice Lynis del servidor sin remediar.

| Bloque | Qué haces | Verificas con |
|---|---|---|
| A | Checkpoint 1 (cuentas) y Checkpoint 2 (superficie) | `ct-check 1` · `ct-check 2` |
| B | Checkpoint 3 (medir con Lynis) | `ct-check 3` |

- Cada checkpoint tiene **mínimo aceptable** y **nivel completo**; cada nivel da su propia bandera.
- `ct-estado` muestra los 8 controles en verde o rojo.
- Si te trabas: `ct-rescate <n>` (el checkpoint entrega la bandera de rescate, 1 punto).
- Si no cerraste el Bloque A: `ct-retomar <bandera del Bloque A>` y entras al B con el mínimo aplicado.
- Si algo se rompe, reinicia el escenario: el servidor es ganado, no mascota.
