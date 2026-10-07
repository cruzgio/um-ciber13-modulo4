# A2 · Enforce: la denegación (nivel completo · 2 pts)

**Predice** primero: en enforce, ¿`--secreto` va a poder leer /etc/shadow? Decide mirando el perfil, no adivinando.

```plain
ct-predigo a2 ____
```{{copy}}

Pasa el perfil a **enforce**: sin `-C`, el perfil se carga tal como está escrito. Ahora las reglas mandan, incluso sobre root.

```plain
apparmor_parser -r /etc/apparmor.d/opt.condor.leer-config
aa-status | grep -B1 -A1 leer-config
```{{exec}}

Prueba los dos, uno por uno, y compara con tu predicción:

```plain
/opt/condor/leer-config --config
```{{exec}}

```plain
/opt/condor/leer-config --secreto
```{{exec}}

La evidencia que va al artefacto es la línea `apparmor="DENIED" … name="/etc/shadow"`. Mira el campo `fsuid`: ¿qué te dice?

```plain
ct-denegaciones
```{{exec}}

```plain
ct-check A
```{{exec}}

> Si `--config` falla en enforce, el perfil le quitó a bash algo que necesita. `ct-denegaciones` te dice la ruta exacta y el permiso pedido: agrégalo al perfil con `nano /etc/apparmor.d/opt.condor.leer-config` y recarga con `apparmor_parser -r /etc/apparmor.d/opt.condor.leer-config`.
