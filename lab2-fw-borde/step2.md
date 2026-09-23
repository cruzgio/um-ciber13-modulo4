# Bloque A · Escribe tus renglones

**Mínimo aceptable: 25 min · Nivel completo: 40 min**

## Lo que tiene que quedar funcionando

**Mínimo aceptable** — cuatro flujos:

| Desde | Hacia | Puerto | Debe |
|---|---|---|---|
| internet | tienda-01 | 443 | **pasar** *(ya está)* |
| tienda-01 | erp-prod | 1433 | **pasar** *(ya está)* |
| usuarios | erp-prod | 1433 | **pasar** ← tú |
| tienda-01 | erp-prod | 445 · SMB | **caer** |

**Nivel completo** — además:

| Desde | Hacia | Puerto | Debe |
|---|---|---|---|
| internet | erp-prod | 1433 | **caer** |
| usuarios | internet | 443 | **pasar** ← tú |

El SMB desde la DMZ es el innegociable de la clase 4: la DMZ es la zona que se da por perdida. Que un servidor de la DMZ pueda hablar SMB con el ERP es exactamente el camino que un atacante quiere.

## La forma de un renglón

```
ip saddr <origen> ip daddr <destino> tcp dport <puerto> accept
```{{copy}}

Un renglón, un flujo. Origen, destino, puerto. Los tres, siempre.

Las direcciones que necesitas:

```
internet   203.0.113.0/24      sitio-externo 203.0.113.50
dmz        192.168.10.0/24     tienda-01     192.168.10.10
interna    192.168.20.0/24     erp-prod      192.168.20.10
usuarios   192.168.30.0/24     pc-conta      192.168.30.50
```{{copy}}

## Escribe

Tu archivo ya tiene los huecos marcados:

```
vim /root/fw-borde.nft
```{{copy}}

> El editor de la izquierda también sirve. Abre `/root/fw-borde.nft` desde ahí si prefieres.

Comprueba la sintaxis **antes** de aplicar. Cuesta dos segundos:

```
nft -c -f /root/fw-borde.nft
```{{exec}}

Y entonces sí:

```
nft -f /root/fw-borde.nft
```{{exec}}

## Cuidado con el orden

Gana la primera regla que coincide y es terminal (`accept`, `drop`, `reject`). Si aceptas de más arriba, lo que escribas debajo no se evalúa nunca.

La trampa clásica: una regla que solo dice `ip saddr` y no dice puerto acepta **todo** lo que venga de esa red. Si el flujo 4 (SMB) te pasa cuando debería caer, no te sobra una regla: te sobra **alcance** en una regla de más arriba.

## Documenta mientras escribes

No al final. Al final nunca hay tiempo.

```
nft -a list ruleset
```{{exec}}

Cada renglón lleva su `# handle N`. Con ese número:

```
ct-regla 8
```{{copy}}

Dos preguntas, las mismas siempre: qué flujo habilita y qué pasaría en Cóndor Tech si no estuviera.

## El auditor

```
ct-check A
```{{exec}}

Te va a dar **una bandera si llegaste al mínimo, y dos si llegaste al completo** — la del mínimo se suma con la de completo, no la reemplaza. Cada una dice a qué reto de CTFd va.

Cópialas ya. Si se te pierden en el scroll:

```
ct-banderas
```{{exec}}

**Con la bandera del bloque A entras al bloque B sin repetir nada.**
