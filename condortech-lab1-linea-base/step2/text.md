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

### La libreta

Los 10 controles ya vienen nombrados. Crea la libreta:

`ct-anota init`{{exec}}

Por cada control: **corres el comando de la tabla, lees la salida, y registras el dato que prueba
tu veredicto.**

```
ct-anota <numero_1_a_10> <cumple|no_cumple> "<el dato que leiste>"
```

Ejemplo del control 1. Primero corres el comando:

`stat -c '%a %U %G' /etc/shadow`{{exec}}

Miras el resultado, decides si eso cumple o no, y registras **el dato**, no el comando:

```
ct-anota 1 no_cumple "644"
```{{copy}}

> **No pegues la salida completa sin leerla.** El validador comprueba, control por control, que el
> veredicto sea el correcto y que la evidencia contenga el dato que lo demuestra. Una casilla
> rellenada a ciegas se rechaza.

`ct-anota ver`{{exec}} te muestra cómo vas. Registrar un control de nuevo lo sobreescribe.

Cuando los 10 estén listos:

`ct-check 2`{{exec}}

Si algo falla, el validador te dice **qué números revisar** — no qué poner. Vuelve a correr esos
comandos y léelos con calma.

> **Pregunta para el informe, no para la bandera:** busca en el CIS Benchmark de Ubuntu que
> descargaste el número exacto del control que cubre los permisos de `/etc/shadow`.
> La numeración cambia entre versiones — se cita *versión + número*, nunca el número solo.

<details><summary>Rescate — «si te atascas, salta aquí»</summary>

Esto te entrega la solución del checkpoint y **lo marca como media puntuación**: `ct-check` te va
a dar la bandera de rescate en vez de la completa. Está aquí para que nadie se quede fuera del
objetivo de la clase, así que úsalo sin culpa si el reloj te está ganando.

`ct-rescate 2`{{exec}}

</details>
