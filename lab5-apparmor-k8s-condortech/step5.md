# B2 · Endurecer el Pod (nivel completo · 2 pts)

El estándar de despliegue seguro de Cóndor Tech, en cinco líneas de `securityContext`: **sin privilegios, sin root, sistema de archivos de solo lectura, con límites y sin tocar el host**. Primero sale el legacy:

```plain
kubectl delete pod carrito-legacy -n tienda
```{{exec}}

Completa los `____` de la plantilla (la pista `ct-pista b2` tiene los valores):

```plain
nano /root/lab5/carrito-plantilla.yaml
```{{exec}}

Despliega y comprueba que queda **Running**:

```plain
kubectl apply -f /root/lab5/carrito-plantilla.yaml
kubectl get pod carrito -n tienda
```{{exec}}

> `CreateContainerConfigError` casi siempre es `runAsNonRoot: true` sin `runAsUser`: Kubernetes no puede probar que la imagen no es root. Mira `kubectl describe pod carrito -n tienda`.

```plain
ct-check B
```{{exec}}

Para corregir y reintentar: `kubectl delete pod carrito -n tienda && kubectl apply -f /root/lab5/carrito-plantilla.yaml`.
