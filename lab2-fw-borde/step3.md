# Bloque B · Lo denegado deja rastro

**20 minutos**

Si la sesión anterior se acabó, no rehagas nada:

```
ct-retomar 'CT{...}'
```{{copy}}

---

En el firewall de Cóndor Tech, hoy, cuando algo se cae no queda registro de nada. El memo de Mariana dice que el borde *«registra miles de intentos contra un servicio que no debería estar publicado»* — y que **nadie sabe cuál es**. Ese es el problema que cierras ahora.

## Mínimo aceptable — 10 minutos

Una línea, al final de la cadena, antes de que actúe la política por defecto:

```
log prefix "CT-DENY-DEFAULT " counter
```{{copy}}

> Recuerda: **línea de archivo, no comando.** Va dentro de `chain forward { ... }`.

Dos detalles que importan:

- **`log` no es terminal.** Registra el paquete y lo deja seguir, así que cae en `policy drop` como corresponde. Por eso no lleva `drop` pegado.
- **`counter`** cuenta los paquetes que pasaron por esa línea. Es lo que te permite ver, sin abrir ningún archivo, si la regla se está disparando.

Aplícalo y míralo:

```
nft -f /root/fw-borde.nft && nft -a list ruleset
```{{exec}}

Genera un intento que debe caer y vuelve a mirar el contador:

```
ct-probar internet erp 1433
```{{exec}}

```
nft list ruleset
```{{exec}}

El contador subió. Eso es la diferencia entre un firewall que deniega y uno que **te cuenta** que denegó.

## Nivel completo — 10 minutos más

Un solo prefijo te dice *que* algo se cayó. No te dice *cuál regla* lo tiró.

Dale a la denegación explícita de SMB su propio nombre:

```
ip saddr 192.168.10.0/24 ip daddr 192.168.20.0/24 tcp dport 445 \
    log prefix "CT-DENY-SMB " counter drop
```{{copy}}

Ahora tienes dos prefijos distintos. Compruébalo:

```
ct-probar tienda erp 445
```{{exec}}

```
nft list ruleset
```{{exec}}

El que subió es `CT-DENY-SMB`. Si mañana ese contador se dispara, no estás viendo ruido de internet: estás viendo **tu DMZ intentando hablar SMB con el ERP**. Eso es un incidente, y ahora tiene nombre.

## El auditor

```
ct-check B
```{{exec}}

## Antes de cerrar

Recupera todas tus banderas de la sesión y cópialas a un sitio seguro:

```
ct-banderas
```{{exec}}


```
ct-informe
```{{exec}}

Te deja `/root/politica-fw-borde-condor.md` con tu tabla de flujos, tu ruleset y tus justificaciones. **Cópialo fuera de la sesión ahora**: junto con `/root/fw-borde.nft` es el artefacto que va al Runbook.
