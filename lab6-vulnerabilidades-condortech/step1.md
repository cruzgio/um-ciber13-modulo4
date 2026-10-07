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

Ahora lo que el escáner no sabe: **dónde se usa cada paquete en el código del carrito y quién le manda datos** (la herramienta te muestra el `grep` que hace por debajo):

```plain
ct-uso
```{{exec}}

**Pregunta A1:** ¿cuál es el CVE de **mayor riesgo para Cóndor Tech**? No el de mayor CVSS. Haz el embudo:

1. En `ct-escanear legacy --paquetes`: ¿qué paquetes tienen algún **CRITICAL**?
2. En `ct-uso`: de esos, ¿cuál **se ejecuta** y **recibe datos de cualquier cliente de internet**?
3. En `ct-escanear legacy --paquete <ese paquete>`: mira la columna **IMPACTO** del CVE CRITICAL. ¿Permite ejecutar código?

Ese CVE es tu respuesta.

```plain
ct-responder a1 CVE-XXXX-XXXXX
```{{copy}}

> `ct-pista a1` si no lo ves. Todos los CVE de un paquete: `ct-escanear legacy --paquete <nombre>`. Tabla completa de Trivy: `less -S /root/lab6/escaneo-legacy.txt` (q para salir).
