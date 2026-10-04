# Lab 5 · Cóndor Tech — Confinar con AppArmor y asegurar la Zona B

**Incidente #4.** El CISO de Cóndor Tech pregunta: *«¿Un contenedor comprometido puede tomarse el servidor?»*. Hoy respondes con las manos: primero confinas un servicio con **AppArmor** (Bloque A) y después auditas el clúster de la **Zona B** (Bloque B).

Los dos bloques son **independientes**: si llegas tarde al B, no necesitas haber terminado el A.

| Bloque | Mínimo aceptable | Nivel completo | Extra |
|---|---|---|---|
| **A · AppArmor** | A1 perfil en complain (2 pts) | A2 enforce + denegación (2 pts) | A3 necesidad nueva (1 pt) |
| **B · Kubernetes** | B1 el Pod privilegiado (2 pts) | B2 Pod endurecido (2 pts) | B3 caps + seccomp (1 pt) |

Rescate de cada bloque: 1 pt. Las banderas se suben en **CTFd → categoría Lab 5**, cada quien en su propia cuenta.

El escenario se está preparando (1–3 minutos: instala AppArmor y kube-bench, despliega la Zona B). Mientras tanto, mira el mapa:

```plain
ct-mapa
```{{exec}}

Cuando `ct-listo` muestre todo en verde, pasa al paso 1.

```plain
ct-listo
```{{exec}}

> Si te atascas: `ct-pista a1` (o a2, a3, b1, b2, b3). Si se acaba el tiempo: `ct-rescate A` o `ct-rescate B`. Si vuelves con una bandera: `ct-retomar CT{...}`.
