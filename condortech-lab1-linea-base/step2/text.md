## CP2 · Checklist CIS de 10 controles (20 min)

Un benchmark CIS no es un escáner: es una **lista de afirmaciones verificables**.
Para cada control registras tres cosas: qué se pide, si cumple o no, y **con qué comando
lo probaste**. Sin el comando, el hallazgo no es reproducible.

Los 10 controles nivel 1 de esta auditoría:

| # | Control | Comando de evidencia |
|---|---|---|
| 1 | Permisos de `/etc/shadow` restringidos | `stat -c '%a %U %G' /etc/shadow` |
| 2 | Permisos de `/etc/passwd` restringidos | `stat -c '%a %U %G' /etc/passwd` |
| 3 | Ninguna cuenta con contraseña vacía | `awk -F: '($2==""){print $1}' /etc/shadow` |
| 4 | Solo la cuenta root tiene UID 0 | `awk -F: '($3==0){print $1}' /etc/passwd` |
| 5 | SSH no permite login directo de root | `grep -i permitrootlogin /etc/ssh/sshd_config` |
| 6 | SSH no permite contraseñas vacías | `grep -i permitemptypasswords /etc/ssh/sshd_config` |
| 7 | SSH limita los intentos de autenticación | `grep -i maxauthtries /etc/ssh/sshd_config` |
| 8 | No hay reglas sudo NOPASSWD | `grep -r NOPASSWD /etc/sudoers.d/ /etc/sudoers` |
| 9 | No hay servicios de red innecesarios | `ss -tlnp` |
| 10 | Los jobs de cron no invocan scripts world-writable | `cat /etc/cron.d/*; find / -xdev -perm -0002 -type f 2>/dev/null` |

Corre los diez y llena el archivo:

```
mkdir -p /root/respuestas
cat > /root/respuestas/02.csv <<'CSV'
control;cumple_no_cumple;evidencia
1_permisos_shadow;no_cumple;stat=<pon aqui el octal real>
CSV
```{{copy}}

Completa las 10 filas con el formato `control;cumple_no_cumple;evidencia` y valida:

`ct-check 2`{{exec}}

> **Pregunta para el informe, no para la bandera:** busca en el CIS Benchmark de Ubuntu
> que descargaste el número exacto del control que cubre los permisos de `/etc/shadow`.
> La numeración cambia entre versiones del benchmark — por eso se cita *versión + número*, nunca el número solo.

<details><summary>Rescate — «si te atascas, salta aquí» (bandera a mitad de puntos)</summary>

```
{
echo "control;cumple_no_cumple;evidencia"
echo "1_permisos_shadow;no_cumple;$(stat -c '%a' /etc/shadow)"
echo "2_permisos_passwd;cumple;$(stat -c '%a' /etc/passwd)"
echo "3_cuentas_sin_password;no_cumple;$(awk -F: '($2==""){print $1}' /etc/shadow | tr '\n' ' ')"
echo "4_uid0_unico;no_cumple;$(awk -F: '($3==0){print $1}' /etc/passwd | tr '\n' ' ')"
echo "5_ssh_permitrootlogin;no_cumple;$(grep -i permitrootlogin /etc/ssh/sshd_config)"
echo "6_ssh_emptypasswords;no_cumple;$(grep -i permitemptypasswords /etc/ssh/sshd_config)"
echo "7_ssh_maxauthtries;no_cumple;$(grep -i maxauthtries /etc/ssh/sshd_config)"
echo "8_sudo_nopasswd;no_cumple;$(grep -rh NOPASSWD /etc/sudoers.d/ | tr '\n' ' ')"
echo "9_servicios_innecesarios;no_cumple;telnetd-legacy:2323"
echo "10_cron_world_writable;no_cumple;/opt/condortech/deploy/run-backup.sh"
} > /root/respuestas/02.csv
ct-check 2
```{{exec}}

</details>
