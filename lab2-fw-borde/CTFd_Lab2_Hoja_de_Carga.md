# CTFd · Hoja de carga del Lab 2

**Módulo 4 · CIBER13 · Clase 5.** Sigue la convención que ya usas: categoría por laboratorio, nombres cortos, puntuación de 1 a 3.

Lo más rápido: **Admin → Challenges → Import CSV** con `CTFd_Lab2_Retos.csv`. Abajo están los mismos seis por si prefieres cargarlos a mano.

---

## Los seis retos

Categoría: **Lab 2** · tipo **Standard** · bandera **estática** y **sensible a mayúsculas** · estado **visible**.

| Reto | Puntos | Bandera |
|---|---|---|
| **A Mínimo** | 3 | `CT{lab2A_minimo_83654c}` |
| **A Completo** | 2 | `CT{lab2A_completo_7d5650}` |
| **A Rescate** | 1 | `CT{lab2A_rescate_bfc8a7}` |
| **B Mínimo** | 2 | `CT{lab2B_minimo_c70a29}` |
| **B Completo** | 1 | `CT{lab2B_completo_c5fe32}` |
| **B Rescate** | 1 | `CT{lab2B_rescate_44c25f}` |

Máximo alcanzable: **8 puntos** (3 + 2 + 2 + 1). Comparable al Lab 1, que suma 7.

### Descripciones

**A Mínimo.** Los cuatro flujos que Cóndor Tech no puede no tener, funcionando en fw-borde: la tienda vendiendo, la tienda hablando con el ERP, contabilidad facturando, y SMB sin cruzar desde la DMZ. La bandera la entrega `ct-check A`.

**A Completo.** Los seis flujos: además de los cuatro del mínimo, la salida de la tienda a la pasarela de pagos y el ERP inalcanzable desde internet. **Se suma** a A Mínimo o a A Rescate; no la reemplaza.

**A Rescate.** El mismo resultado del bloque A, alcanzado con `ct-rescate A`. Está bien usarlo: media bandera vale más que veinte minutos trabado.

**B Mínimo.** Lo que se deniega en fw-borde deja rastro: una regla de registro con prefijo y contador, disparándose de verdad. La bandera la entrega `ct-check B`.

**B Completo.** Un prefijo de registro distinto por cada regla de denegación, para que el log no diga solo que algo se cayó sino qué regla lo tiró. **Se suma** a B Mínimo.

**B Rescate.** El mismo resultado del bloque B, alcanzado con `ct-rescate B`.

---

## Por qué tres retos por bloque y no uno con varias respuestas

En CTFd **un reto da los mismos puntos sin importar cuál de sus banderas aciertes.** Si el mínimo y el completo compartieran reto, valdrían igual y el doble nivel dejaría de significar algo.

Con tres retos por bloque:

- Quien llega al **mínimo** sube una bandera.
- Quien llega al **completo** recibe **dos** banderas de `ct-check` y sube las dos: los puntos se suman.
- Quien usó **rescate** recibe la de rescate en lugar de la del mínimo. Si además llega al completo, cobra el bonus igual.

Es el mismo mecanismo de dos banderas del Lab 1 (`CP1` / `CP1 Rescate`), extendido al doble nivel.

| Camino del estudiante | Retos que resuelve | Puntos |
|---|---|---|
| Bloque A al mínimo | A Mínimo | 3 |
| Bloque A al completo | A Mínimo + A Completo | 5 |
| Bloque A con rescate | A Rescate | 1 |
| Bloque A con rescate, llegando al completo | A Rescate + A Completo | 3 |
| Los dos bloques al completo | los cuatro | 8 |

---

## Cómo se leen las banderas

```
CT{ lab2A _ minimo _ 83654c }
      │        │        └── token, para que no se adivinen
      │        └── qué nivel alcanzó
      └── qué laboratorio y qué bloque
```

El estudiante nunca tiene que interpretarlas. `ct-check` imprime la bandera y debajo:

```
En CTFd: categoría «Lab 2» → reto «A Mínimo»
```

Ese nombre es idéntico al de CTFd. Y si se le pierde en el scroll, `ct-banderas` se las vuelve a mostrar todas.

---

## Verificación antes de clase

En el escenario publicado, comprueba que los seis strings coinciden con los seis cargados:

```bash
ct-rescate A          # responde "s"
ct-check A            # A Rescate + A Completo
ct-rescate B          # responde "s"
ct-check B            # B Rescate + B Completo
ct-banderas           # las lista todas con su reto
```

Y en una sesión limpia, sin rescates, para ver las del mínimo:

```bash
ct-check A            # tras escribir los renglones 30 y 40
ct-check B            # tras escribir las dos reglas de registro
```

---

## Si algún día reutilizas el lab

Cambia **solo el token de seis caracteres** del final de cada bandera en `assets/flags.env`, haz push, y actualiza los seis retos en CTFd. Nombres, categoría y puntos no se tocan.

```bash
for n in 1 2 3 4 5 6; do openssl rand -hex 3; done
```
