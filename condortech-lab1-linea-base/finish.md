## Diagnóstico entregado

Encontraste 8 configuraciones inseguras en un servidor que nadie había mirado en 6 años.

### Antes de cerrar la pestaña

`ct-informe`{{exec}}

Eso arma el esqueleto del **Informe de línea base** con todo lo que levantaste: alcance, método,
índice de Lynis y la tabla de hallazgos ya rellena. Lo que queda en blanco es lo único que la
máquina no puede poner: el control CIS, la técnica ATT&CK, el top 3 por impacto de negocio y la
respuesta DIE.

`cat /root/respuestas/informe-linea-base.md`{{exec}}

**Cópialo a tu documento ahora.** En unos minutos esta máquina deja de existir.

### Lo que se lleva Cóndor Tech

Tu **Informe de línea base** — alcance, método (CIS + Lynis), tabla de hallazgos y
top 3 priorizado por impacto de negocio. Se entrega en el CTFd antes de la clase 3 y
entra al Runbook del equipo. En la **clase 8** vas a remediar exactamente estos hallazgos.

### Lo que NO se lleva

Esta máquina. En unos minutos deja de existir y con ella cada comando que corriste.

> Si el servidor fuera **ganado** — redesplegado desde una plantilla en cada ciclo —
> ¿cuáles de estos 8 hallazgos **dejarían de existir por diseño**?
>
> Esa es la pregunta de sello DIE de tu informe.
