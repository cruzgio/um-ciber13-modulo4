# Bloque B — la credencial y el frame cero (banderas 6.4 y 6.5)

Ya sabés quién envenenó la red. Ahora: **qué se robó** y **cuándo empezó**.

## 6.4 · La credencial que viajó en claro

Como el atacante se puso en medio (MitM), pudo leer el tráfico de la víctima. La víctima entró a la consola interna de atención **por HTTP, sin cifrar**. Su usuario y clave viajaron en texto plano dentro de un POST:

```
ct-abrir "http.request.method==POST"
```
Para ver el cuerpo del POST con la credencial:
```
tshark -r /root/caso/condor_incidente2.pcap -Y "http.request.method==POST" -T fields -e urlencoded-form.key -e urlencoded-form.value
```
La bandera es la **clave** (respetá mayúsculas y minúsculas al cargarla en CTFd).
`ct-bandera 4 <clave>`

## 6.5 · El frame cero del ataque

Toda la investigación empieza en un punto: el **primer paquete** donde Wireshark detecta que hay dos equipos peleando por la misma IP. Ese es el arranque del envenenamiento.

```
ct-abrir "arp.duplicate-address-detected"
```
Tomá el **número de frame más bajo** de la lista.
`ct-bandera 5 <número de frame>`

---

Con las cinco banderas, tenés el caso resuelto. Ahora escribí el **informe forense** (la plantilla está en Moodle): qué pasó, la evidencia con el filtro que usaste en cada punto, el impacto, y los tres controles que lo habrían evitado o detectado.
