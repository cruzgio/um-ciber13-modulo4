# A2 · Priorizar con contexto (nivel completo · 2 pts)

Ordena por CVSS y mira qué queda arriba:

```plain
ct-escanear legacy --top
```{{exec}}

Casi todo lo de arriba es de un paquete que **no se ejecuta**. El CVSS no sabe eso; tú sí.

**Pregunta A2:** `ct-contexto` dice que el carrito envía el **token de la pasarela de pagos** en la cabecera `Authorization` usando `requests`. ¿Qué CVE del escaneo hace que ese token termine en manos de un tercero?

```plain
ct-responder a2 CVE-XXXX-XXXXX
```{{copy}}

Mientras tanto, empieza a llenar la **matriz de priorización** del artefacto (la plantilla está en Moodle): para cada hallazgo del top 5, las cinco columnas del criterio de Cóndor Tech — exposición, uso real, explotabilidad, impacto, CVSS — y la decisión: *corregir ya / esta semana / ventana de cambios / aceptar*.
