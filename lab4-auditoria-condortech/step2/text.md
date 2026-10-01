# Bloque A · 2. Cazar al atacante en auditd

## 1. Hacer volver al atacante

```
ct-simular
```{{exec}}

El atacante entra con la cuenta comprometida de alguien de Cóndor Tech, escala con `sudo`, toca contraseñas, sudoers y grupos, intenta bajar una herramienta y borra `auth.log`. Todo eso ahora **queda en auditd**.

## 2. A Mínimo — ¿qué humano está detrás?

Buscá por clave y leé el campo `auid` (con `-i` se muestra como nombre de usuario):

```
ausearch -k identidad -i | grep type=SYSCALL
```{{exec}}

```
ausearch -k sudoers -i | grep -E "type=(SYSCALL|PATH)"
```{{exec}}

Fijate: `uid=root`, pero `auid=` **otra persona**. Esa persona es la respuesta.

```
ct-responder a1 <usuario>
```

## 3. A Completo — ¿qué comando salió a Internet?

La clave `privilegiado` guarda cada `execve` como root. Buscá el que intentó descargar algo y leé sus argumentos (registro `EXECVE`):

```
ausearch -k privilegiado -i | grep -B2 -A1 EXECVE | grep -A1 curl
```{{exec}}

```
ct-responder a2 <IP del servidor remoto>
```

(Esa IP ya la viste en el Lab 3. Sí, es el mismo C2.)

## 4. Resumen de lo que auditd contó

```
aureport -k --summary
```{{exec}}

## Si te atascás
`ct-pista a1` · `ct-pista a2` · `ct-rescate A`

## Para el artefacto del Runbook
Copiá tu ruleset con comentarios (`cat /etc/audit/rules.d/condortech.rules`) y anotá: para cada clave, **qué registra, qué buscar y qué hacer si aparece**. Eso es la "Política de auditoría y playbook de cacería" de esta clase.
