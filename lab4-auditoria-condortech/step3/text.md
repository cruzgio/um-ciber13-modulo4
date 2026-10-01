# Bloque B · Cacería en el .evtx real

## Innegociable
Un `.evtx` es el registro de eventos de Windows. Se puede leer desde Linux con `evtx_dump` (ya convertido a JSON en `/root/evtx/`). Los IDs que importan hoy: **4688** proceso creado, **4624** inicio de sesión (mirar `LogonType`), **5156** conexión permitida, **1102** registro borrado.

El caso es un ataque real capturado en un equipo Windows (`PC01.example.corp`, repositorio EVTX-ATTACK-SAMPLES). Alguien abrió un túnel para entrar por RDP sin pasar por el firewall.

## 1. Panorama

```
ct-eventos caso_tunel
```{{exec}}

## 2. B Mínimo — ¿qué programa ajeno a Windows se ejecutó?

```
ct-eventos caso_tunel 4688
```{{exec}}

Casi todo vive en `C:\Windows\System32`. Buscá el que no.

```
ct-responder b1 <nombre.exe>
```

Fijate que `cmd=[]` está vacío: esta política **no** tenía habilitado "incluir línea de comandos en 4688". Anotalo para tu playbook.

## 3. B Completo — ¿hacia dónde abrió el túnel?

Las conexiones de ese proceso están en los 5156:

```
ct-buscar caso_tunel plink
```{{exec}}

Vas a ver un destino **externo** (el túnel) y uno **local** en el puerto 3389 (RDP entrando por el túnel). Después mirá quién inició sesión y desde dónde:

```
ct-eventos caso_tunel 4624
```{{exec}}

Un `LogonType=10` (RDP) **desde 127.0.0.1** es la firma del túnel.

```
ct-responder b2 <IP:puerto del destino externo>
```

## 4. B Antiforense — ¿quién borró el registro antes de empezar?

```
ct-eventos caso_tunel 1102
```{{exec}}

```
ct-responder b3 <usuario>
```

## Si te atascás
`ct-pista b1` · `ct-pista b2` · `ct-pista b3` · `ct-rescate B`

## Para practicar después (sin bandera)
- `ct-eventos caso_cuenta 4720` — una cuenta creada con nombre `$` para parecer una cuenta de equipo.
- `ct-eventos caso_grupo 4732` — dos SIDs agregados a Administrators. ¿Quiénes son `-501` y `S-1-5-20`?
