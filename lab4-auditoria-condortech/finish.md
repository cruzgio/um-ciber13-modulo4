# Cierre del Lab 4

```
ct-banderas
```{{exec}}

Subí tus banderas en CTFd, categoría **«Lab 4»**. Los retos se llaman igual que lo que imprime `ct-responder`.

## Lo que te llevás
1. **auditd** registra al humano detrás del sudo (`auid`). Sin reglas cargadas y sin el servicio activo, no registra nada: por eso nadie sabe quién creó `svc_backup`.
2. Los eventos de Windows se pueden cazar **desde Linux** (`evtx_dump` + `jq`). 4688 + 5156 + 4624 cuentan la historia completa; 1102 avisa que alguien intentó borrarla.
3. Un log que vive solo en la máquina atacada no sirve: `auth.log` vacío, 1102 en Windows. **Enviar los logs a un colector externo no es opcional.**

## Artefacto del Runbook (esta clase)
**Política de auditoría y playbook de cacería de Cóndor Tech**: tu ruleset comentado + qué IDs vigilar, qué buscar y cómo priorizar. Plantilla y niveles en Moodle.

Muestras de Windows: EVTX-ATTACK-SAMPLES (Samir Bousseaden, GPL-3.0). Parser: evtx (Omer Ben-Amram).
