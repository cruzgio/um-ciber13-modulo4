## Paso 1 — Reconoce el pack de evidencias

Espera a que `ct-listo` diga **LISTO** (prepara los datos en segundo plano):

```bash
ct-listo
ct-mapa
```{{exec}}

Lista el pack y la carpeta del ERP cifrado:

```bash
ct-evidencias
ls -la /srv/erp
```{{exec}}

El pack está en `/srv/evidencias/`. Son logs reales de Cóndor Tech de la noche del incidente: autenticación del servidor de archivos, proxy de salida, correo, auditd del servidor ERP y la exportación JSON del registro de Windows de `SRV-ARCHIVOS` (ya convertido con `evtx_dump`, como en el Lab 4).

> **Regla:** preservar antes de limpiar. No borres ni «arregles» nada del pack; solo lees.
