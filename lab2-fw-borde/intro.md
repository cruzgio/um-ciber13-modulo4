# Lab 2 — La política de fw-borde

**Módulo 4 · Seguridad en redes y sistemas operativos · CIBER13 · Universidad de Montevideo**

---

El lunes la clase escribió, en vivo, tres renglones de la política del firewall de Cóndor Tech. **Este escenario arranca con esos tres renglones ya cargados.** Hoy los terminas y los pones a funcionar.

## Lo innegociable de hoy

1. **Gana la primera regla que coincide.** El orden decide, no la intención.
2. **Un renglón = un flujo:** origen, destino, puerto. Si no dice el puerto, no es una regla: es una puerta.
3. **Lo que se deniega, se registra.** Un `drop` sin registro es un incidente invisible.

## Cómo está partido

| Bloque | Qué haces | Termina en |
|---|---|---|
| **A** | Completar la tabla de flujos y hacerla funcionar | bandera A |
| **B** | Que lo denegado deje rastro | bandera B |

**El bloque B no repite nada del A.** Si tu sesión de Killercoda se acaba —dura 60 minutos— abres una nueva y pegas tu bandera:

```
ct-retomar 'CT{...}'
```

Vuelves con la política del bloque A ya cargada. Nadie rehace lo que ya hizo.

## Doble nivel

Cada bloque tiene **mínimo aceptable** y **nivel completo**, y cada uno entrega su propia bandera. El mínimo no es un premio de consolación: es el aprendizaje que este laboratorio tiene que dejar. El nivel completo es para quien tenga el tiempo y las ganas.

**Si te trabas, no te quedes callado ni te quedes peleando.** Escribe `PAUSA` en el chat de Teams y paramos. O usa `ct-rescate` sin culpa: vale media bandera y te deja seguir.

## Cómo funcionan las banderas

Cuando `ct-check` te da una bandera, **te dice a qué reto de CTFd va**. El reto se llama exactamente igual que lo que aparece en pantalla. No tienes que adivinar nada.

Hay seis retos, tres por bloque, todos en la categoría **Lab 2** de CTFd:

| Reto (categoría **Lab 2**) | Puntos | Se obtiene |
|---|---|---|
| **A Mínimo** | 3 | con los 4 flujos del mínimo |
| **A Completo** | 2 | con los 6 flujos · **se suma** a A Mínimo o A Rescate |
| **A Rescate** | 1 | igual que A Mínimo, pero habiendo usado `ct-rescate A` |
| **B Mínimo** | 2 | con el registro funcionando |
| **B Completo** | 1 | con un prefijo por regla de denegación · **se suma** a B Mínimo |
| **B Rescate** | 1 | igual que B Mínimo, pero habiendo usado `ct-rescate B` |

**El nivel completo no reemplaza al mínimo: se suma.** Si llegas a los 6 flujos, `ct-check A` te entrega **dos** banderas y subes las dos.

Si se te fue una bandera en el scroll:

```
ct-banderas
```

Te vuelve a mostrar todas las de esta sesión con su reto. **Cópialas antes de cerrar**: cuando la sesión termina, se pierden.

## Tus herramientas

```
ct-shell                       entra a fw-borde
ct-mapa                        el mapa de zonas y quién escucha qué
ct-probar <ori> <dst> <puerto> prueba un flujo tú mismo
ct-check A | B                 el auditor externo
ct-banderas                    vuelve a mostrar tus banderas
ct-regla <handle>              documenta un renglón
ct-retomar <bandera>           entra al bloque B sin repetir el A
ct-rescate A | B               la referencia del bloque (media bandera)
ct-informe                     genera el artefacto del Runbook
```
