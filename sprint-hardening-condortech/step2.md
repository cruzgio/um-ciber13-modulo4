# Bloque B · Medir la mejora

**Sesión nueva:** después de la pausa el servidor vuelve a estar sin remediar. Espera 2–3 minutos y ejecuta `ct-retomar` con **todas** tus banderas del Bloque A, por ejemplo:
`ct-retomar CT{...} CT{...}`
Con cualquier bandera repones el mínimo; con 8.1c y 8.2c repones también el completo. Si no tienes ninguna: `ct-rescate 1` y `ct-check 1`.

Lynis mide lo que sabe medir. Por eso, además de los 8 controles, aplica **sugerencias de Lynis del grupo AUTH** y vuelve a auditar.

1. Audita y lee las sugerencias: `lynis audit system --quick` y luego `grep '^suggestion' /var/log/lynis-report.dat | grep AUTH`
2. Aplica sugerencias (ejemplos en la Referencia Rápida: `UMASK 027`, edad de contraseñas, rondas de hash, core dumps).
3. Vuelve a auditar y verifica: `lynis audit system --quick` y luego `ct-check 3`

| Nivel | Qué pide |
|---|---|
| Mínimo | el índice sube respecto al servidor sin remediar (delta ≥ +1) |
| Completo | los 8 controles en verde (`ct-estado`) y delta ≥ +3 |

Al terminar: `ct-informe` deja el esqueleto de la Guía de hardening con tu evidencia. **Cópialo antes de que expire la sesión.**
