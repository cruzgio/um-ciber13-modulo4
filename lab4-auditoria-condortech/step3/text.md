# Bloque B · Cacería en el .evtx real

## Innegociable
Un `.evtx` es el registro de eventos de Windows. Se puede leer desde Linux con `evtx_dump` (ya convertido a JSON en `/root/evtx/`). Los IDs que importan hoy: **4688** proceso creado, **4624** inicio de sesión (mirar `LogonType`), **5156** conexión permitida, **1102** registro borrado.

El caso es un ataque real capturado en un equipo Windows (`PC01.example.corp`, repositorio EVTX-ATTACK-SAMPLES). Alguien abrió un túnel para entrar por RDP sin pasar por el firewall.

> Cada herramienta `ct-*` te muestra al final el **comando crudo equivalente** (`grep`/`jq` sobre el `.jsonl`). No lo ignores: ahí está la técnica real de DFIR que te llevás para cualquier `.evtx`, sin las herramientas del lab.

## 1. Panorama

```
ct-eventos caso_tunel
```{{exec}}

Mirá qué EventIDs aparecen y cuántos de cada uno. Esa sola foto ya te insinúa la forma del ataque.

## 2. B Mínimo — ¿qué programa ajeno a Windows se ejecutó?

```
ct-eventos caso_tunel 4688
```{{exec}}

Los programas legítimos de Windows se ejecutan desde `C:\Windows\System32`. Recorré la columna `proceso=` y buscá el único que se lanzó desde **otra carpeta** —por ejemplo, el Escritorio de un usuario—. Esa ruta fuera de lo común es la señal: nadie guarda herramientas de administración en el Escritorio.

```
ct-responder b1 <nombre.exe>
```

Fijate que `cmd=[]` está vacío: esta política **no** tenía habilitado "incluir línea de comandos en 4688". Anotalo para tu playbook — es una limitación real de visibilidad que te vas a cruzar en producción.

## 3. B Completo — ¿hacia dónde abrió el túnel?

Ese proceso abrió conexiones de red. Miralas:

```
ct-buscar caso_tunel plink
```{{exec}}

Vas a ver **dos tipos de destino**: uno local (`127.0.0.1` / `127.0.0.2`, que es el RDP entrando por el túnel) y otro **fuera del equipo** (la otra punta del túnel, hacia Internet). El que te piden es el **externo**: el que **no** empieza con `127.`.

```
ct-responder b2 <IP:puerto del destino externo>
```

Para cerrar la historia (esto no da bandera): mirá quién entró y desde dónde.

```
ct-eventos caso_tunel 4624
```{{exec}}

Un `LogonType=10` (RDP) **desde 127.0.0.1** confirma la jugada: la sesión RDP viajó por dentro del túnel, como si viniera de la propia máquina.

## 4. B Antiforense — ¿quién borró el registro antes de empezar?

```
ct-eventos caso_tunel 1102
```{{exec}}

La herramienta te muestra el bloque `UserData` del evento tal cual viene en el `.evtx`. Trae varios campos (`SubjectUserSid`, `SubjectUserName`, `SubjectDomainName`, `SubjectLogonId`): el que te interesa es **`SubjectUserName`**, la cuenta que borró el registro. Detalle real del formato: en el `1102` el autor **no vive donde el resto** —está en `UserData`, no en `EventData`—, por eso hay que leerlo distinto.

```
ct-responder b3 <usuario>
```

## Si te atascás
`ct-pista b1` · `ct-pista b2` · `ct-pista b3` · `ct-rescate B`

## Para practicar después (sin bandera)
- `ct-eventos caso_cuenta 4720` — una cuenta creada con nombre `$` para parecer una cuenta de equipo.
- `ct-eventos caso_grupo 4732` — dos SIDs agregados a Administrators. ¿Quiénes son `-501` y `S-1-5-20`?
