# Lab 2 — La política de fw-borde (escenario Killercoda)

M�dulo 4 · Clase 5 · CIBER13 · Universidad de Montevideo. Autor: Giovanni Cruz.

---

## Despliegue

1. Repo público de GitHub, por ejemplo `killercoda-ciber13`.
2. Copia esta carpeta dentro, con el nombre `lab2-fw-borde`.
3. `git push`.
4. killercoda.com/cruzgio → **Creator** → conecta el repo. El escenario aparece solo.
5. Ábrelo una vez completo antes de clase (ver *Prueba de aceptación*).

```
killercoda-ciber13/
└── lab2-fw-borde/
    ├── index.json
    ├── intro.md  step1.md  step2.md  step3.md  finish.md
    ├── background.sh  foreground.sh
    └── assets/        ← se copia entero a /opt/ct
```

## Topología

Cuatro zonas de Cóndor Tech, cada una un espacio de red, todas colgando de `fwborde`:

| Zona | Red | Host | IP | Escucha |
|---|---|---|---|---|
| internet | 203.0.113.0/24 | api-pagos | .50 | 443 |
| dmz | 192.168.10.0/24 | tienda-01 | .10 | 443 |
| interna | 192.168.20.0/24 | erp-prod | .10 | 1433, 445 |
| usuarios | 192.168.30.0/24 | pc-contabilidad | .50 | — |

El estudiante configura la cadena **`forward`** de `fwborde`: el tráfico que cruza
entre zonas. Es exactamente la tabla origen · destino · servicio · acción ·
justificación que construyeron el lunes.

**El terminal de Killercoda vive en el espacio raíz y nunca pasa por ese firewall.**
Bloquearse es imposible, no solo barato. Esa es la decisión que elimina la fricción
clásica de este laboratorio.

## El escenario arranca con los renglones del lunes

`assets/reglas-clase4.nft` es el estado inicial y trae los renglones 10, 20 y 90
ya cargados, con la tabla en comentarios y huecos marcados para el 30, 40 y 50.

**Si el lunes quedó escrito algún renglón más, añádelo ahí: es el único sitio.**
El archivo se copia a `/root/fw-borde.nft` al arrancar, que es donde trabaja el estudiante.

## Bloques y doble nivel

| | Mínimo aceptable | Nivel completo |
|---|---|---|
| **A** | flujos 1–4 (usuarios→ERP funciona, SMB desde la DMZ cae) | los 6 |
| **B** | una regla de registro con prefijo y contador | un prefijo por regla de denegación |

Cada nivel entrega su propia bandera. `ct-retomar` acepta cualquiera de las dos del
bloque A: **quien alcanzó el mínimo entra al bloque B en igualdad de condiciones.**

## Banderas

Todas en `assets/flags.env`. Es el único archivo que hay que tocar para reutilizar
el laboratorio. En CTFd:

| Reto | Banderas válidas |
|---|---|
| Lab2-A | `CT_FLAG_A_MIN` (mínimo) · `CT_FLAG_A_FULL` (completo) · `CT_FLAG_A_RESCATE` (media) |
| Lab2-B | `CT_FLAG_B_MIN` · `CT_FLAG_B_FULL` · `CT_FLAG_B_RESCATE` |

Sugerencia de puntuación: mínimo 60 %, completo 100 %, rescate 50 %.

## Herramientas

| Comando | Qué hace |
|---|---|
| `ct-shell` | Entra a `fw-borde`. Prompt propio. |
| `ct-mapa` | Zonas, IPs y quién escucha qué. |
| `ct-probar <ori> <dst> <puerto>` | El estudiante prueba un flujo él mismo, con los mismos nombres que usa el checker. |
| `ct-check A\|B` | El auditor. Distingue mínimo de completo y explica **qué** falló. |
| `ct-regla <handle>` | El rediseño pedido tras el Lab 1: un dato estándar y único —el handle que imprime `nft -a list ruleset`— y siempre las mismas dos preguntas. |
| `ct-retomar <bandera>` | Carga la política del bloque A y habilita el B. |
| `ct-rescate A\|B` | Referencia del bloque. Media bandera. |
| `ct-informe` | Genera `/root/politica-fw-borde-condor.md`, el artefacto del Runbook. |

## Prueba de aceptación

Probada de punta a punta. Debe darte esto:

```bash
ct-check A            # arranque → falla SOLO el flujo 3 del mínimo y el 6 del completo
ct-probar usuarios erp 1433          # CAE
# añade el renglón 30 y aplica
ct-check A            # MÍNIMO ACEPTABLE 4 de 4 + bandera
# añade el renglón 40
ct-check A            # NIVEL COMPLETO 6 de 6 + bandera
ct-check B            # sin regla de log → dice exactamente qué línea falta
# añade  log prefix "CT-DENY-DEFAULT " counter
ct-check B            # MÍNIMO + bandera
# dale a la regla de SMB su propio  log prefix "CT-DENY-SMB " counter drop
ct-check B            # NIVEL COMPLETO + bandera
ct-retomar 'CT{borde_minimo_4_flujos_correctos}'   # deja fw-borde listo para el bloque B
```

## Reset sin reiniciar la sesión

```bash
bash /opt/ct/topologia.sh && bash /opt/ct/servicios.sh && : > /opt/ct/estado
```

## Decisiones de diseño

- **Sin `verify` en los pasos.** Killercoda deja avanzar siempre. Los checkpoints se
  acreditan con banderas, no con botones: bloquear el avance de quien no termina es
  justo lo que la retro pidió eliminar.
- **Los cimientos vienen puestos** (`ct state established,related accept`). No son
  parte de la política de negocio y gastarlos en clase no enseña nada nuevo.
- **El renglón 90 no se escribe**: es `policy drop`. Que lo descubran así es el punto.
- **El checker verifica comportamiento, no texto.** Da igual cómo escriban la regla
  mientras el flujo haga lo que debe.
