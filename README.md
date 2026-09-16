# CIBER13 · Módulo 4 — Escenarios de laboratorio

Escenarios de [Killercoda](https://killercoda.com) para **Seguridad en redes y sistemas
operativos**, módulo 4 de la Maestría en Ciberseguridad y Gestión de Riesgos Tecnológicos de la
**Universidad de Montevideo**.

Los laboratorios siguen un hilo narrativo único: el equipo de seguridad de *Cóndor Tech S.A.S.*,
una empresa regional ficticia con comercio electrónico, datacenter propio y cargas en la nube.
Cada laboratorio produce un artefacto documental que se acumula en el Runbook del equipo.

Perfil de creador: **https://killercoda.com/cruzgio**

---

## ⚠️ Estos entornos son deliberadamente inseguros

Los scripts de este repositorio **crean configuraciones vulnerables a propósito**: cuentas sin
contraseña, permisos incorrectos sobre archivos de credenciales, reglas de `sudo` sin
autenticación, SSH permisivo y servicios innecesarios expuestos.

Existen únicamente para practicar diagnóstico y remediación dentro de un entorno efímero y
aislado de Killercoda, que se destruye al terminar la sesión.

**No ejecutes `setup.sh` sobre una máquina que te importe.** No los uses como base de ninguna
configuración real.

---

## Laboratorios

| Lab | Carpeta | Clase | Tema |
|---|---|---|---|
| 1 | `condortech-lab1-linea-base` | 2 | Diagnóstico de línea base con CIS Benchmarks y Lynis |

*(Los laboratorios 2 a 7 se agregan como carpetas nuevas en la raíz.)*

Cada laboratorio queda publicado en
`https://killercoda.com/cruzgio/scenario/<nombre-de-la-carpeta>`.

---

## Estructura de un escenario

```
<nombre-del-escenario>/
├── index.json        # metadatos: título, pasos, imagen base, scripts
├── intro.md          # página previa al arranque
├── setup.sh          # script de fondo: prepara el entorno
├── step1/text.md     # enunciado del checkpoint
├── step1/verify.sh   # validación: exit 0 = aprobado
├── step2/ …  step3/ …
└── finish.md         # página de cierre
```

Referencia oficial: [killercoda/scenario-examples](https://github.com/killercoda/scenario-examples)
y la [documentación de creadores](https://killercoda.com/creators).

## Cómo contribuir o reutilizar

Cada `git push` a la rama `main` actualiza los escenarios publicados. Antes de empujar un cambio,
corre el escenario completo de punta a punta: un error en `setup.sh` se manifiesta como un
laboratorio silenciosamente roto para todo el grupo.

Si adaptas este material para otro curso, la licencia MIT te lo permite sin pedir permiso. Una
mención de la fuente se agradece, no se exige.

## Licencia

[MIT](LICENSE) — código y contenido.
