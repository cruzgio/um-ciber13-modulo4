## CP3 · Contraste automatizado con Lynis (15 min)

Ya tienes la mirada manual. Ahora la automatizada — y la pregunta real del checkpoint
no es *«qué encontró Lynis»* sino **«en qué se diferencian las dos listas»**.

`lynis audit system --quick`{{exec}}

Al terminar, revisa los dos bloques que importan:

```
grep -E '^(warning|suggestion)\[\]' /var/log/lynis-report.dat | head -40
grep -E '^hardening_index=' /var/log/lynis-report.dat
```{{exec}}

### La credencial que nadie vio

Lynis puntúa la configuración del sistema, pero **no audita la lógica de negocio de
Cóndor Tech**. Un archivo de aplicación que cualquiera puede reescribir y que guarda
la contraseña de la base de datos lo encuentras tú, no la herramienta:

`find / -xdev -type f -perm -0002 -not -path '/proc/*' -not -path '/sys/*' -not -path '/tmp/*' -not -path '/run/*' 2>/dev/null`{{exec}}

Abre el candidato sospechoso y anota la ruta:

```
mkdir -p /root/respuestas
echo "<ruta_del_archivo>" > /root/respuestas/03.txt
```{{copy}}

`ct-check 3`{{exec}}

### Para el debrief

Anota en tu informe: **¿qué hallazgo tuyo NO está en el reporte de Lynis, y por qué?**
Esa diferencia es el argumento que justifica tu trabajo frente al CISO.

<details><summary>Rescate — «si te atascas, salta aquí» (bandera a mitad de puntos)</summary>

```
lynis audit system --quick
find / -xdev -type f -perm -0002 -not -path '/proc/*' -not -path '/sys/*' -not -path '/tmp/*' -not -path '/run/*' 2>/dev/null
cat /opt/condortech/deploy/backup.conf
echo "/opt/condortech/deploy/backup.conf" > /root/respuestas/03.txt
ct-check 3
```{{exec}}

</details>
