# Lab 6 · La auditoría pide un informe de vulnerabilidades

**Cóndor Tech, miércoles.** La auditoría externa quiere dos cosas que no existen: las políticas escritas y un informe de vulnerabilidades. El CISO reparte: *«Zona B, el carrito que pusieron en producción: escanéenlo, prioricen, remedien lo que importa y demuéstrenme que quedó cerrado»*.

Este laboratorio es el ciclo completo: **escanear → priorizar → remediar → verificar**. La herramienta es Trivy. El criterio lo pones tú.

**Dos bloques independientes**, cada uno con mínimo / completo / extra y rescate:

- **Bloque A (pasos 1–3):** escanear `carrito:legacy`, separar ruido de riesgo, priorizar con el contexto de negocio. Se responde con `ct-responder`.
- **Bloque B (pasos 4–6):** remediar en `requirements.txt`, reconstruir, re-escanear y demostrar antes/después. Se verifica con `ct-check`.

Reglas:
- Solo se escanea lo que está en este escenario. **Nunca** IPs ni imágenes de terceros.
- Si te atascas: `ct-pista <paso>`. Si se acaba el tiempo: `ct-rescate A` o `ct-rescate B` (bandera de rescate, mitad de puntos, válida).
- Si vuelves otro día: `ct-retomar <tu última bandera>`.

Cuando la barra de preparación termine:

```plain
ct-listo
```{{exec}}
