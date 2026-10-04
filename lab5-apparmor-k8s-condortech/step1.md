# A1 · El perfil en modo complain (mínimo aceptable · 2 pts)

El servicio `/opt/condor/leer-config` solo debería leer **su** configuración. Como corre como root, hoy puede leer cualquier cosa:

```plain
/opt/condor/leer-config --config
/opt/condor/leer-config --secreto
/opt/condor/leer-config --ping
```{{exec}}

Eso es **DAC** (control discrecional): root puede todo. **AppArmor** agrega **MAC** (control obligatorio): un perfil dice qué puede hacer *ese programa*, sea quien sea el usuario.

Mira la plantilla del perfil (fíjate en la regla de oro del comentario):

```plain
cat /root/lab5/perfil-plantilla
```{{exec}}

Instálalo y cárgalo en **complain** con `apparmor_parser` (el cargador real del kernel; `-r` recarga, `-C` fuerza complain). En este modo AppArmor no bloquea, solo registra lo que *habría* negado. Es la red de seguridad para no romper la aplicación.

> En este nodo `aa-complain` / `aa-enforce` fallan con `ERROR: Operation {'runbindable'}…`: son utilidades en Python que leen todos los perfiles del sistema y tropiezan con uno que no entienden. `apparmor_parser` es lo que esas utilidades llaman por debajo.

```plain
cp /root/lab5/perfil-plantilla /etc/apparmor.d/opt.condor.leer-config
apparmor_parser -r -C /etc/apparmor.d/opt.condor.leer-config
aa-status | grep -A1 complain
```{{exec}}

Ejercita el servicio otra vez y lee lo que AppArmor anotó:

```plain
/opt/condor/leer-config --config; /opt/condor/leer-config --secreto; /opt/condor/leer-config --ping
ct-denegaciones
```{{exec}}

Las líneas `ALLOWED` sobre `/etc/shadow` y sobre la red son la prueba: en enforce, eso cae. Verifica y captura:

```plain
ct-check A
```{{exec}}
