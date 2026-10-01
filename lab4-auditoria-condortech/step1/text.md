# Bloque A · 1. Encender la auditoría

## Innegociable
`auditd` registra **quién** (auid = el humano que inició sesión), **qué** (syscall / archivo) y **cuándo**. `sudo` no lo engaña: aunque el proceso corra como root, `auid` sigue siendo la persona.

## 1. Escribir y cargar la política de auditoría de Cóndor Tech

```
ct-reglas
```{{exec}}

`ct-reglas` escribe la política, enciende `auditd` y carga las reglas en el kernel de una. Por detrás hace lo mismo que harías a mano: `systemctl enable --now auditd` y `auditctl -R /etc/audit/rules.d/condortech.rules`.

Leé la plantilla que escribió. Tiene tres claves: `identidad`, `sudoers`, `privilegiado`.

```
cat /etc/audit/rules.d/condortech.rules
```{{exec}}

## 2. Verificar que las reglas están activas

```
auditctl -l
```{{exec}}

Deben aparecer las reglas con sus claves. Un detalle que confunde: las reglas de archivo (`-w`) muestran la clave como `-k identidad` / `-k sudoers`, pero las de syscall la muestran como `key=privilegiado`. Es la misma clave: `auditctl` la imprime distinto según el tipo de regla. Revisá el estado general:

```
ct-check
```{{exec}}

## 3. Nivel completo del artefacto (opcional ahora, necesario para el Runbook)

Agregá al final de `/etc/audit/rules.d/condortech.rules` **una regla tuya** con la clave `-k propia` —distinta de los ejemplos comentados— que cubra una amenaza que las tres anteriores no ven (borrado de archivos, montaje de dispositivos, acceso a `/etc/ssh`…). Después recargá con `ct-reglas` (respeta tu edición) y dejá que dispare para tener evidencia:

```
nano /etc/audit/rules.d/condortech.rules
ct-reglas
auditctl -l | grep -i propia
```

Cuando `ct-check` muestre el bloque A en verde, pasá al siguiente paso.
