# A1 · El perfil en modo complain (mínimo aceptable · 2 pts)

El servicio `/opt/condor/leer-config` solo debería leer **su** configuración. Antes de ejecutarlo, léelo: ¿qué hace cada opción y cuál de ellas debería estar prohibida?

```plain
cat /opt/condor/leer-config
```{{exec}}

Ahora sí, como root y sin ningún perfil:

```plain
/opt/condor/leer-config --config
/opt/condor/leer-config --secreto
/opt/condor/leer-config --ping
```{{exec}}

Eso es **DAC** (control discrecional): root puede todo. **AppArmor** agrega **MAC** (control obligatorio): un perfil dice qué puede hacer *ese programa*, sea quien sea el usuario.

Lee la plantilla del perfil y responde para ti: ¿qué rutas concede? ¿aparece /etc/shadow? ¿aparece alguna regla de red?

```plain
cat /root/lab5/perfil-plantilla
```{{exec}}

**Predice** antes de cargarlo. Vas a cargarlo en modo **complain**: AppArmor no bloquea, solo registra lo que *habría* negado.

```plain
ct-predigo a1 ____
```{{copy}}

(La pregunta exacta te la da `ct-predigo a1` sin respuesta.) Ahora instala el perfil y cárgalo: `apparmor_parser` es el cargador de perfiles; `-r` recarga si ya existía y `-C` fuerza el modo complain.

```plain
cp /root/lab5/perfil-plantilla /etc/apparmor.d/opt.condor.leer-config
apparmor_parser -r -C /etc/apparmor.d/opt.condor.leer-config
aa-status | grep -A1 complain
```{{exec}}

Ejercita el servicio otra vez. Fíjate: ¿cambió algo respecto a la primera vez?

```plain
/opt/condor/leer-config --config; /opt/condor/leer-config --secreto; /opt/condor/leer-config --ping
```{{exec}}

Lo que cambió no se ve en la salida del programa: se ve en lo que AppArmor anotó. Lee las líneas `ALLOWED` y responde: ¿qué va a caer cuando pases a enforce?

```plain
ct-denegaciones
```{{exec}}

```plain
ct-check A
```{{exec}}
