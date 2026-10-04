# A3 · Extra: una necesidad nueva y legítima (1 pt)

Desarrollo pide que el servicio escriba su bitácora. En enforce, falla:

```plain
/opt/condor/leer-config --registrar
ct-denegaciones 3
```{{exec}}

La tentación es volver a complain o abrir `/var/log/** rw,`. **No.** Mínimo privilegio también aplica a los cambios: una línea, el archivo exacto, el permiso exacto (solo escritura).

```plain
nano /etc/apparmor.d/opt.condor.leer-config
```{{exec}}

Recarga el perfil (sin `-C`: sigue en enforce) y verifica:

```plain
apparmor_parser -r /etc/apparmor.d/opt.condor.leer-config
/opt/condor/leer-config --registrar
ct-check A
```{{exec}}

Esa línea que agregaste **es** el procedimiento de cambio del estándar de contenedores: así se amplía un perfil sin romper el confinamiento.

---
¿Se acabó el tiempo del bloque A? `ct-rescate A` te deja el perfil listo y te da la bandera de rescate. El bloque B empieza en el paso siguiente y no depende de este.
