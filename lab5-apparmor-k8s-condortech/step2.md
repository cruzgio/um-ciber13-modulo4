# A2 · Enforce: la denegación (nivel completo · 2 pts)

Pasa el perfil a **enforce**. Ahora las reglas mandan, incluso sobre root:

```plain
aa-enforce /etc/apparmor.d/opt.condor.leer-config
/opt/condor/leer-config --config
/opt/condor/leer-config --secreto
/opt/condor/leer-config --ping
```{{exec}}

`--config` debe seguir en **OK** y `--secreto` debe decir **BLOQUEADO**. Fíjate que `--ping` también cae sin que escribieras ninguna regla de red: en AppArmor **lo que no está concedido, está negado**.

La evidencia que va al artefacto es la línea `apparmor="DENIED" … name="/etc/shadow"`:

```plain
ct-denegaciones
```{{exec}}

```plain
ct-check A
```{{exec}}

> Si `--config` falla en enforce, el perfil le quitó a bash algo que necesita. `ct-denegaciones` te dice la ruta exacta y el permiso pedido: agrégalo al perfil con `nano /etc/apparmor.d/opt.condor.leer-config` y recarga con `apparmor_parser -r /etc/apparmor.d/opt.condor.leer-config`.
