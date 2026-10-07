# A2 · Priorizar con contexto (nivel completo · 2 pts)

Ordena por CVSS y mira qué queda arriba:

```plain
ct-escanear legacy --top
```{{exec}}

Casi todo lo de arriba es de Pillow, un paquete que **no se ejecuta** (`ct-uso`). El CVSS no sabe eso; tú sí.

## El segundo riesgo: el token de pagos

El carrito cobra enviando el **token de Cóndor Tech** a la pasarela de pagos, en la cabecera `Authorization`, usando la biblioteca `requests` (`ct-uso`, línea 27). Viaja por **HTTPS**, cifrado. El ataque funciona así:

```
1. carrito ── HTTPS + token ──▶ pasarela              (cifrado: nadie lo ve)
2. pasarela responde: «redirect: andá a http://…»     (alguien la engañó o está mal configurada)
3. carrito ── HTTP  + token ──▶ …                     (requests 2.19 lo reenvía EN CLARO)
4. cualquiera en el medio lee el token                (como la credencial del pcap de la clase 6)
```

Con ese token, un tercero puede cobrar o consultar a nombre de Cóndor Tech. No hace falta entrar al servidor.

**Pregunta A2:** ¿qué CVE de `requests` permite el paso 3? Mira los CVE con IMPACTO «fuga de credenciales» y lee el título: busca el de la **redirección de HTTPS a HTTP**.

```plain
ct-escanear legacy --paquete requests
```{{exec}}

```plain
ct-responder a2 CVE-XXXX-XXXXX
```{{copy}}

Mientras tanto, empieza a llenar la **matriz de priorización** del artefacto (plantilla en Moodle): para cada hallazgo del top 5, exposición, uso real, explotabilidad, impacto y CVSS, y la decisión: *corregir ya / esta semana / ventana de cambios / aceptar*.
