# Cierre del Lab 5

Lo que acabas de hacer **es DIE con las manos**:

- **Inmutable**: `readOnlyRootFilesystem: true` → el contenedor no cambia en ejecución; cambia la imagen.
- **Efímero**: borraste `carrito-legacy` y lo reemplazaste en segundos desde un manifiesto. Nadie lo lloró.
- **Distribuido**: el manifiesto corre igual en cualquier nodo del clúster.

Y AppArmor cerró la otra puerta: aunque el proceso sea root, solo hace lo que el perfil dice.

**Antes de cerrar la pestaña:** `ct-banderas` y sube cada una en CTFd (categoría Lab 5). Copia también la línea `DENIED` de `ct-denegaciones` y tus 3 `[FAIL]` de kube-bench: son la evidencia del artefacto.

**Artefacto del Runbook (equipo):** *Estándar de despliegue seguro de contenedores de Cóndor Tech* — mínimo aceptable ≈30 min (el perfil AppArmor funcionando + 5 puntos de checklist); nivel completo ≈60 min (+ checklist derivada de kube-bench con cómo se verifica cada punto). Plantilla en Moodle, Semana 3.

> Si no terminaste: `ct-rescate A` / `ct-rescate B` siguen disponibles, y con `ct-retomar CT{...}` retomas en otra sesión desde donde dejaste. Parar no cuesta nota.
