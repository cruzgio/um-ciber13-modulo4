# Paso 1 — Reconoce el pack de evidencias

`logs-central` preservó estas fuentes antes de la contención. **Solo lectura:** preservar antes de limpiar.

```
ct-evidencias
```{{exec}}

Antes de buscar nada, responde mentalmente (y díselo a tu Líder):

1. ¿Qué fuente te dice **quién recibió** algo raro?
2. ¿Cuál te dice **qué equipo habló con el exterior**?
3. ¿Cuál traduce una **IP interna a un nombre de equipo**?
4. ¿Cuál cuenta lo que pasó **dentro de `erp-prod`**, y en qué zona horaria está?

Mira también lo que dejó el atacante en la exportación del ERP:

```
ls -R /srv/condortech/erp
```{{exec}}

> La red de casa central es **plana**: un solo segmento. Todo ve a todo y todo sale a Internet. Tenlo presente al leer `fw-borde.log`.
