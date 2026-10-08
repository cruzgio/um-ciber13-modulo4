# Bloque A · Paso 1 — Repositorio cifrado y primer respaldo

Los datos críticos del ERP están en `/srv/condortech/erp`. Míralos:

```
find /srv/condortech/erp -type f | sort
```{{exec}}

## 1. Inicializa el repositorio cifrado

restic cifra **todo** (datos, nombres y metadatos) con AES-256; sin la llave, el repositorio es ruido.

> **Importante:** la contraseña del repositorio es la **llave de Cóndor Tech**, no una tuya. Todos los comandos llevan `-p /root/llave-condortech.txt` para que restic la lea del archivo. Si restic te pide contraseña por teclado, es que faltó el `-p`: cancela con Ctrl+C y repite el comando completo.

```
restic -r /srv/respaldo/erp -p /root/llave-condortech.txt init
```{{exec}}

## 2. Haz el primer respaldo

```
restic -r /srv/respaldo/erp -p /root/llave-condortech.txt backup /srv/condortech/erp
```{{exec}}

## 3. Comprueba que existe un snapshot

```
restic -r /srv/respaldo/erp -p /root/llave-condortech.txt snapshots
```{{exec}}

Anota el **ID** del snapshot y la hora: ese es tu punto de recuperación (tu **RPO** real es el tiempo que pase desde aquí hasta el incidente).

## 4. Reclama la bandera A Mínimo

```
ct-check a1
```{{exec}}

> **¿Por qué importa?** Un respaldo sin cifrar que se lo lleva un atacante es una fuga de datos, no un respaldo. Y un respaldo cuya llave está *dentro* del mismo servidor se cifra junto con todo lo demás el día del ransomware.

¿Atascado? `ct-pista a1` · ¿Sin tiempo? `ct-rescate A`
