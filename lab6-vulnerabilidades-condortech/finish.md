# Cierre del Lab 6

Hiciste el ciclo completo con evidencia:

- **Escanear**: Trivy sobre la imagen real, no sobre una lista.
- **Priorizar**: el top 5 por **contexto** (exposición × uso real × explotabilidad × impacto), no por CVSS. Pillow quedó fuera con argumento.
- **Remediar**: cambiando la imagen (`requirements.txt` → `docker build`), no parchando el contenedor vivo.
- **Verificar**: re-escaneo con `diff` antes/después y el servicio respondiendo.

**Sello DIE:** si esta imagen se reconstruyera cada semana desde una base parcheada (`python:3.12-slim`) con un `trivy --exit-code 1` en el CI, ¿cuántos de los hallazgos que quedaron se habrían cerrado sin un ticket manual? Esa respuesta cierra la clase.

**Antes de cerrar la pestaña:** `ct-banderas` y sube cada bandera en CTFd (categoría Lab 6). Guarda tu `diff` antes/después: es la evidencia del ticket del artefacto.
