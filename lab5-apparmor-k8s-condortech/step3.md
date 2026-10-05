# A3 · Extra: una necesidad nueva y legítima (1 pt)

Desarrollo pide que el servicio escriba su bitácora en `/var/log/condor/app.log`. En enforce, falla:

```plain
/opt/condor/leer-config --registrar
ct-denegaciones 3
```{{exec}}

Lee la línea que acaba de aparecer: trae la ruta y el `requested_mask`. Con eso, **predice** qué permiso hace falta (r, w o rw) y por qué no más:

```plain
ct-predigo a3 ____
```{{copy}}

La tentación es volver a complain o abrir `/var/log/** rw,`. **No.** Mínimo privilegio también aplica a los cambios: una línea, el archivo exacto, el permiso exacto. Escríbela tú (la sintaxis es la de las otras líneas del perfil):

```plain
nano /etc/apparmor.d/opt.condor.leer-config
```{{exec}}

Recarga el perfil (sin `-C`: sigue en enforce) y verifica:

```plain
apparmor_parser -r /etc/apparmor.d/opt.condor.leer-config
/opt/condor/leer-config --registrar
/opt/condor/leer-config --secreto
ct-check A
```{{exec}}

¿`--secreto` sigue bloqueado después de tu cambio? Si no, concediste más de lo que pediste. Esa línea que agregaste **es** el procedimiento de cambio del estándar de contenedores: así se amplía un perfil sin romper el confinamiento.

---
¿Se acabó el tiempo del bloque A? `ct-rescate A` te deja el perfil listo y te da la bandera de rescate. El bloque B empieza en el paso siguiente y no depende de este.
