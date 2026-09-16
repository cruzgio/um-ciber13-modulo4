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

<details><summary>Rescate — «si te atascas, salta aquí» (bandera a mitad de puntos)</summary>

```
ss -tlnp | grep LISTEN
curl -s http://localhost:2323/LEEME.txt
echo "servicio=telnetd-legacy puerto=2323" > /root/respuestas/01.txt
ct-check 1
```{{exec}}

</details>
