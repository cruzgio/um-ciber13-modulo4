# B1 · Encontrar el Pod privilegiado (mínimo aceptable · 2 pts)

Cambiamos de capa: la **Zona B** de Cóndor Tech es un clúster de Kubernetes que el proveedor *«construyó rápido y nunca auditó»*. Tres Pods en el namespace `tienda`:

```plain
kubectl get pods -n tienda -o wide
```{{exec}}

Un **Pod** es la unidad mínima que Kubernetes ejecuta (uno o más contenedores juntos); un **nodo** es la máquina donde corren; `kubectl` es la herramienta con la que hablas con el clúster. Nada más hace falta hoy.

Uno de los tres Pods está lanzado con `privileged: true` (y algo más). Es la Intro de hoy hecha realidad: ese contenedor puede leer el disco del nodo. Encuéntralo:

```plain
kubectl get pod carrito-legacy -n tienda -o yaml | grep -nE 'privileged|hostPID|hostPath' 
```{{exec}}

(Ese comando mira uno solo; revisa los tres, o usa `jq` como en `ct-pista b1`.)

Responde con el nombre del Pod:

```plain
ct-responder b1 NOMBRE
```{{copy}}

Pregunta de paso, para el artefacto: `kubectl get pod pagos-worker -n tienda -o yaml | grep -A2 env` — ¿qué está viviendo en una variable de entorno?
