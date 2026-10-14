# Paso 4 — Bloque B: recuperar el ERP

Inyecto 6: el atacante está contenido. Hay que volver a tener el ERP. Tienes dos copias posibles:

- `/srv/respaldo/erp`: la copia nocturna del **nas-backup**, en la misma sala.
- La **copia inmutable** que dejaste en la Clase 12, publicada otra vez donde la dejaste.

Si acabas de abrir una sesión nueva, primero:

```
ct-listo
```{{exec}}

## 1. Prueba la copia del nas-backup

```
restic -r /srv/respaldo/erp snapshots
```{{exec}}

¿Qué pasó? Míralo también en las evidencias (`ct-buscar nas-backup`).

## 2. Predice antes de actuar

¿Desde qué copia vas a poder restaurar? Elige una de las tres opciones (escribes solo el número):

```
ct-predigo b
```{{exec}}

## 3. Arranca el reloj y restaura

```
ct-cronometro
```{{exec}}

El comando de restauración **lo armas tú**: es el mismo que usaste el jueves 8 en la segunda ola, con destino `/srv/restaurado`. restic te va a pedir la llave: es **la tuya de la Clase 12**. Este escenario no la tiene.

¿Trabado? `ct-pista b` (razonamiento) · `ct-pista b comando` (el comando completo)

## 4. Valida, mide y certifica

```
ct-rto
```{{exec}}

`ct-rto` compara archivo por archivo contra el ERP original, te muestra tu predicción junto a lo que pasó, calcula tu RTO y escribe `/root/certificado-restauracion-eldia.txt`. El **Líder pega el certificado en la Bitácora**.

> Restaurar en limpio: en la vida real, esto se hace sobre un servidor reconstruido, nunca sobre el comprometido. «Aquí no criamos mascotas».

Sin llave: `ct-rescate B` muestra la secuencia completa y entrega solo la bandera de rescate. Sin llave no hay restauración: eso también se registra.
