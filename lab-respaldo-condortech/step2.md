# Bloque A · Paso 2 — El peor día: restaurar y medir el RTO

## 1. Lanza el ataque simulado

Este comando cifra los archivos del ERP, borra los originales y deja la nota de rescate. **Arranca el cronómetro del RTO.**

```
ct-ransom
```{{exec}}

Mira lo que quedó:

```
ls -R /srv/condortech/erp; cat /srv/condortech/erp/NOTA_DE_RESCATE.txt
```{{exec}}

## 2. Restaura desde el respaldo

Sin pagar, sin negociar. Restaura el último snapshot en la zona de restauración:

```
restic -r /srv/respaldo/erp -p /root/llave-condortech.txt restore latest --target /srv/restaurado
```{{exec}}

(restic conserva la ruta completa: quedará en `/srv/restaurado/srv/condortech/erp`).

## 3. Detén el cronómetro y verifica la integridad

`ct-rto` compara **cada archivo restaurado, hash por hash**, contra el manifiesto original y calcula tu RTO.

```
ct-rto
```{{exec}}

Si todo coincide, te emite la bandera **A Completo** y escribe el **certificado de prueba de restauración** en `/root/certificado-restauracion.txt`:

```
cat /root/certificado-restauracion.txt
```{{exec}}

> **Innegociable:** un respaldo que nunca se restauró **no existe**. El certificado es la prueba. Cópialo a tu Runbook y guárdalo para la Clase 13.

## 4. Pregunta para el artefacto

Tu RTO fue de segundos porque el repositorio está en el mismo disco. Abre el análisis de impacto del ERP:

```
cat /srv/condortech/erp/continuidad/bia_erp.txt
```{{exec}}

El negocio exige **RPO de 1 hora** y **RTO de 4 horas**, y hoy los respaldos son **nocturnos** y van a un disco **en la misma sala**. ¿Qué tendría que cambiar en el plan para cumplir lo que pide el CFO? Anótalo: va en tu Plan de respaldo.

¿Atascado? `ct-pista a2` · ¿Sin tiempo? `ct-rescate A`
