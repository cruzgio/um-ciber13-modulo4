# EL DÍA — Lab 7 · Cóndor Tech S.A.S.

05:47: los archivos del ERP amanecieron cifrados y hay una nota de rescate. Este escenario es el **componente técnico** de la simulación. Lo opera el rol **Técnico** de cada equipo; el resto del equipo trabaja la Bitácora en paralelo.

**Dos bloques independientes** (no hace falta terminar A para hacer B):

- **Bloque A — Evidencias (inyecto 3, ~18:45):** paciente cero, cuenta comprometida, IP de C2 y nombre de la nota → banderas 13.1–13.4 en el CTFd (categoría «Clase 13»).
- **Bloque B — Restauración (inyecto 6, ~20:05):** el repositorio de Cóndor Tech ya está montado. Solo falta **tu llave de la Clase 12**. `ct-rto` valida la integridad y emite el certificado.

La sesión de Killercoda dura 60 min: si venció antes del inyecto 6, **vuelve a lanzar el escenario** y ve directo al Paso 4. No pierdes nada: las banderas de A ya están en el CTFd.

Empieza con `ct-listo` y `ct-mapa`. Si te atascas: `ct-pista <id>` o `ct-rescate A|B`.
