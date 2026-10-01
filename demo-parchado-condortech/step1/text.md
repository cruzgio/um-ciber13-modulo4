# Parchar de verdad: el ciclo en 4 pasos

El caso real: **regreSSHion (CVE-2024-6387)**, un fallo en OpenSSH (`sshd`) que da ejecución de código como root **sin autenticarse**. Afectó las versiones 8.5p1 a 9.7p1 (2021–2024) y se corrige en 9.8p1. Acá lo vemos sobre el paquete de práctica `condor-sshd`, que imita esas versiones.

## 1. Detectar — ¿qué hay para actualizar?

```
apt update && apt list --upgradable
```{{exec}}

Vas a ver `condor-sshd` como actualizable: `9.6p1-condor1 → 9.8p1-condor1`.

## 2. Priorizar — ¿va primero?

No hace falta comando: es criterio. `condor-sshd` representa un servicio **expuesto a Internet** con un **RCE como root** (CVSS 8.1). En un caso real chequearías además el catálogo **KEV** de CISA. Expuesto + explotable → **se parcha primero**.

## 3. Parchar — aplicar solo esa actualización

```
apt-get install --only-upgrade condor-sshd
```{{exec}}

`--only-upgrade` actualiza ese paquete y nada más: nada de sorpresas en el resto del sistema.

## 4. Verificar — ¿quedó?

```
apt-cache policy condor-sshd
zcat /usr/share/doc/condor-sshd/changelog.gz
```{{exec}}

`Installed:` ahora dice `9.8p1-condor1`, y el changelog confirma que esa versión **corrige regreSSHion**.

## El matiz que casi nadie sabe

En Ubuntu/Debian el arreglo de seguridad se **backportea sin cambiar el número de versión upstream**. Un `ssh -V` que dice `9.6p1` puede estar **perfectamente parchado**. Contrastalo con el OpenSSH real del sistema:

```
ct-estado
```{{exec}}

Moraleja: para saber si estás parchado **no mires el número de `ssh -V`**; mirá la versión del **paquete** (`apt-cache policy`) o el **aviso de seguridad del proveedor** (en Ubuntu, el **USN**).

---

Para repetir la demo (vuelve a la versión vulnerable):

```
ct-reset
```{{exec}}
