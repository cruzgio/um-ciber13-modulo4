## Paso 3 — IP de C2 y nombre de la nota (13.3 y 13.4)

**C2:** la máquina comprometida habló con un servidor de mando y control de forma repetida y regular (beacon). Búscalo en el proxy y en auditd:

```bash
ct-buscar "CONNECT"
ct-eventos 5156 | head -20
```{{exec}}

**Nota de rescate:** está junto a los archivos cifrados del ERP. Es un archivo, no un mensaje en pantalla.

```bash
ct-responder a3 <ip-de-c2>
ct-responder a4 <nombre-del-archivo-de-la-nota>
ct-check a
```

Cada integrante del equipo envía las banderas **desde su propia cuenta** del CTFd. Si el inyecto siguiente ya llegó y no alcanzaste: `ct-rescate A` entrega la bandera de rescate y sigues con el equipo. Lo recuperas en el hotwash.
