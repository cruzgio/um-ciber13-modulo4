## CP1 · Reconocimiento (15 min)

No puedes auditar lo que no sabes que existe. Tres preguntas, en este orden:

**¿Quién puede entrar?** — cuentas locales, shells válidos, cuentas sin contraseña.

```
cat /etc/passwd
awk -F: '($2==""){print $1" -> SIN CONTRASENA"}' /etc/shadow
```{{exec}}

**¿Quién es root?** — UID 0 no siempre es una sola cuenta.

`awk -F: '($3==0){print $1}' /etc/passwd`{{exec}}

**¿Qué está escuchando?** — puertos abiertos y el proceso dueño de cada uno.

`ss -tlnp`{{exec}}

Vas a encontrar un servicio que **ningún documento de Cóndor Tech menciona**.
Averigua qué sirve:

`curl -s http://localhost:2323/`{{exec}}

### Entregable del checkpoint

Escribe el nombre del proceso y su puerto:

```
mkdir -p /root/respuestas
echo "servicio=<nombre_del_proceso> puerto=<numero>" > /root/respuestas/01.txt
```{{copy}}

Y valida:

`ct-check 1`{{exec}}

<details><summary>Rescate — «si te atascas, salta aquí»</summary>

Esto te entrega la solución del checkpoint y **lo marca como media puntuación**: `ct-check` te va
a dar la bandera de rescate en vez de la completa. Está aquí para que nadie se quede fuera del
objetivo de la clase, así que úsalo sin culpa si el reloj te está ganando.

`ct-rescate 1`{{exec}}

</details>
