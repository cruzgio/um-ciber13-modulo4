# Caso cerrado

## Lo que reconstruiste

| Bandera | Respuesta | Qué demuestra |
|---|---|---|
| 6.1 | 4 MAC | Sabés leer la capa 2, que es donde ocurrió el ataque |
| 6.2 | 192.168.30.66 | Identificaste al atacante pese a que falseaba su identidad |
| 6.3 | 02:00:00:de:ad:66 | Distinguiste la MAC real del gateway de la suplantada |
| 6.4 | Cond0r.Set2026 | Viste por qué el HTTP en claro es una herida abierta |
| 6.5 | frame 15 | Ubicaste el inicio exacto del incidente en la línea de tiempo |

## Lo que te llevás al Runbook

El artefacto de esta clase **no es un runbook: es un informe forense.** Una investigación se documenta con hallazgos, no con procedimiento. Está en Moodle la plantilla de una página.

## El sello DIE de hoy

**Ephemeral.** Si esa credencial hubiera sido de corta vida —un token que caduca en minutos— lo robado habría valido mucho menos. La pregunta de sello: ¿qué tanto habría reducido el daño?

## Para la clase 7

Mañana esta **misma captura** pasa por un IDS (Suricata). Vas a ver qué alerta habría cantado en segundos lo que a vos te tomó una hora investigar a mano.
