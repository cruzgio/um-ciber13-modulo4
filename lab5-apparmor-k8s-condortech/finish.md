# Cierre del Lab 5

Lo que acabas de hacer **es DIE con las manos**:

- **Inmutable**: `readOnlyRootFilesystem: true` → el contenedor no cambia en ejecución; cambia la imagen.
- **Efímero**: borraste `carrito-legacy` y lo reemplazaste en segundos desde un manifiesto. Nadie lo lloró.
- **Distribuido**: el manifiesto corre igual en cualquier nodo del clúster.

Y AppArmor cerró la otra puerta: aunque el proceso sea root, solo hace lo que el perfil dice.

**Antes de cerrar la pestaña:** `ct-banderas` y sube cada una en CTFd (categoría Lab 5). Copia también tu perfil final, la línea `DENIED` de `ct-denegaciones` y tu manifiesto de carrito: son el artefacto. Si vas por el nivel completo, un `[FAIL]` de kube-bench.

**Artefacto del Runbook (equipo):** *Estándar de despliegue seguro de contenedores de Cóndor Tech* — mínimo aceptable ≈20 min (perfil final, línea DENIED y los 5 candados marcados); nivel completo +15 min (un hallazgo de kube-bench). Plantilla en Moodle, Semana 3.

> Si no terminaste: `ct-rescate A` / `ct-rescate B` siguen disponibles, y con `ct-retomar CT{...}` retomas en otra sesión desde donde dejaste. Parar no cuesta nota.
