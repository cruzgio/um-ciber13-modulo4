# Misión CSI — Incidente #2 de Cóndor Tech

Una mañana, una empleada de contabilidad reporta que **la red «anda rara»** y que ve **movimientos extraños en una cuenta**. El equipo forense recibe la captura de esa mañana. Tu trabajo es reconstruir qué pasó.

Este es el **Plan B** para quien no puede correr Wireshark en su computadora (permisos, sistema, lo que sea). Aquí trabajás con **tshark** —el mismo Wireshark, sin ventana— sobre la misma captura. Las respuestas y las banderas de CTFd son idénticas a las de tus compañeros.

> **Cómo entregás.** Las banderas se cargan en **CTFd**, categoría **Clase 6**, en formato `CT{...}`. Cada respuesta correcta te la entrega `ct-bandera` ya con el formato listo para copiar.

## Cinco banderas, de fácil a difícil

| # | Reto CTFd | Qué buscás |
|---|---|---|
| 6.1 | Hosts en la captura | Cuántas direcciones MAC distintas conversan |
| 6.2 | IP del atacante | La IP real de quien envenenó la red |
| 6.3 | La MAC suplantada | La MAC que finge ser el gateway |
| 6.4 | La credencial robada | El usuario y clave que viajaron en claro |
| 6.5 | El frame cero | El primer paquete del envenenamiento |

## Tus herramientas

```
ct-mapa               la red del caso y quién es quién
ct-abrir "<filtro>"   abre la captura con un filtro de Wireshark (o sin nada para ver todo)
ct-bandera <n> <resp> comprueba tu respuesta y te da la bandera de CTFd
ct-pista <n>          una pista para la bandera n (sin costo aquí; en CTFd la pista cuesta)
ct-retomar            si no cerraste el Bloque A, entra al B con el reconocimiento ya hecho
ct-rescate            la referencia del caso (media bandera; mejor eso que quedar trabado)
```

El primer comando que conviene correr es `ct-mapa`.
