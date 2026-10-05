# B3 · Extra (1 pt) + kube-bench para el estándar

Tres candados más, los que piden la guía NSA/CISA y el CIS Benchmark:

- en el contenedor: `allowPrivilegeEscalation: false` y `capabilities: {drop: ["ALL"]}`
- en el Pod (nivel `spec`): `seccompProfile: {type: RuntimeDefault}`

**Predice**: si le quitas todas las capabilities a un proceso que solo duerme, ¿sigue arrancando? Piensa qué hacen las capabilities antes de responder.

```plain
ct-predigo b3 ____
```{{copy}}

```plain
nano /root/lab5/carrito-plantilla.yaml
```{{exec}}

```plain
kubectl delete pod carrito -n tienda && kubectl apply -f /root/lab5/carrito-plantilla.yaml && sleep 5 && ct-check B
```{{exec}}

## kube-bench: el clúster contra el CIS Kubernetes Benchmark

Esto es lo que la auditoría de octubre le va a correr a Cóndor Tech. Ejecútalo (≈20 s) y mira solo los hallazgos:

```plain
ct-bench
ct-bench fails
```{{exec}}

No hay bandera por kube-bench: su salida **es insumo del artefacto** (nivel completo). Elige UN `[FAIL]` que te parezca grave para la Zona B y escribe en una frase qué podría hacer un atacante si no se corrige, con su número de control (p. ej. `1.2.x`, `4.2.x`). La salida completa queda en `/root/lab5/kube-bench.txt`.

```plain
ct-banderas
```{{exec}}
