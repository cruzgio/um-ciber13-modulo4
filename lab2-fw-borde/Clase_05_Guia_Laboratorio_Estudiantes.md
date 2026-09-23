# Laboratorio 2 — La política de fw-borde

**Módulo 4 · Seguridad en redes y sistemas operativos · CIBER13 · Universidad de Montevideo**
Clase 5 · Miércoles 23 de septiembre de 2026 · Plataforma: Killercoda (navegador)

---

## Antes de empezar: cómo está pensado este laboratorio

Este laboratorio está partido en **dos bloques**. No son dos laboratorios distintos: son dos mitades de la misma tarea, separadas por la pausa.

| | Qué haces | Dura | Termina en |
|---|---|---|---|
| **Bloque A** | Que la tabla de flujos de tu equipo funcione | 60 min | bandera A |
| **Bloque B** | Que lo denegado deje rastro | 20 min | bandera B |

**La sesión gratuita de Killercoda dura 60 minutos.** El bloque A dura exactamente eso, así que es normal que se te acabe. No pasa nada y **no hay que repetir nada**: abres una sesión nueva y escribes

```
ct-retomar 'CT{tu-bandera-del-bloque-A}'
```

Vuelves con la política del bloque A ya cargada y sigues donde estabas. Esto es así a propósito, desde ahora y para todos los laboratorios que quedan.

### Doble nivel

Cada bloque tiene dos niveles, y **cada nivel entrega su propia bandera**:

- **Mínimo aceptable** — el aprendizaje que este laboratorio tiene que dejar sí o sí. No es un premio de consolación.
- **Nivel completo** — para quien tenga el tiempo y las ganas.

**Llegar al mínimo y parar no cuesta nota.** Solo avísalo en el foro de la clase, con una línea: en qué quedaste y dónde te trabaste. Eso me sirve más a mí que verte pelear cuarenta minutos en silencio.

Y si algo no se entiende mientras trabajas: escribe **`PAUSA`** en el chat de Teams. Paro y lo reexplico. No hace falta levantar la mano ni prender la cámara.

---

## 1. De dónde viene esto

El lunes, entre todos y en vivo, escribimos tres renglones de la política del firewall perimetral de Cóndor Tech:

| Nº | Origen | Destino | Servicio | Acción | Justificación de negocio |
|---|---|---|---|---|---|
| 10 | internet | tienda-01 (dmz) | tcp/443 | PERMITIR | la tienda es pública: 92 % de la facturación |
| 20 | tienda-01 (dmz) | erp-prod (interna) | tcp/1433 | PERMITIR | la tienda consulta stock y precios en el ERP |
| 90 | cualquiera | cualquiera | cualquiera | DENEGAR | lo que no está escrito, no pasa |

**El escenario de Killercoda arranca con esos tres renglones ya cargados.** Todos partimos del mismo punto.

Los números van de diez en diez para poder intercalar renglones nuevos sin renumerar toda la tabla. Los tuyos de hoy van a ser el 30, el 40 y el 50.

Y el renglón 90 no se escribe en ninguna línea: **es la política por defecto de la cadena**. Todo lo que no coincidió con nada, cae ahí.

---

## 2. Lo innegociable de hoy

Tres cosas. Si el laboratorio te deja solo estas tres, valió la pena. Todo lo demás que aparezca hoy es contexto.

### 1 · Gana la primera regla que coincide

Las reglas se leen de arriba hacia abajo. La primera que coincide **y es terminal** —`accept`, `drop`, `reject`— decide, y el paquete deja de leer. Un `accept` amplio arriba anula todo lo que escribas debajo: cuando la regla de abajo se evalúa, el paquete ya se fue.

Por eso lo específico va arriba y lo general abajo.

> **Hoy lo vas a ver así:** si el flujo de SMB desde la DMZ te *pasa* cuando debería caer, no te sobra una regla. Te sobra **alcance** en alguna regla de más arriba.

### 2 · Un renglón es un flujo: origen, destino, puerto

Los tres, siempre. Una regla que no dice el puerto acepta **todo** lo que venga de ese origen —base de datos, escritorio remoto, lo que haya escuchando— y gana antes de que ninguna regla de abajo pueda opinar.

> **Hoy lo vas a ver así:** el molde `ip saddr … ip daddr … tcp dport … accept` lleva las tres piezas. Si te falta una, no es una regla: es una puerta.

### 3 · Lo que se deniega, se registra

Un `drop` sin registro es un incidente invisible: el firewall protege, pero nadie sabe qué se cayó, cuándo ni por qué. Y un solo prefijo de registro te dice que *algo* se cayó; un prefijo por regla te dice **cuál regla lo tiró**.

> **Hoy lo vas a ver así:** el memo de Mariana dice que el borde registra miles de intentos por día contra un servicio que **nadie sabe cuál es**. Ese es exactamente el problema que cierras en el bloque B.

---

## 3. El escenario

Cuatro zonas de Cóndor Tech, cada una con su red, todas colgando de **fw-borde**:

```
   internet                                          usuarios
   203.0.113.0/24                                    192.168.30.0/24
   sitio-externo .50  ┐                         ┌──  pc-contabilidad .50
                      │                         │
                      └───►  fw-borde  ◄────────┘
                      ┌───►            ◄────────┐
                      │                         │
   dmz                │                         │   interna
   192.168.10.0/24    ┘                         └   192.168.20.0/24
   tienda-01 .10                                    erp-prod .10
```

| Zona | Red | Host | IP | Qué escucha |
|---|---|---|---|---|
| internet | 203.0.113.0/24 | sitio-externo | 203.0.113.50 | 443 |
| dmz | 192.168.10.0/24 | tienda-01 | 192.168.10.10 | 443 |
| interna | 192.168.20.0/24 | erp-prod | 192.168.20.10 | 1433, 445 |
| usuarios | 192.168.30.0/24 | pc-contabilidad | 192.168.30.50 | — |

fw-borde tiene una pata en cada zona (siempre el `.1`) y filtra todo lo que cruza entre ellas.

**Lo que configuras es la cadena `forward`**: el tráfico que *cruza* el firewall de una zona a otra. Es exactamente la tabla que escribiste en papel.

> **No te puedes bloquear.** El firewall que configuras no es el de tu terminal de Killercoda. Pon `policy drop` sin miedo: no vas a perder la ventana.

---

## 4. Tus herramientas

```
ct-shell                          entra a fw-borde
ct-mapa                           el mapa de zonas y quién escucha qué
ct-probar <origen> <dst> <puerto> prueba un flujo tú mismo
ct-check A | B                    el auditor externo
ct-banderas                       vuelve a mostrar tus banderas
ct-regla <handle>                 documenta un renglón
ct-retomar <bandera>              entra al bloque B sin repetir el A
ct-rescate A | B                  la referencia del bloque (media bandera)
ct-informe                        genera el artefacto del Runbook
```

Y los comandos de `nft` que vas a usar:

```
nft -c -f /root/fw-borde.nft      COMPROBAR la sintaxis, sin aplicar nada
nft -f /root/fw-borde.nft         aplicar
nft list ruleset                  ver lo cargado
nft -a list ruleset               igual, con los handles y los contadores
```

**`nft -c -f` cuesta dos segundos y te ahorra la mitad de los problemas.** Úsalo siempre antes de aplicar.

### Comandos vs. líneas de archivo

Es la confusión número uno de este laboratorio, y conviene tenerla clara desde el principio:

| | Empieza por | Dónde se escribe |
|---|---|---|
| **Comandos** | `nft`, `ct-`, o comandos de Linux (`vim`, `cat`, `ss`) | en la terminal |
| **Líneas del archivo de reglas** | `ip saddr`, `ct state`, `type filter`, `log prefix` | dentro de `/root/fw-borde.nft` |

Si pegas una línea de archivo en la terminal, Linux te va a responder algo como `Object "saddr" is unknown`. No está fallando nftables: está respondiendo el comando `ip`, que no tiene nada que ver con tu regla.

---

## 4 bis. Las banderas: cómo se ganan y dónde se suben

En CTFd hay **seis retos** para este laboratorio, tres por bloque, todos en la categoría **Lab 2**:

| Reto (categoría **Lab 2**) | Puntos | Se obtiene |
|---|---|---|
| **A Mínimo** | 3 | con los 4 flujos del mínimo |
| **A Completo** | 2 | con los 6 flujos · **se suma** a A Mínimo o A Rescate |
| **A Rescate** | 1 | igual que A Mínimo, pero habiendo usado `ct-rescate A` |
| **B Mínimo** | 2 | con el registro funcionando |
| **B Completo** | 1 | con un prefijo por regla de denegación · **se suma** a B Mínimo |
| **B Rescate** | 1 | igual que B Mínimo, pero habiendo usado `ct-rescate B` |

**No tienes que adivinar cuál es cuál.** Cuando `ct-check` te da una bandera, imprime debajo el nombre del reto al que va, y ese nombre es exactamente el que verás en CTFd.

**El nivel completo no reemplaza al mínimo: se suma.** Si llegas a los 6 flujos, `ct-check A` te entrega **dos** banderas y subes las dos, a sus dos retos. Lo mismo en el bloque B.

Las banderas se ven así:

```
CT{lab2A_minimo_83654c}
```

Son las mismas para todo el grupo: **no son personales**. Lo personal es tu cuenta de CTFd, que es donde se suben.

### Si se te pierde una bandera en el scroll

```
ct-banderas
```

Te muestra todas las de esta sesión, cada una con su reto. **Cópialas antes de cerrar la sesión**: Killercoda no guarda nada.

---

## 5. Bloque A — Que la tabla funcione

> **Antes de leer los niveles.** Lo que viene abajo **no es el tamaño de tu política**: es lo que este escenario sabe comprobar. Tu tabla tiene tantos renglones como flujos tenga el diagrama de tu equipo, y es normal que tenga más de los que el auditor verifica. Los tuyos los pruebas tú con `ct-probar`. Que el checker no verifique un renglón no significa que sobre.

### Mínimo aceptable · 35 minutos

Que estos cuatro flujos hagan lo que deben:

| Desde | Hacia | Puerto | Debe | |
|---|---|---|---|---|
| internet | tienda-01 | 443 | **pasar** | ya está (renglón 10) |
| tienda-01 | erp-prod | 1433 | **pasar** | ya está (renglón 20) |
| usuarios | erp-prod | 1433 | **pasar** | ← lo escribes tú |
| tienda-01 | erp-prod | 445 (SMB) | **caer** | |

El cuarto es el innegociable que vimos el lunes: **la DMZ es la zona que se da por perdida**. Que un servidor de la DMZ pueda hablar SMB con el ERP es exactamente el camino que un atacante quiere encontrar.

### Nivel completo · 55 minutos

Además de los cuatro anteriores:

| Desde | Hacia | Puerto | Debe |
|---|---|---|---|
| internet | erp-prod | 1433 | **caer** |
| usuarios | internet | 443 | **pasar** ← lo escribes tú |

Y **cada renglón de tu tabla** —los que el auditor comprueba y los que no— escrito, aplicado y documentado con `ct-regla`.

### Cómo se hace

**1.** Entra y mira lo que ya está:

```
ct-shell
nft list ruleset
```

Las dos primeras líneas (`ct state established,related accept` y `ct state invalid drop`) **no son renglones de la política**: son infraestructura. Dejan volver la respuesta de una conversación que el firewall ya aceptó. Sin ellas no funcionaría ni lo que está permitido.

**2.** Comprueba qué falta, tú mismo:

```
ct-probar usuarios erp 1433      → CAE. Contabilidad no puede facturar.
ct-probar usuarios internet 443  → CAE. Nadie puede abrir una web.
```

**3.** Escribe tus renglones en `/root/fw-borde.nft`. El archivo ya trae los huecos marcados. El molde es siempre el mismo:

```
ip saddr <origen> ip daddr <destino> tcp dport <puerto> accept
```

> ⚠ **Esto es una línea de archivo, no un comando.** Va dentro de `chain forward { ... }`. Si la pegas en la terminal, Linux responde `Object "saddr" is unknown, try "ip help"`: está intentando ejecutar el comando `ip`, no tu regla.
>
> Si quieres probar una regla al vuelo sin tocar el archivo, esa misma línea sí se ejecuta anteponiéndole la tabla y la cadena:
> ```
> nft add rule inet borde forward ip saddr 192.168.30.0/24 ip daddr 192.168.20.10 tcp dport 1433 accept
> ```
> Sirve para experimentar, pero no queda en el archivo — y el archivo es lo que se entrega.

Y los cuatro pedazos van en el mismo orden de la tabla:

```
ip saddr 203.0.113.0/24 ip daddr 192.168.10.10 tcp dport 443 accept
└──── origen ────────┘ └──── destino ───────┘ └─ servicio ─┘ └acción┘
```

**4.** Comprueba y aplica:

```
nft -c -f /root/fw-borde.nft && nft -f /root/fw-borde.nft
```

**5.** Documenta **mientras** escribes, no al final. Al final nunca hay tiempo.

```
nft -a list ruleset     → cada renglón lleva su  # handle N
ct-regla 8              → dos preguntas sobre el renglón del handle 8
```

**6.** El auditor:

```
ct-check A
```

**Guarda la bandera que te dé.** Con esa bandera entras al bloque B sin repetir nada.

### Si algo no funciona

| Lo que ves | Qué suele ser |
|---|---|
| `Object "saddr" is unknown, try "ip help"` | Pegaste una línea del archivo en la terminal. Va dentro de `/root/fw-borde.nft` |
| `ct-check A` dice que el flujo 3 CAE | Todavía no escribiste el renglón de usuarios hacia el ERP |
| `ct-check A` dice que el flujo 4 PASA | No te sobra una regla: te sobra **alcance** en una regla de más arriba. Busca una que no diga el puerto |
| `nft -c -f` se queja de sintaxis | Te falta un punto y coma, una llave, o escribiste `dport` sin `tcp` delante |
| Aplicas y no cambia nada | ¿Aplicaste el archivo o solo lo guardaste? `nft -f` es el que aplica |
| Llevas más de 10 minutos trabado | `ct-rescate A`. Vale media bandera y te deja seguir. Está para usarse |

---

## 6. Bloque B — Lo denegado deja rastro

Si tu sesión se acabó:

```
ct-retomar 'CT{tu-bandera-del-bloque-A}'
```

El memo de Mariana dice que el firewall del borde *«registra miles de intentos de conexión por día contra un servicio que no debería estar publicado»* — y que **nadie sabe cuál es**. Ese es el problema que cierras ahora.

### Mínimo aceptable · 10 minutos

Una línea, al final de la cadena:

```
log prefix "CT-DENY-DEFAULT " counter
```

Dos detalles que importan:

- **`log` no es terminal.** Registra el paquete y lo deja seguir, así que cae en `policy drop` como corresponde. Por eso no lleva `drop` pegado y por eso va al final.
- **`counter`** cuenta los paquetes que pasaron por esa línea. Es lo que te permite ver si la regla se está disparando sin abrir ningún archivo de log.

Aplícalo, genera un intento que deba caer y mira el contador:

```
nft -f /root/fw-borde.nft
ct-probar internet erp 1433
nft list ruleset
```

El contador subió. Esa es la diferencia entre un firewall que deniega y uno que **te cuenta** que denegó.

### Nivel completo · 20 minutos

Un solo prefijo te dice que *algo* se cayó. No te dice *cuál regla* lo tiró.

Dale a la denegación explícita de SMB su propio nombre:

```
ip saddr 192.168.10.0/24 ip daddr 192.168.20.0/24 tcp dport 445 \
    log prefix "CT-DENY-SMB " counter drop
```

Ahora tienes dos prefijos distintos. Compruébalo:

```
ct-probar tienda erp 445
nft list ruleset
```

El que subió es `CT-DENY-SMB`. Si mañana ese contador se dispara, no estás viendo ruido de internet: estás viendo **tu DMZ intentando hablar SMB con el ERP**. Eso es un incidente, y ahora tiene nombre.

### El auditor

```
ct-check B
```

---

## 7. Qué tienes que entregar

Antes de cerrar la sesión:

```
ct-informe
```

Te deja `/root/politica-fw-borde-condor.md` con tu tabla de flujos, tu ruleset y tus justificaciones.

**Copia estos dos archivos fuera de la sesión antes de cerrarla.** Killercoda no guarda nada.

| Entregable | Dónde |
|---|---|
| Todas las banderas que te dio `ct-check` | CTFd, cada una a **su** reto, en **tu** cuenta |
| `fw-borde.nft` comentado + `politica-fw-borde-condor.md` | Moodle · artefacto del Runbook |

`ct-informe` incluye al final la lista de banderas que capturaste, con su reto. Si cierras la sesión y luego no recuerdas cuál subiste, ahí están.

**Fecha sugerida: domingo 27 de septiembre.**
**Fecha límite real: domingo 18 de octubre de 2026**, sin penalización y sin tener que justificar el atraso.

La política es del equipo; las banderas son individuales.

---

## 8. Uso de inteligencia artificial

Permitido en este artefacto, **declarando su uso**: qué herramienta usaste, en qué parte, con qué finalidad y qué verificación hiciste de sus resultados.

Una advertencia práctica más que normativa: si le pides a una IA que te escriba el ruleset entero, el `ct-check` te va a decir si funciona, pero el debrief te va a preguntar *por qué* cada renglón está donde está. Esa parte no se puede delegar, y es la que se evalúa.

---

## 9. Glosario de hoy

Todos estos términos están en el glosario del módulo, en Moodle. Si alguno no está, o la definición no te sirve, **pídelo en el foro**.

`cadena` · `tabla` · `forward` · `política por defecto` · `terminal` · `handle` · `contador` · `prefijo de registro` · `saddr` · `daddr` · `dport`
