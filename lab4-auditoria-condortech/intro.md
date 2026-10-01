# Lab 4 — La cuenta que nadie creó

**Cóndor Tech S.A.S. · Incidente #3 · Módulo 4 · Universidad de Montevideo**

En `srv-erp` apareció una cuenta que nadie creó: `svc_backup`, con `sudo` y contraseña. El CISO pregunta quién la creó y cuándo. Nadie puede responder: `auth.log` está vacío y `auditd` está instalado… pero apagado.

Hoy no vas a reconstruir el pasado. Vas a **encender la trazabilidad** para atrapar al atacante cuando vuelva (Bloque A) y después vas a **cazar una intrusión real** en un registro de eventos de Windows (Bloque B).

## Los dos bloques

| Bloque | Qué hacés | Tiempo | Banderas |
|---|---|---|---|
| **A · auditd** | Política de auditoría, encender `auditd`, hacer volver al atacante y encontrarlo con `ausearch` | 25 min | A Mínimo · A Completo |
| **B · .evtx real** | Cazar un túnel RDP en un registro de seguridad de Windows real, desde Linux | 30 min | B Mínimo · B Completo · B Antiforense |

**B no depende de A.** Si te quedás sin tiempo en A, pasá a B igual.

## Doble nivel

- **Mínimo aceptable**: respondés la pregunta que la herramienta te pone enfrente. Aprueba.
- **Nivel completo**: encontrás lo que la herramienta *no* te muestra sola. Distingue la nota alta.
- **Rescate**: `ct-rescate A` o `ct-rescate B` te da el camino completo. La bandera que consigas después vale como el reto «Rescate» (menos puntos, cero culpa).

Si algo te toma más del doble del tiempo, escribí `PAUSA` en el chat de Teams.

## Primer comando

```
ct-listo
```{{exec}}

Cuando todo esté en verde:

```
ct-mapa
```{{exec}}
