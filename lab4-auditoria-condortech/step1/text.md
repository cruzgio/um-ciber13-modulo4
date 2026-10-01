# Bloque A · 1. Encender la auditoría

## Innegociable
`auditd` registra **quién** (auid = el humano que inició sesión), **qué** (syscall / archivo) y **cuándo**. `sudo` no lo engaña: aunque el proceso corra como root, `auid` sigue siendo la persona.

## 1. Escribir la política de auditoría de Cóndor Tech

```
ct-reglas
```{{exec}}

Leé la plantilla. Tiene tres claves: `identidad`, `sudoers`, `privilegiado`.

```
cat /etc/audit/rules.d/condortech.rules
```{{exec}}

## 2. Encender auditd y cargar las reglas

```
systemctl enable --now auditd
augenrules --load
auditctl -l
```{{exec}}

> Si `systemctl` falla en este entorno: `service auditd start` y después `augenrules --load`.

Deben aparecer las reglas con sus claves `-k`. Verificá el estado:

```
ct-check
```{{exec}}

## 3. Nivel completo del artefacto (opcional ahora, necesario para el Runbook)

Agregá al final de `/etc/audit/rules.d/condortech.rules` **una regla tuya** con la clave `-k propia` (por ejemplo, vigilar `/etc/cron.d` o `/root/.ssh`), y volvé a cargar:

```
nano /etc/audit/rules.d/condortech.rules
augenrules --load && auditctl -l | grep propia
```

Cuando `ct-check` muestre todo en verde para el bloque A, pasá al siguiente paso.
