# Lab 2 completado

## Lo que capturaste

| Reto de CTFd | Qué demuestra |
|---|---|
| Bloque A — mínimo aceptable | Los cuatro flujos que Cóndor Tech no puede no tener |
| Bloque A — nivel completo | Los seis, incluida la salida del personal |
| Bloque B — mínimo aceptable | Lo denegado deja rastro |
| Bloque B — nivel completo | El log dice **qué regla** lo tiró |

Cada bandera va al reto que lleva ese mismo nombre. Si usaste `ct-rescate`, la tuya va al reto «con rescate» del bloque correspondiente.

**Antes de cerrar la sesión:** `ct-banderas` te las muestra todas otra vez.

## Llévate estos dos archivos

- `/root/fw-borde.nft` — la política como código, comentada
- `/root/politica-fw-borde-condor.md` — el procedimiento que genera `ct-informe`

Los dos juntos son el artefacto de esta clase y entran al **Runbook de Cóndor Tech**.

**Fecha sugerida: domingo 27-sep. Fecha límite real: domingo 18-oct-2026**, sin penalización y sin justificar el atraso.

## Lo innegociable, otra vez

1. Gana la primera regla que coincide.
2. Un renglón = un flujo: origen, destino, puerto.
3. Lo que se deniega, se registra.

## El sello DIE — Immutable

El firewall no se arregla a mano en producción. Se corrige el archivo y se vuelve a aplicar. Por eso el entregable es el archivo y no la máquina.

## Alcance honesto

Esto filtra el tráfico que cruza entre zonas de la **Zona A** de Cóndor Tech. La Zona B —la tienda en la nube— se filtra con grupos de seguridad del proveedor: misma lógica, pero se aplica antes de que el paquete llegue a la máquina y se declara en el repositorio. Lo auditamos en la clase 10.

## Mañana

Un usuario reporta que *«la red anda rara algunas mañanas»*. Abrimos la captura de esa mañana.
