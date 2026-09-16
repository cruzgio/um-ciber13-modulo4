## CP2 · Checklist CIS de 10 controles (20 min)

Un benchmark CIS no es un escáner: es una **lista de afirmaciones verificables**.
Para cada control registras tres cosas: qué se pide, si cumple o no, y **con qué comando
lo probaste**. Sin el comando, el hallazgo no es reproducible.

Los 10 controles nivel 1 de esta auditoría:

| # | Control (identificador en la libreta) | Comando de evidencia |
|---|---|---|
| 1 | Permisos de `/etc/shadow` restringidos<br>`01_permisos_shadow` | `stat -c '%a %U %G' /etc/shadow` |
| 2 | Permisos de `/etc/passwd` restringidos<br>`02_permisos_passwd` | `stat -c '%a %U %G' /etc/passwd` |
| 3 | Ninguna cuenta con contraseña vacía<br>`03_cuentas_sin_password` | `awk -F: '($2==""){print $1}' /etc/shadow` |
| 4 | Solo la cuenta root tiene UID 0<br>`04_uid0_unico` | `awk -F: '($3==0){print $1}' /etc/passwd` |
| 5 | SSH no permite login directo de root<br>`05_ssh_permitrootlogin` | `grep -i permitrootlogin /etc/ssh/sshd_config` |
| 6 | SSH no permite contraseñas vacías<br>`06_ssh_emptypasswords` | `grep -i permitemptypasswords /etc/ssh/sshd_config` |
| 7 | SSH limita los intentos de autenticación<br>`07_ssh_maxauthtries` | `grep -i maxauthtries /etc/ssh/sshd_config` |
| 8 | No hay reglas sudo NOPASSWD<br>`08_sudo_nopasswd` | `grep -r NOPASSWD /etc/sudoers.d/ /etc/sudoers` |
| 9 | No hay servicios de red innecesarios<br>`09_servicios_innecesarios` | `ss -tlnp` |
| 10 | Los jobs de cron no invocan scripts world-writable<br>`10_cron_world_writable` | `cat /etc/cron.d/*; find / -xdev -perm -0002 -type f 2>/dev/null` |

### La libreta: no tienes que inventar nombres ni editar archivos

Los 10 controles ya vienen nombrados. Crea la libreta:

`ct-anota init`{{exec}}

Ahora, por cada control: corres el comando, decides el veredicto y registras las tres cosas
de un solo golpe. El primero, completo, como ejemplo:

`ct-anota 1 no_cumple "$(stat -c '%a' /etc/shadow)"`{{exec}}

La forma general es siempre la misma:

```
ct-anota <numero_1_a_10> <cumple|no_cumple> "<salida del comando>"
```

Mira cómo vas en cualquier momento con `ct-anota ver`{{exec}}. Puedes corregir un control
registrándolo de nuevo: se sobreescribe.

> **El truco que te ahorra transcribir:** mete el comando de la tabla entre `$( )` y su salida
> entra sola como evidencia. Por ejemplo, para el control 4:
> `ct-anota 4 no_cumple "$(awk -F: '($3==0){print $1}' /etc/passwd | tr '\n' ' ')"`{{copy}}

Cuando los 10 estén registrados:

`ct-check 2`{{exec}}

El validador verifica cuatro cosas: que estén los 10, que ninguno quede en `PENDIENTE`, que la
evidencia del control 01 traiga el permiso real de `/etc/shadow`, y que tus veredictos sean
coherentes con el estado de la máquina.

> **Pregunta para el informe, no para la bandera:** busca en el CIS Benchmark de Ubuntu que
> descargaste el número exacto del control que cubre los permisos de `/etc/shadow`.
> La numeración cambia entre versiones del benchmark — por eso se cita *versión + número*, nunca el número solo.

<details><summary>Rescate — «si te atascas, salta aquí» (bandera a mitad de puntos)</summary>

```
ct-anota init
ct-anota 1  no_cumple "$(stat -c '%a' /etc/shadow)"
ct-anota 2  cumple    "$(stat -c '%a' /etc/passwd)"
ct-anota 3  no_cumple "$(awk -F: '($2==""){print $1}' /etc/shadow | tr '\n' ' ')"
ct-anota 4  no_cumple "$(awk -F: '($3==0){print $1}' /etc/passwd | tr '\n' ' ')"
ct-anota 5  no_cumple "$(grep -i permitrootlogin /etc/ssh/sshd_config)"
ct-anota 6  no_cumple "$(grep -i permitemptypasswords /etc/ssh/sshd_config)"
ct-anota 7  no_cumple "$(grep -i maxauthtries /etc/ssh/sshd_config)"
ct-anota 8  no_cumple "$(grep -rh NOPASSWD /etc/sudoers.d/ | tr '\n' ' ')"
ct-anota 9  no_cumple "telnetd-legacy:2323"
ct-anota 10 no_cumple "/opt/condortech/deploy/run-backup.sh"
ct-check 2
```{{exec}}

</details>
