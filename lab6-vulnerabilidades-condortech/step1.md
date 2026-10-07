# A1 · Escanear y ver el ruido (nivel mínimo · 2 pts)

Primero el contexto, que el escáner no conoce:

```plain
ct-contexto
```{{exec}}

Ahora el escaneo real de la imagen que está en producción. La herramienta te muestra arriba, en celeste, el comando de Trivy que ejecuta por debajo; la salida completa son cientos de líneas, así que verás un resumen por capas:

```plain
ct-escanear legacy
```{{exec}}

Más de 500 hallazgos, la mayoría del sistema operativo de la imagen base. Concéntrate en la capa Python, agrupada por paquete:

```plain
ct-escanear legacy --paquetes
```{{exec}}

**Pregunta A1:** de todo esto, ¿cuál es el CVE de **mayor riesgo para Cóndor Tech**? No el de mayor CVSS: el que se alcanza desde internet, sin credenciales, en código que el carrito **sí ejecuta**, y que permite ejecutar código. Cruza la columna *Entrada* de `ct-contexto` con los paquetes CRITICAL.

```plain
ct-responder a1 CVE-XXXX-XXXXX
```{{copy}}

> `ct-pista a1` si no lo ves. Todos los CVE de un paquete: `ct-escanear legacy --paquete <nombre>`. Tabla completa de Trivy: `less -S /root/lab6/escaneo-legacy.txt` (q para salir).
