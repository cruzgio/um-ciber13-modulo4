# Paso 3 — IP de C2 (13.3) y nota de rescate (13.4)

**C2:** el servidor de mando y control desde el que el atacante dio órdenes y bajó su cifrador. Lo vas a ver en más de un lugar: en el firewall y dentro de `erp-prod`.

Una pista de método: contar destinos en un log de firewall es una línea de `awk`, `sort` y `uniq -c`. Escríbela tú; si no te sale, `ct-pista a3`.

**Nota de rescate:** es un archivo. Está en la exportación del ERP.

```
ct-responder a3 <ip>
ct-responder a4 <nombre-del-archivo>
ct-check
```

Cada integrante envía las banderas **desde su propia cuenta** del CTFd. Si llegó el inyecto siguiente y no alcanzaste: `ct-rescate A` muestra el método completo y entrega la bandera de rescate.

**Para la Bitácora:** anota cada hallazgo con su **hora** y su **fuente**. Esa es la línea de tiempo del informe de las 20:30.
