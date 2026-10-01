# Demo — Parchar de verdad (regreSSHion)

Esta es la demo docente de la Clase 9. Sirve para mostrar un **parchado real** siguiendo el ciclo NIST (detectar → priorizar → parchar → verificar), de forma **segura**: no se toca el OpenSSH del sistema.

Cómo está armado: plantamos un paquete de práctica, `condor-sshd`, en una versión **vulnerable** (9.6p1), y dejamos la versión **corregida** (9.8p1) disponible en un repositorio `apt` **local**. El paquete representa a OpenSSH; sus versiones imitan las reales de regreSSHion (9.6p1 vulnerable → 9.8p1 corregida).

> La preparación tarda unos segundos. Corré `ct-listo` hasta que esté todo en verde.

```
ct-listo
```{{exec}}

Cuando esté listo, pasá al único paso.
