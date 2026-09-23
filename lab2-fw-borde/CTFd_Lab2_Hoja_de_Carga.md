# CTFd · Hoja de carga del Lab 2

**Módulo 4 · CIBER13 · Clase 5.** Copiar y pegar. No hay que inventar ninguna bandera: ya están generadas y el escenario las entrega tal cual.

---

## Cómo está pensado

Seis retos, tres por bloque. La razón de que sean tres y no uno con varias respuestas es simple: **en CTFd un reto da los mismos puntos sin importar cuál de sus banderas aciertes.** Si el mínimo y el completo estuvieran en el mismo reto, valdrían igual, y el doble nivel dejaría de significar nada.

Con tres retos por bloque:

- Quien llega al **mínimo** sube una bandera y se lleva los puntos del mínimo.
- Quien llega al **completo** recibe **dos** banderas del `ct-check` y sube las dos: los puntos se suman.
- Quien usó **`ct-rescate`** recibe la bandera de rescate en lugar de la del mínimo, y vale menos. Si además llega al completo, el bonus lo cobra igual.

Esto es exactamente el mecanismo de dos banderas que ya usaste en el Lab 1, extendido al doble nivel.

| Camino del estudiante | Retos que resuelve | Puntos |
|---|---|---|
| Bloque A al mínimo | A-mínimo | 90 |
| Bloque A al completo | A-mínimo + A-completo | 150 |
| Bloque A con rescate | A-rescate | 45 |
| Bloque A con rescate y llega al completo | A-rescate + A-completo | 105 |
| Bloques A y B, ambos al completo | los cuatro | 250 |

---

## Los seis retos

Todos: tipo **Standard**, bandera **estática**, **sensible a mayúsculas**, categoría **Lab 2 · Firewall**.

### 1 · Lab 2 · Bloque A — mínimo aceptable

- **Puntos:** 90
- **Bandera:** `CT{lab2A_minimo_83654c}`
- **Descripción:**
  > Los cuatro flujos que Cóndor Tech no puede no tener funcionando en fw-borde: la tienda vendiendo, la tienda hablando con el ERP, contabilidad facturando, y SMB sin cruzar desde la DMZ. La entrega `ct-check A`.

### 2 · Lab 2 · Bloque A — con rescate

- **Puntos:** 45
- **Bandera:** `CT{lab2A_rescate_bfc8a7}`
- **Descripción:**
  > El mismo resultado del bloque A, alcanzado con `ct-rescate A`. Vale la mitad y está bien usarlo: media bandera vale más que veinte minutos trabado.

### 3 · Lab 2 · Bloque A — nivel completo

- **Puntos:** 60
- **Bandera:** `CT{lab2A_completo_7d5650}`
- **Descripción:**
  > Los seis flujos, incluida la salida web del personal y el ERP inalcanzable desde internet. Se suma a la bandera del mínimo o a la de rescate.

### 4 · Lab 2 · Bloque B — mínimo aceptable

- **Puntos:** 60
- **Bandera:** `CT{lab2B_minimo_c70a29}`
- **Descripción:**
  > Lo que se deniega en fw-borde deja rastro: una regla de registro con prefijo y contador, disparándose de verdad. La entrega `ct-check B`.

### 5 · Lab 2 · Bloque B — con rescate

- **Puntos:** 30
- **Bandera:** `CT{lab2B_rescate_44c25f}`
- **Descripción:**
  > El mismo resultado del bloque B, alcanzado con `ct-rescate B`.

### 6 · Lab 2 · Bloque B — nivel completo

- **Puntos:** 40
- **Bandera:** `CT{lab2B_completo_c5fe32}`
- **Descripción:**
  > Un prefijo de registro distinto por cada regla de denegación, de modo que el log no diga solo que algo se cayó, sino qué regla lo tiró. Se suma a la del mínimo.

---

## Cómo se leen las banderas

```
CT{ lab2A _ minimo _ 83654c }
     │       │        └── token, para que no se adivinen
     │       └── qué nivel alcanzó
     └── qué laboratorio y qué bloque
```

El estudiante nunca tiene que interpretarlas: `ct-check` imprime la bandera **y el nombre del reto al que va**, y ese nombre es idéntico al de CTFd. Si se le pierde en el scroll, `ct-banderas` se las vuelve a mostrar todas.

---

## Si algún día reutilizas el lab

Cambia **solo el token de seis caracteres** del final de cada bandera en `assets/flags.env`, haz push, y actualiza los seis retos en CTFd. El resto —nombres de reto, estructura, puntos— no se toca.

Para generar tokens nuevos:

```bash
for n in 1 2 3 4 5 6; do openssl rand -hex 3; done
```

---

## Verificación antes de clase

Abre el escenario y comprueba que los seis valores que imprime coinciden con los seis que cargaste:

```bash
ct-rescate A          # responde "s"
ct-check A            # debe dar la de rescate + la de completo
ct-rescate B          # responde "s"
ct-check B            # debe dar la de rescate + la de completo
ct-banderas           # las lista todas con su reto
```

Y en una sesión limpia, sin rescates, para ver las del mínimo:

```bash
ct-check A            # tras escribir los renglones 30 y 40
ct-check B            # tras escribir las dos reglas de registro
```

Si los seis strings coinciden, CTFd está bien cargado.
