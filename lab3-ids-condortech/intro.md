# El IDS de Cóndor Tech

La junta de Cóndor Tech aprobó dos cosas después del MitM: **cifrar** las comunicaciones (VPN) y **tener detección** (un IDS). Hoy te toca la segunda parte.

Sos analista del SOC. Tenés un **Suricata** con las reglas **ET Open** ya cargadas y **tres capturas** de la red de esta semana. Tu trabajo no es atacar: es **leer lo que el sensor vio**, **triar** lo que importa, cazar **lo que el IDS dejó pasar**, y al final **escribir tu propia regla**.

> **Modo offline.** No hay una red de ataque en vivo. Suricata lee las capturas con `-r` y saca **exactamente las mismas alertas** que sacaría en tiempo real. Es como revisar la grabación de las cámaras en vez de esperar al ladrón.

## Doble nivel en cada checkpoint

Como en todo el módulo, cada checkpoint tiene dos niveles y **ambos son válidos**:

- **Mínimo** — leer la alerta obvia que el IDS ya te dio. Alcanza el objetivo y aprueba.
- **Completo** — el trabajo del analista de verdad: separar señal de ruido y encontrar **lo que el IDS NO te dio**. Es lo que distingue una nota alta.

## Las tres capturas (en `/opt/ct/pcaps/`)

| Captura | Qué es |
|---|---|
| `escaneo.pcap` | Alguien barrió la red desde afuera esta mañana. |
| `mitm_clase6.pcap` | La **misma** captura que investigaste a mano en la clase 6. |
| `malware.pcap` | La «factura» que abrió contabilidad hizo algo raro. |

## Cómo entregás

Banderas en **CTFd**, categoría **Lab 3**, formato `CT{...}`. Los checkpoints 3.1–3.3 son **datos** (mínimo y completo); el 3.4 es tu **regla propia funcionando**.

## Tus herramientas

```
ct-mapa               el puesto y qué hace cada comando
ct-alertas <pcap>     las alertas que Suricata ya sacó de esa captura
ct-buscar <pcap>      dónde está el eve.json y ejemplos de jq para cazar
ct-bandera <n> <r>    comprueba 3.1 / 3.1c / 3.2 / 3.2c / 3.3 / 3.3c
ct-pista <n>          una pista para un nivel completo (aquí no cuesta)
ct-mi-regla           crea la plantilla de tu regla en /root/mi-regla.rules
ct-check              corre TU regla sobre malware.pcap y verifica que dispara
ct-triaje             plantilla de la nota de triaje (nivel completo del 3.4)
ct-rescate            la regla de referencia, si te atascás (media bandera)
ct-banderas           recap de lo que ya capturaste
```

El primer comando que conviene correr es `ct-mapa`, y después `ct-alertas escaneo.pcap`.
