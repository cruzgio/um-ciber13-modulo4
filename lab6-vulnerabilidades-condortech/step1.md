# A1 · Escanear y ver el ruido (nivel mínimo · 2 pts)

Primero el contexto, que el escáner no conoce:

```plain
ct-contexto
```{{exec}}

Ahora el escaneo real de la imagen que está en producción (solo CRITICAL y HIGH; el comando completo es `trivy image --scanners vuln --severity CRITICAL,HIGH carrito:legacy`):

```plain
ct-escanear legacy
```{{exec}}

Demasiado para leer. Agrupa por paquete:

```plain
ct-escanear legacy --paquetes
```{{exec}}

**Pregunta A1:** de todo esto, ¿cuál es el CVE de **mayor riesgo para Cóndor Tech**? No el de mayor CVSS: el que se alcanza desde internet, sin credenciales, en código que el carrito **sí ejecuta**, y que permite ejecutar código. Cruza la columna *Entrada* de `ct-contexto` con los paquetes CRITICAL.

```plain
ct-responder a1 CVE-XXXX-XXXXX
```{{copy}}

> `ct-pista a1` si no lo ves. Los detalles de un CVE: `trivy image -q --severity CRITICAL carrito:legacy | grep -A2 <CVE>` o el JSON en `/root/lab6/escaneo-legacy.json`.
