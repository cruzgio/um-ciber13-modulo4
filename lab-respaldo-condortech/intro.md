# Misión de respaldo — Cóndor Tech S.A.S.

> *El CISO reúne al equipo: «Los indicadores sugieren que alguien nos estudia. Quiero respaldos que un atacante no pueda tocar y un plan escrito para el peor día».*

Hoy vas a proteger el ERP de Cóndor Tech con **restic**: un respaldo cifrado, una pérdida simulada, una restauración con el reloj corriendo (tu primer **RTO real**) y, en el Bloque B, una copia que ni siquiera un atacante con tus credenciales puede borrar.

## Doble nivel (ambos valen)

| Nivel | Qué logras | Tiempo real | Bandera |
|---|---|---|---|
| **A Mínimo** | Repositorio cifrado + primer respaldo | ~10 min | `ct-check a1` (2 pts) |
| **A Completo** | Restaurar tras el ataque, hash idéntico, RTO medido + certificado | ~15 min | `ct-rto` (2 pts) |
| **B Inmutable** | Copia *append-only* que resiste el borrado | ~15 min | `ct-check b1` (2 pts) |
| Rescate A / B | El escenario lo hace por ti, paso a paso | — | `ct-rescate A` / `B` (1 pt) |

**Regla de tiempo:** si llevas más del doble del tiempo indicado, para, escribe `PAUSA` en el chat de Teams y usa `ct-rescate`. Parar no cuesta nota.

## Antes de empezar

El escenario se prepara solo durante 2–3 minutos (descarga restic y rest-server). Mientras tanto:

```
ct-listo
```{{exec}}

Cuando todo esté en verde:

```
ct-mapa
```{{exec}}

> La **llave de cifrado** de Cóndor Tech está en `/root/llave-condortech.txt` y todos los comandos la pasan con `-p`. No inventes una contraseña propia: el auditor y la simulación de la Clase 13 abren el repositorio con esa llave. Fíjate dónde vive: **fuera** del repositorio. Anótala:

```
cat /root/llave-condortech.txt
```{{exec}}
