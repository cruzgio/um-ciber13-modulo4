# Bloque B — tu propia regla de detección (3.4)

Las reglas de fábrica no atrapan todo. El loader de la campaña de facturas falsas usa un **User-Agent** propio que ninguna regla ET conoce. Vas a escribir la regla que lo detecte.

## 3.4 Mínimo aceptable · tu regla dispara

1. Descubrí el User-Agent del malware (si no lo viste en 3.3):
   ```
   ct-buscar malware.pcap
   ```
   En la salida de HTTP, el equipo infectado usa un User-Agent que **no** es un navegador normal.

2. Creá la plantilla de tu regla:
   ```
   ct-mi-regla
   ```
   Se crea `/root/mi-regla.rules` con la estructura lista. Editala:
   ```
   nano /root/mi-regla.rules
   ```
   Cambiá `CAMBIAME` por el User-Agent que descubriste (o la parte distintiva).

3. Probala:
   ```
   ct-check
   ```
   Si dispara sobre `malware.pcap`, te llevás la bandera **3.4 Mínimo**.

> Usá un SID en el rango **9100001+** para tu regla. Así no choca con las ET Open ni con las locales del docente.

## 3.4 Nivel completo · regla + nota de triaje

Una regla sin proceso no sirve. Escribí la **nota de triaje** que acompaña a tu detección:

```
ct-triaje
nano /root/triaje.txt
```

El mínimo son tres líneas: **qué disparó**, **qué severidad** y **cuál es la próxima acción**. El nivel completo agrega **cómo se actualizan las reglas** y **cómo se manejan los falsos positivos**.

Cuando tengas regla + triaje, volvé a correr `ct-check`: te da la bandera **3.4 Completo** además de la del mínimo.

## El artefacto del Runbook

Lo que escribiste hoy —tu regla + la nota de triaje— es el **Proceso de detección de Cóndor Tech (v1)**, que entra al Runbook y cierra el módulo 2. Estándar de calidad: **otro analista carga tu regla en un escenario limpio y dispara sobre el pcap**.

---

¿Sin tiempo? `ct-rescate` te da la regla de referencia (media bandera) y te deja seguir.
