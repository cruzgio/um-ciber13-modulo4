# A3 · La trampa del CVSS (extra · 1 pt)

**Pregunta A3:** ¿qué paquete concentra más hallazgos CRITICAL/HIGH del escaneo y, sin embargo, **no debe entrar al top 5**? Argumento: no se ejecuta en este servicio.

```plain
ct-responder a3 NOMBRE_DEL_PAQUETE
```{{copy}}

Ese paquete no se parcha: **se elimina**. Es el paso B3.

Cierre del bloque A:

```plain
ct-banderas
```{{exec}}

> Si se te acabó el tiempo: `ct-rescate A` imprime el top 5 razonado y te da la bandera de rescate. Úsalo para el artefacto.
