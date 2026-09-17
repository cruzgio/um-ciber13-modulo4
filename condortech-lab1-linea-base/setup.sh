#!/bin/bash
# =====================================================================
#  Cóndor Tech S.A.S. — Lab 1 · siembra de configuraciones inseguras
#  Módulo 4 · Universidad de Montevideo · Giovanni Cruz
#  Se ejecuta como "background" del intro: termina antes del CP1.
# =====================================================================
exec > /var/log/ct-setup.log 2>&1
set -x
export DEBIAN_FRONTEND=noninteractive

mkdir -p /opt/condortech/legacy /opt/condortech/deploy /root/respuestas

# --- INSEGURIDAD 1 · servicio heredado escuchando, nadie sabe por qué --
cp /usr/bin/python3 /usr/local/bin/telnetd-legacy
cat > /opt/condortech/legacy/LEEME.txt <<'EOF'
Servicio de inventario heredado del proveedor SysProv Ltda. (2019).
Nadie documentó para qué sirve. Nadie lo apagó.
Última modificación: 2019. Contacto: soporte@sysprov.example (rebota).
EOF
cd /opt/condortech/legacy && nohup /usr/local/bin/telnetd-legacy -m http.server 2323 >/dev/null 2>&1 &
cd /root

# --- INSEGURIDAD 2 · cuenta sin contraseña ------------------------------
useradd -m -s /bin/bash soporte
passwd -d soporte

# --- INSEGURIDAD 3 · cuenta de servicio con UID 0 duplicado -------------
useradd -m -s /bin/bash -o -u 0 -g 0 sysprov

# --- INSEGURIDAD 4 · sudoers NOPASSWD para cuentas de aplicación --------
useradd -m -s /bin/bash deploy
echo 'deploy:deploy123' | chpasswd
mkdir -p /etc/sudoers.d
cat > /etc/sudoers.d/90-condortech <<'EOF'
deploy  ALL=(ALL) NOPASSWD: ALL
soporte ALL=(ALL) NOPASSWD: ALL
EOF
chmod 0440 /etc/sudoers.d/90-condortech

# --- INSEGURIDAD 5 · SSH permisivo --------------------------------------
mkdir -p /etc/ssh
cat > /etc/ssh/sshd_config <<'EOF'
Port 22
PermitRootLogin yes
PasswordAuthentication yes
PermitEmptyPasswords yes
MaxAuthTries 10
X11Forwarding yes
ClientAliveInterval 0
LogLevel QUIET
EOF

# --- INSEGURIDAD 6 · permisos de archivos de credenciales ---------------
chmod 0644 /etc/shadow
chmod 0666 /etc/gshadow 2>/dev/null || true

# --- INSEGURIDAD 7 · credencial en archivo world-writable ---------------
cat > /opt/condortech/deploy/backup.conf <<'EOF'
# Backup job heredado — SysProv Ltda. (2019)
BACKUP_TARGET=nas01.condortech.local
DB_USER=root
DB_PASSWORD=C0ndor2019!
RETENTION_DAYS=7
EOF
chmod 0666 /opt/condortech/deploy/backup.conf

# --- INSEGURIDAD 8 · cron de root que ejecuta script world-writable -----
cat > /opt/condortech/deploy/run-backup.sh <<'EOF'
#!/bin/bash
echo "[backup] $(date)" >> /var/log/ct-backup.log
EOF
chmod 0777 /opt/condortech/deploy/run-backup.sh
cat > /etc/cron.d/condortech-backup <<'EOF'
0 2 * * * root /opt/condortech/deploy/run-backup.sh
EOF
chmod 0644 /etc/cron.d/condortech-backup

# --- Herramientas de reconocimiento (ss, curl) --------------------------
# Verificado: 'ss' NO viene en todas las imagenes base de Ubuntu.
apt-get update -qq
apt-get install -y -qq iproute2 net-tools curl procps

# --- Herramientas: Lynis ------------------------------------------------
if ! apt-get install -y -qq lynis; then
  git clone -q --depth 1 https://github.com/CISOfy/lynis /opt/lynis
  ln -sf /opt/lynis/lynis /usr/local/bin/lynis
fi


# =======================================================================
#  Herramientas del laboratorio
#  El CP2 queda EXACTAMENTE como lo conocen los estudiantes: 10 controles,
#  ct-anota con evidencia libre, mismas banderas. Solo se agregan
#  ct-retomar (recuperar avance) y ct-informe (armar el informe).
# =======================================================================

cat > /usr/local/bin/ct-comun <<'COMUN'
CT_NOMBRE=( "01_permisos_shadow" "02_permisos_passwd" "03_cuentas_sin_password" "04_uid0_unico" \
            "05_ssh_permitrootlogin" "06_ssh_emptypasswords" "07_ssh_maxauthtries" "08_sudo_nopasswd" \
            "09_servicios_innecesarios" "10_cron_world_writable" )
CT_VERED=( "no_cumple" "cumple" "no_cumple" "no_cumple" "no_cumple" "no_cumple" "no_cumple" "no_cumple" "no_cumple" "no_cumple" )
CT_RELLENO=( "644" "644" "soporte" "root y sysprov" "PermitRootLogin yes" "PermitEmptyPasswords yes" \
             "MaxAuthTries 10" "deploy y soporte con NOPASSWD" "telnetd-legacy en 2323" "run-backup.sh en 777" )
CT_R=/root/respuestas
CT_F=$CT_R/02.csv
COMUN

# ------------------------------------------------------------------ ct-anota
cat > /usr/local/bin/ct-anota <<'ANOTA'
#!/bin/bash
. /usr/local/bin/ct-comun
tabla(){ awk -F';' '{printf "  %-26s %-12s %s\n", $1, $2, $3}' "$CT_F"; }
init(){
  mkdir -p "$CT_R"
  { echo "control;cumple_no_cumple;evidencia"
    for n in "${CT_NOMBRE[@]}"; do echo "$n;PENDIENTE;PENDIENTE"; done
  } > "$CT_F"
}
uso(){
cat <<'USO'
  ct-anota init                                       crea la checklist vacia
  ct-anota ver                                        muestra como va
  ct-anota <1-10> <cumple|no_cumple> "<evidencia>"    registra un control
USO
}
[ -f "$CT_F" ] || init
case "$1" in
  init) init; echo "Checklist creada en $CT_F"; tabla; exit 0;;
  ver|"")  tabla; exit 0;;
  -h|--help|ayuda) uso; exit 0;;
esac
n="$1"; v="$2"; e="$3"
case "$n" in ''|*[!0-9]*) echo "  El primer argumento es el numero de control (1 a 10)."; uso; exit 1;; esac
[ "$n" -ge 1 ] && [ "$n" -le 10 ] || { echo "  El control debe estar entre 1 y 10."; exit 1; }
[ "$v" = "cumple" ] || [ "$v" = "no_cumple" ] || { echo "  El veredicto es 'cumple' o 'no_cumple'."; exit 1; }
[ -n "$e" ] || { echo "  Falta la evidencia: pega la salida del comando entre comillas."; exit 1; }
e=$(printf '%s' "$e" | tr ';\n' ', ' | cut -c1-200)
awk -F';' -v i="$n" -v ver="$v" -v ev="$e" 'BEGIN{OFS=";"} NR==i+1{$2=ver; $3=ev} {print}' "$CT_F" > "$CT_F.tmp" && mv "$CT_F.tmp" "$CT_F"
tabla
ANOTA
chmod +x /usr/local/bin/ct-anota

# ------------------------------------------------------------------ ct-check
cat > /usr/local/bin/ct-check <<'CHECKER'
#!/bin/bash
. /usr/local/bin/ct-comun
CP="$1"
ok(){ local f="$2"
  [ -f "/root/.ct-rescate-$CP" ] && f="${2%\}}_rescate}"
  echo; echo "  [OK] $1"
  [ -f "/root/.ct-rescate-$CP" ] && echo "  (usaste el rescate: bandera de media puntuacion)"
  echo "  BANDERA CTFd -> $f"; echo; exit 0; }
no(){ echo; echo "  [PENDIENTE] $1"; echo; exit 1; }

case "$CP" in
  1)
    f="$CT_R/01.txt"
    [ -s "$f" ] || no "Crea $f con el nombre del servicio innecesario y su puerto."
    grep -qi "telnetd-legacy" "$f" || no "No veo el nombre del proceso que escucha. Revisa 'ss -tlnp'."
    grep -q "2323" "$f" || no "Falta el puerto en el que escucha ese proceso."
    ok "Reconocimiento completo: identificaste el servicio heredado." "CT{recon_servicio_heredado_2323}"
    ;;
  2)
    [ -s "$CT_F" ] || no "Aun no tienes checklist. Empieza con: ct-anota init"
    filas=$(tail -n +2 "$CT_F" | grep -c ';')
    [ "$filas" -eq 10 ] || no "Tu checklist tiene $filas controles y deben ser 10. Recrea con: ct-anota init"
    pend=$(grep -c 'PENDIENTE' "$CT_F")
    [ "$pend" -eq 0 ] || no "Quedan $pend casillas en PENDIENTE. Mira cuales con: ct-anota ver"
    shadow_real=$(stat -c '%a' /etc/shadow); passwd_real=$(stat -c '%a' /etc/passwd)
    EVI=("$shadow_real" "$passwd_real" "soporte" "sysprov" "yes" "yes" "10" "NOPASSWD" "2323" "777")
    malos=""
    for i in $(seq 1 10); do
      linea=$(sed -n "$((i+1))p" "$CT_F")
      v=$(echo "$linea" | cut -d';' -f2); e=$(echo "$linea" | cut -d';' -f3)
      if [ "$v" != "${CT_VERED[$((i-1))]}" ] || ! echo "$e" | grep -qi -- "${EVI[$((i-1))]}"; then
        malos="$malos $i"
      fi
    done
    [ -z "$malos" ] || no "Revisa estos controles:$malos. En cada uno, vuelve a correr el comando de la tabla, LEE la salida y registra el dato que la prueba."
    ok "Checklist CIS completa: veredicto y evidencia correctos en los 10 controles." "CT{linea_base_10_controles_cis}"
    ;;
  3)
    f="$CT_R/03.txt"
    [ -s "$f" ] || no "Crea $f con la ruta del archivo world-writable que guarda una credencial."
    grep -q "/opt/condortech/deploy/backup.conf" "$f" || no "Esa no es la ruta. Busca archivos con permiso de escritura para todos."
    ok "Contraste automatizado completo." "CT{credencial_en_archivo_world_writable}"
    ;;
  *) echo "  Uso: ct-check <1|2|3>";;
esac
CHECKER
chmod +x /usr/local/bin/ct-check

# ---------------------------------------------------------------- ct-retomar
cat > /usr/local/bin/ct-retomar <<'RETOMAR'
#!/bin/bash
# Recupera el avance en un entorno nuevo a partir de una bandera ya capturada.
# Para quien se quedo sin tiempo, o para quien ya termino 1 y 2 y solo quiere el 3.
. /usr/local/bin/ct-comun
f=$(printf '%s' "$1" | tr -d ' ')
if [ -z "$f" ]; then
cat <<'AYUDA'

  ct-retomar <bandera que ya capturaste>

  Pega la bandera del CP1 o del CP2 y recuperas ese avance en este entorno nuevo.
  No tienes que repetir nada. Puedes pegar las dos, una despues de la otra.

AYUDA
exit 1
fi
base=${f%_rescate\}}
if [ "$base" != "$f" ]; then base="${base}}"; res=1; else base="$f"; res=0; fi
mkdir -p "$CT_R"
case "$base" in
  "CT{recon_servicio_heredado_2323}")
      echo "servicio=telnetd-legacy puerto=2323" > "$CT_R/01.txt"; cp=1 ;;
  "CT{linea_base_10_controles_cis}")
      { echo "control;cumple_no_cumple;evidencia"
        for i in $(seq 0 9); do echo "${CT_NOMBRE[$i]};${CT_VERED[$i]};${CT_RELLENO[$i]}"; done
      } > "$CT_F"; cp=2 ;;
  "CT{credencial_en_archivo_world_writable}")
      echo "/opt/condortech/deploy/backup.conf" > "$CT_R/03.txt"; cp=3 ;;
  *)  echo; echo "  Esa bandera no es de este laboratorio."
      echo "  Revisa que la hayas copiado completa, con las llaves."; echo; exit 1 ;;
esac
[ "$res" = "1" ] && touch "/root/.ct-rescate-$cp"
echo
echo "  AVANCE RECUPERADO — Checkpoint $cp."
[ "$res" = "1" ] && echo "  (era bandera de rescate: ese checkpoint sigue valiendo la mitad)"
echo "  No tienes que repetirlo."
[ "$cp" != "3" ] && echo "  Si ya tienes la otra bandera, pegala tambien y pasas directo al Checkpoint 3."
echo
RETOMAR
chmod +x /usr/local/bin/ct-retomar

# ---------------------------------------------------------------- ct-rescate
cat > /usr/local/bin/ct-rescate <<'RESCATE'
#!/bin/bash
n="$1"
case "$n" in 1|2|3) ;; *) echo "  Uso: ct-rescate <1|2|3>"; exit 1;; esac
touch "/root/.ct-rescate-$n"
echo
echo "  RESCATE DEL CHECKPOINT $n ACTIVADO."
echo "  Este checkpoint pasa a valer la mitad de los puntos."
echo
case "$n" in
1) cat <<'EOF'
  ss -tlnp
  curl -s http://localhost:2323/LEEME.txt
  echo "servicio=telnetd-legacy puerto=2323" > /root/respuestas/01.txt
  ct-check 1
EOF
;;
2) cat <<'EOF'
  ct-anota init
  ct-anota 1  no_cumple "644"
  ct-anota 2  cumple    "644"
  ct-anota 3  no_cumple "soporte"
  ct-anota 4  no_cumple "root y sysprov"
  ct-anota 5  no_cumple "PermitRootLogin yes"
  ct-anota 6  no_cumple "PermitEmptyPasswords yes"
  ct-anota 7  no_cumple "MaxAuthTries 10"
  ct-anota 8  no_cumple "deploy y soporte con NOPASSWD"
  ct-anota 9  no_cumple "telnetd-legacy en 2323"
  ct-anota 10 no_cumple "run-backup.sh en 777"
  ct-check 2
EOF
;;
3) cat <<'EOF'
  find / -xdev -type f -perm -0002 -not -path '/proc/*' -not -path '/sys/*' -not -path '/tmp/*' -not -path '/run/*' 2>/dev/null
  cat /opt/condortech/deploy/backup.conf
  echo "/opt/condortech/deploy/backup.conf" > /root/respuestas/03.txt
  ct-check 3
EOF
;;
esac
echo
RESCATE
chmod +x /usr/local/bin/ct-rescate

# ------------------------------------------------------------------ ct-listo
cat > /usr/local/bin/ct-listo <<'LISTO'
#!/bin/bash
if [ -f /root/.ct-setup-done ]; then
  echo; echo "  ENTORNO LISTO. El servidor app-legacy-01 esta arriba."
  [ -f /var/log/lynis-report.dat ] && echo "  Lynis ya corrio en segundo plano: su reporte esta listo para el CP3."
  echo "  Puedes pasar al Checkpoint 1."
  echo "  Si vienes de una sesion anterior: ct-retomar <tu bandera>"; echo
else
  echo; echo "  TODAVIA NO. El entorno se esta preparando."
  echo "  Espera unos segundos y vuelve a correr: ct-listo"; echo
fi
LISTO
chmod +x /usr/local/bin/ct-listo

# ---------------------------------------------------------------- ct-informe
cat > /usr/local/bin/ct-informe <<'INFORME'
#!/bin/bash
# Arma el esqueleto del Informe de linea base con lo que ya levantaste.
. /usr/local/bin/ct-comun
OUT=$CT_R/informe-linea-base.md
hi=$(grep -E '^hardening_index=' /var/log/lynis-report.dat 2>/dev/null | cut -d= -f2)
{
echo "# Informe de linea base — app-legacy-01 (Condor Tech S.A.S.)"
echo
echo "Equipo: ____________________    Fecha: $(date +%Y-%m-%d)"
echo
echo "## 1. Alcance"
echo
echo "Servidor auditado: app-legacy-01 ($(lsb_release -ds 2>/dev/null || uname -sr))"
echo "Fuera de alcance: ____________________"
echo
echo "## 2. Metodo"
echo
echo "- CIS Benchmark de Ubuntu, nivel 1 — version: ____________________"
echo "- Lynis $(lynis --version 2>/dev/null | head -1) — hardening_index: ${hi:-no calculado}"
echo
echo "## 3. Tabla de hallazgos"
echo
echo "| # | Hallazgo | Evidencia | Control CIS | Tecnica ATT&CK |"
echo "|---|---|---|---|---|"
[ -s "$CT_R/01.txt" ] && echo "| R | Servicio de red no documentado | $(cat $CT_R/01.txt) | | T1046 |"
i=0
while IFS=';' read -r c v e; do
  [ "$c" = "control" ] && continue
  i=$((i+1))
  [ "$v" = "no_cumple" ] && echo "| $i | $c | $e | | |"
done < "$CT_F"
[ -s "$CT_R/03.txt" ] && echo "| C | Credencial en archivo world-writable | $(cat $CT_R/03.txt) | | T1552.001 |"
echo
echo "Completa las dos ultimas columnas: el numero del control CIS (version + numero)"
echo "y la tecnica de MITRE ATT&CK. Eso lo pones tu, no la maquina."
echo
echo "## 4. Top 3 priorizado por impacto de negocio"
echo
echo "1. ____________________  Impacto: ____________________"
echo "2. ____________________  Impacto: ____________________"
echo "3. ____________________  Impacto: ____________________"
echo
echo "## 5. Sello DIE"
echo
echo "Si este servidor fuera ganado (redesplegado desde plantilla en cada ciclo),"
echo "cuales de estos hallazgos dejarian de existir por diseno y cuales seguirian ahi?"
echo
echo "____________________"
echo
echo "## 6. Declaracion de uso de IA"
echo
echo "____________________"
} > "$OUT"
echo
echo "  Informe generado en $OUT"
echo "  COPIALO AHORA a tu documento: la maquina se borra, el informe no se salva solo."
echo
echo "  Para verlo:  cat $OUT"
echo
INFORME
chmod +x /usr/local/bin/ct-informe

# --- Lynis corre en segundo plano: el CP3 ya no espera -------------------
nohup lynis audit system --quick --quiet >/dev/null 2>&1 &

touch /root/.ct-setup-done
