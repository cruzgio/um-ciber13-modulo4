# Bloque A · Cuentas, superficie y permisos

Trabajas como root en esta terminal. La **Referencia Rápida** (Moodle y lámina) tiene los comandos de diagnóstico.

## Checkpoint 1 · Cuentas y accesos
| Nivel | Control |
|---|---|
| Mínimo | **V1** la cuenta `soporte` no tiene contraseña: bloquéala · **V2** hay un sudo total sin contraseña en `/etc/sudoers.d/`: quítalo |
| Completo | **V3** política de contraseñas `minlen = 14` en `/etc/security/pwquality.conf` · **V4** bloqueo por intentos con `pam_faillock` en `/etc/pam.d/common-auth` |

Antes de editar sudoers: usa `visudo -f <archivo>` o borra el archivo; un sudoers mal escrito rompe sudo.

`ct-check 1`

## Checkpoint 2 · Superficie y permisos
| Nivel | Control |
|---|---|
| Mínimo | **V5** un servicio heredado escucha en `tcp/2323`: apágalo · **V6** `/etc/shadow` es legible por todos: déjalo en `640 root:shadow` |
| Completo | **V7** `/opt/app/config/backup.sh` es escribible por todos y tiene una credencial: quítale la escritura a "otros" · **V8** SSH: `PermitRootLogin no` y `PermitEmptyPasswords no` |

`ct-check 2`

Anota el comando de evidencia de cada control: lo necesitas para la Guía de hardening.

**Antes de la pausa:** corre `ct-informe` y copia la salida (y tus banderas). La sesión dura 60 minutos; después de la pausa abrirás una nueva.

No reinicies el servicio SSH: `ct-check` verifica la configuración del archivo.
