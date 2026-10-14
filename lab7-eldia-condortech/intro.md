# EL DÍA — Lab 7 · Cóndor Tech S.A.S.

> *05:47. El ERP (`erp-prod`) no responde. La exportación del ERP amaneció cifrada y hay una nota de rescate. «Si mañana amanecemos con el ERP cifrado, no hay un solo documento que diga qué hacer primero». Hoy sí lo hay: el de tu equipo.*

Este escenario es el **componente técnico** de la simulación. Lo opera el rol **Técnico**; el resto del equipo sigue decidiendo y registrando en la Bitácora.

| Bloque | Cuándo | Qué logras | Banderas |
|---|---|---|---|
| **A · Evidencias** | Inyecto 3 | Paciente cero, cuenta comprometida, IP de C2 y nombre de la nota | 13.1 (2) · 13.2 (2) · 13.3 (2) · 13.4 (1) · Rescate A (1) |
| **B · Recuperación** | Inyecto 6 | Restaurar el ERP con **tu llave de la Clase 12** y validarlo | 13.5 (2) · Rescate B (1) |

Los bloques son **independientes**. La sesión dura **60 minutos**: si se te acaba antes del inyecto 6, abre una sesión nueva y ve directo al Paso 4. Las banderas que ya enviaste al CTFd no se pierden. `ct-tiempo` te dice cuánto te queda.

**Regla de tiempo:** si te trabas, escribe `PAUSA` en el chat de Teams y usa `ct-pista`. Si llegó el inyecto siguiente, `ct-rescate` y sigues con tu equipo. Parar no cuesta nota.

## Antes de empezar

El escenario se prepara solo (1–2 min):

```
ct-listo
```{{exec}}

```
ct-mapa
```{{exec}}

> Cada herramienta `ct-*` te muestra en gris los comandos reales que ejecuta. Léelos: son los que usarías en un incidente de verdad.
