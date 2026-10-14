## Paso 2 — Paciente cero y cuenta comprometida (13.1 y 13.2)

Pregunta guía: **¿desde qué equipo y con qué cuenta entró el atacante por primera vez?**

Pistas de método (no de respuesta):

```bash
ct-buscar "phish"
ct-buscar "203.0.113"
ct-eventos 4624 | head -40
```{{exec}}

Cruza tres fuentes: el correo (quién hizo clic), el proxy (qué equipo habló primero con el exterior raro) y las autenticaciones (qué cuenta entró desde ese equipo). Si las tres apuntan al mismo lugar, tienes al paciente cero.

Responde (el nombre de equipo tal como aparece en los logs; la cuenta sin dominio):

```bash
ct-responder a1 <hostname-paciente-cero>
ct-responder a2 <cuenta-comprometida>
```

Si necesitas ayuda: `ct-pista a1` / `ct-pista a2`.
