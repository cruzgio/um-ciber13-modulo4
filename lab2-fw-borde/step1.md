# Bloque A · Lo que ya está y lo que falta

**15 minutos**

## Mira el terreno

```
ct-mapa
```{{exec}}

Cuatro zonas alrededor de **fw-borde**. Todo lo que cruza de una zona a otra pasa por la cadena `forward` del firewall: eso es lo que vas a escribir.

**Las zonas ya están montadas: nadie las crea ni las modifica.** Lo único que escribes son los renglones que cruzan entre ellas.

Entra al firewall:

```
ct-shell
```{{exec}}

## Lo que escribimos el lunes

```
nft list ruleset
```{{exec}}

Ahí están, ya cargados:

| Nº | Origen | Destino | Servicio | Acción |
|---|---|---|---|---|
| 10 | internet | tienda-01 (dmz) | tcp/443 | PERMITIR |
| 20 | tienda-01 (dmz) | erp-prod (interna) | tcp/1433 | PERMITIR |
| 90 | cualquiera | cualquiera | cualquiera | DENEGAR |

Las dos primeras líneas del ruleset (`ct state established,related accept` y `ct state invalid drop`) **no son renglones de la política**: son infraestructura. Dejan volver la respuesta de una conversación que el firewall ya aceptó. Sin ellas nada funcionaría, ni siquiera lo permitido.

El renglón 90 no se escribe: **es la política por defecto de la cadena**, `policy drop`.

## Compruébalo tú mismo

```
ct-probar internet tienda 443
```{{exec}}

```
ct-probar tienda erp 1433
```{{exec}}

Ahora mira lo que todavía no funciona:

```
ct-probar usuarios erp 1433
```{{exec}}

Contabilidad no puede facturar. Ese es el flujo que falta, y no es el único.

```
ct-probar tienda pagos 443
```{{exec}}

La tienda no puede cobrar: no alcanza la pasarela de pagos.

## Una confusión que conviene evitar ya

Todo lo que empieza por `ip saddr`, `ct state`, `type filter` o `log prefix` son **líneas del archivo de reglas**, no comandos de la terminal. Si pegas una de esas líneas en la terminal, Linux responde algo como `Object "saddr" is unknown` — está intentando ejecutar el comando `ip`, que no tiene nada que ver.

Los comandos de verdad empiezan por `nft`, `ct-` o son de Linux (`vim`, `cat`, `ss`).

## Antes de seguir

Los números van de diez en diez —10, 20, 90— por una razón: así se intercala un renglón nuevo sin renumerar toda la tabla. Tus renglones van a ser el 30, el 40 y el 50.
