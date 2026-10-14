# Paso 2 — Paciente cero (13.1) y cuenta comprometida (13.2)

**Pregunta guía:** ¿por qué equipo entró el atacante y con qué cuenta llegó a `erp-prod`?

Herramientas (te muestran el `grep`/`jq` que corren por debajo):

- `ct-buscar <texto>` busca en todo el pack.
- `ct-eventos` resume el registro de seguridad de `erp-prod`; `ct-eventos <ID>` muestra el detalle de un evento.

Método, no respuesta: **cruza fuentes**. Una sola fuente es un indicio; tres que coinciden son una conclusión.

- Contabilidad recibe facturas de proveedores que nadie reconoce. ¿Alguna llegó estos días?
- Un equipo infectado suele llamar a su servidor **a intervalos fijos**.
- La VPN no tiene segundo factor. ¿Alguien entró desde un lugar que no es el de siempre?

Cuando lo tengas (nombre del equipo sin dominio; cuenta sin dominio):

```
ct-responder a1 <nombre-del-equipo>
ct-responder a2 <cuenta>
```

¿Trabado? `ct-pista a1` · `ct-pista a2`
