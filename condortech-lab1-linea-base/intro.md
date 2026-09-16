## Cóndor Tech S.A.S. — orden del CISO

> *«Heredamos estos servidores de SysProv Ltda. Se fueron sin documentar nada.
> Antes de arreglar nada, díganme qué tan mal estamos.»*

Acabas de recibir acceso al servidor **app-legacy-01**. Nadie sabe qué corre ahí,
qué cuentas existen ni quién puede escalar a root.

En los próximos **55 minutos** vas a producir el primer documento del Runbook de
Cóndor Tech: el **Informe de línea base**.

### Reglas del lab

1. Trabajas en equipo, pero **cada quien captura sus banderas en su propia cuenta del CTFd**.
2. Cada checkpoint se valida en la terminal con `ct-check <n>`{{copy}}; al pasar te entrega la bandera.
3. Si te atascas, cada paso trae un desplegable **Solución**. Usarlo vale la mitad de los puntos
   y está ahí precisamente para que nadie se quede por fuera del objetivo.
4. Guarda tus respuestas en `/root/respuestas/`. **La máquina se borra al cerrar; tu informe no.**

### Antes de empezar

El entorno está sembrando las configuraciones del servidor heredado. Si algún comando
no responde en los primeros 30 segundos, espera y reintenta.

Verifica que terminó:

`ls /root/.ct-setup-done`{{exec}}
