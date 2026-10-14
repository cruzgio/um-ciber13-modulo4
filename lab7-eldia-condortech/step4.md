## Paso 4 — Bloque B · Restaurar con tu llave y validar

El inyecto 6 dice: *el repositorio inmutable de Cóndor Tech está disponible*. Está en `/srv/respaldo/erp` y lo hizo tu equipo el jueves 8. **El escenario no tiene la llave**: es la de `/root/llave-condortech.txt` de la Clase 12.

Si acabas de relanzar el escenario, primero:

```bash
ct-listo
```{{exec}}

Mira el estado: originales cifrados, repositorio presente:

```bash
ls /srv/erp
restic -r /srv/respaldo/erp snapshots
```{{exec}}

Arranca el cronómetro y restaura (restic te pide la llave):

```bash
ct-cronometro
restic -r /srv/respaldo/erp restore latest --target /srv/restaurado
```{{exec}}

Valida integridad, mide el RTO y obtén el certificado:

```bash
ct-rto
```{{exec}}

`ct-rto` compara archivo por archivo contra los hashes conocidos, calcula tu RTO y escribe `/root/certificado-restauracion-eldia.txt`. El **Líder pega el certificado en la Bitácora** (vale los 2 puntos de restauración validada) y el Técnico envía la bandera 13.5 desde el CTFd.

Sin llave: `ct-rescate B` muestra la secuencia completa y entrega solo la bandera de rescate. Sin llave no hay restauración: eso también se registra.
