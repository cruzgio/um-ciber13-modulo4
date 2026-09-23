# Cómo publicar este escenario en Killercoda

Paso a paso, desde el ZIP hasta el enlace que le pasas a los estudiantes.
Tiempo estimado: **20 minutos la primera vez, 2 minutos las siguientes.**

---

## Lo primero: cómo funciona esto

No hay editor web en Killercoda. **Un escenario es una carpeta dentro de un repositorio de GitHub.** Conectas el repo una sola vez, y a partir de ahí cada `git push` actualiza el escenario publicado en menos de un minuto.

Tú ya hiciste esto para el Lab 1, así que **lo más probable es que solo necesites el Paso 2**. Los pasos 1 y 3 son por si hay que rehacerlos.

---

## Paso 0 · Comprueba si ya tienes el repo conectado

Entra a **https://killercoda.com/creator/repository**.

- **¿Ves ahí `um-ciber13-modulo4`?** → Salta directo al **Paso 2**.
- **¿No ves nada?** → Empieza por el Paso 1.

---

## Paso 1 · Crear el repositorio (solo si no existe)

1. github.com → **New repository**
2. Nombre: `um-ciber13-modulo4`
3. Visibilidad: **Public**
4. Marca «Add a README file» → **Create repository**

> Usa un repositorio dedicado al módulo. Killercoda lee **todas** las carpetas de la raíz e intenta publicar cada una como escenario.

---

## Paso 2 · Subir la carpeta del Lab 2

Descomprime `lab2-fw-borde.zip`. Adentro hay una carpeta llamada `lab2-fw-borde`. **Esa carpeta completa va en la raíz del repo**, al lado de la del Lab 1.

El árbol tiene que quedar así:

```
um-ciber13-modulo4/
├── condortech-lab1-linea-base/     ← el Lab 1, ya estaba
│   └── ...
└── lab2-fw-borde/                  ← el Lab 2, lo que subes ahora
    ├── index.json
    ├── intro.md
    ├── step1.md  step2.md  step3.md
    ├── finish.md
    ├── background.sh
    ├── foreground.sh
    ├── README.md
    ├── DESPLIEGUE.md
    └── assets/
        ├── ct-check  ct-informe  ct-mapa  ct-probar
        ├── ct-regla  ct-rescate  ct-retomar  ct-shell
        ├── flags.env  lib.sh  registro.py
        ├── reglas-clase4.nft  ref-bloqueA.nft  ref-bloqueB.nft
        ├── servicios.sh  servicio-http.sh  topologia.sh
        └── cuerpos/   (se crea sola al arrancar)
```

### ⚠ Haz estas dos cosas ANTES de correr nada

**1 · Las banderas ya están listas.** No hay que inventarlas. `assets/flags.env` viene con los seis valores definitivos y la hoja de carga de CTFd los repite uno a uno. Solo las cambias si algún día reutilizas el lab con otra cohorte.

**2 · Los scripts necesitan permiso de ejecución.** Si no, el escenario abre bien y ningún comando `ct-*` existe. El `chmod` va incluido en el bloque de abajo — **no lo saltes**, y si subes por la web de GitHub usa la Opción B.

### Opción A — línea de comandos (recomendada)

```bash
git clone https://github.com/<tu-usuario>/um-ciber13-modulo4.git
cd um-ciber13-modulo4

# copia aquí la carpeta lab2-fw-borde/ completa (descomprimida del ZIP)

chmod +x lab2-fw-borde/background.sh lab2-fw-borde/foreground.sh
chmod +x lab2-fw-borde/assets/*

git add -A
git commit -m "Lab 2: politica de fw-borde con nftables"
git push
```

### Opción B — por la web de GitHub

«Add file → Upload files» y arrastras la carpeta. **Funciona, pero GitHub sube los scripts sin permiso de ejecución y el escenario arranca roto.** Si vas por aquí, después tienes que ejecutar esto desde cualquier terminal con git:

```bash
git clone https://github.com/<tu-usuario>/um-ciber13-modulo4.git
cd um-ciber13-modulo4
git update-index --chmod=+x lab2-fw-borde/background.sh
git update-index --chmod=+x lab2-fw-borde/foreground.sh
for f in lab2-fw-borde/assets/ct-* lab2-fw-borde/assets/*.sh lab2-fw-borde/assets/registro.py; do
  git update-index --chmod=+x "$f"
done
git commit -m "permisos de ejecucion" && git push
```

> **Este es el error número uno al desplegar escenarios de Killercoda.** Si el escenario abre pero no existe ningún comando `ct-*`, es esto.

---

## Paso 3 · Conectar el repo a Killercoda (solo la primera vez)

1. Ve a **https://killercoda.com/creator/repository**
2. Registra el repositorio: nombre del repo y rama `main`
3. Killercoda te muestra una **Deploy Key**
4. Copia esa clave y pégala en GitHub: tu repo → **Settings → Deploy keys → Add deploy key**. Acceso de **solo lectura**, no marques permiso de escritura.
5. Vuelve a Killercoda y confirma

Desde ese momento, cada `git push` se sincroniza solo.

---

## Paso 4 · Abrir y probar

Tu escenario queda en:

```
https://killercoda.com/cruzgio/scenario/lab2-fw-borde
```

**Ábrelo y corre esto en orden. Es la prueba de aceptación completa:**

```bash
ct-mapa                              # ¿aparecen las cuatro zonas?
ct-probar internet tienda 443        # PASA   (renglón 10 precargado)
ct-probar tienda erp 1433            # PASA   (renglón 20 precargado)
ct-probar usuarios erp 1433          # CAE    (esto lo escriben ellos)

ct-check A                           # falla SOLO el flujo 3 y el 6
```

Ahora simula ser un estudiante:

```bash
ct-shell
# añade a /root/fw-borde.nft el renglón 30:
#   ip saddr 192.168.30.0/24 ip daddr 192.168.20.10 tcp dport 1433 accept
nft -f /root/fw-borde.nft
ct-check A                           # → MÍNIMO ACEPTABLE 4 de 4 + bandera

# añade el renglón 40:
#   ip saddr 192.168.30.0/24 ip daddr 203.0.113.0/24 tcp dport 443 accept
nft -f /root/fw-borde.nft
ct-check A                           # → NIVEL COMPLETO 6 de 6 + bandera
```

Y el bloque B:

```bash
ct-check B                           # sin regla de log → dice qué falta

# añade al final de la cadena:
#   log prefix "CT-DENY-DEFAULT " counter
nft -f /root/fw-borde.nft
ct-check B                           # → MÍNIMO + bandera

# dale su propio prefijo a la regla de SMB:
#   ip saddr 192.168.10.0/24 ip daddr 192.168.20.0/24 tcp dport 445 \
#       log prefix "CT-DENY-SMB " counter drop
nft -f /root/fw-borde.nft
ct-check B                           # → NIVEL COMPLETO + bandera
```

Por último, la recuperación:

```bash
ct-retomar 'CT{...tu bandera A...}'  # deja fw-borde listo para el bloque B
```

**Si los ocho comandos hacen lo que dice arriba, el escenario está listo para los 18.**

Atajo: si no quieres teclear los renglones, `ct-rescate A` y `ct-rescate B` te los aplican solos.

---

## Paso 5 · Cargar los retos en CTFd

**Seis retos, tres por bloque, en la categoría `Lab 2`** — misma convención de nombres cortos y puntuación 1-3 que ya usas en Lab 1 y Clase 3.

| Reto (categoría **Lab 2**) | Puntos | Bandera |
|---|---|---|
| A Mínimo | 3 | `CT{lab2A_minimo_83654c}` |
| A Completo | 2 | `CT{lab2A_completo_7d5650}` |
| A Rescate | 1 | `CT{lab2A_rescate_bfc8a7}` |
| B Mínimo | 2 | `CT{lab2B_minimo_c70a29}` |
| B Completo | 1 | `CT{lab2B_completo_c5fe32}` |
| B Rescate | 1 | `CT{lab2B_rescate_44c25f}` |

Lo más rápido: **Admin → Challenges → Import CSV** con `CTFd_Lab2_Retos.csv`.

Todos: tipo **Standard**, bandera **estática**, **sensible a mayúsculas**, como en el Lab 1.

**Por qué tres retos por bloque y no uno con varias respuestas:** en CTFd un reto da los mismos puntos sin importar cuál de sus banderas aciertes. Si el mínimo y el completo compartieran reto, valdrían igual y el doble nivel no significaría nada.

**El nombre del reto es la clave de todo.** `ct-check` imprime la bandera **y el nombre del reto al que va**, idéntico al de CTFd. El estudiante no tiene que interpretar nada.

## Si algo falla

| Síntoma | Causa casi segura | Qué haces |
|---|---|---|
| El escenario no aparece en tu perfil | El repo no está conectado, o la carpeta no está en la raíz | Paso 3, y revisa el árbol del Paso 2 |
| Abre, pero `ct-mapa` dice «command not found» | Los scripts se subieron sin permiso de ejecución | El bloque `git update-index --chmod=+x` de la Opción B |
| Abre, pero `ct-probar` dice que el escenario se está montando | `background.sh` aún corriendo, o falló | Espera 30 s. Si sigue: `cat /var/log/ct-background.log` |
| `ct-check` da resultados raros | Los servicios no levantaron | `bash /opt/ct/servicios.sh` y reintenta |
| Quieres empezar de cero sin reiniciar la sesión | — | `bash /opt/ct/topologia.sh && bash /opt/ct/servicios.sh && : > /opt/ct/estado` |
| Un alumno perdió su bandera en el scroll | La sesión aún abierta | `ct-banderas` se las vuelve a mostrar con su reto |
| Un alumno cerró la sesión sin copiar la bandera | Killercoda no guarda nada | Que rehaga el bloque, o dale tú la bandera: son seis valores fijos, no son por alumno |
| Cambiaste algo y no se refleja | Killercoda tarda hasta un minuto en sincronizar | Espera y recarga. Comprueba que el push llegó a GitHub |

El registro del montaje siempre está en **`/var/log/ct-background.log`** dentro del escenario. La sección **Creator Debug** de Killercoda también muestra errores de los scripts de fondo.

---

## Para los próximos labs

Ya con el repo conectado, publicar el Lab 3 es:

```bash
# copiar la carpeta lab3-... al repo
chmod +x lab3-.../background.sh lab3-.../assets/*
git add -A && git commit -m "Lab 3" && git push
```

Y nada más. Una carpeta por laboratorio, todas en la raíz del repo, cada una con su propio enlace limpio.
