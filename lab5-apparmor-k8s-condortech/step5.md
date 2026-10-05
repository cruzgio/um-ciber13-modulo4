# B2 · Endurecer el Pod (nivel completo · 2 pts)

El estándar de despliegue seguro de Cóndor Tech, en cinco líneas de `securityContext`: **sin privilegios, sin root, sistema de archivos de solo lectura, con límites y sin tocar el host**. Primero sale el legacy (en DIE, borrar es normal):

```plain
kubectl delete pod carrito-legacy -n tienda
```{{exec}}

Abre la plantilla y lee los comentarios antes de rellenar nada. Hay un volumen `emptyDir` montado en `/tmp`: **predice** para qué está ahí, respondiendo si con `readOnlyRootFilesystem: true` el contenedor va a poder escribir en `/tmp`.

```plain
ct-predigo b2 ____
```{{copy}}

Completa los `____` de la plantilla. Decide cada valor pensando en qué protege (no hay que adivinar: los cinco candados están en la lámina y `ct-pista b2` tiene valores de referencia):

```plain
nano /root/lab5/carrito-plantilla.yaml
```{{exec}}

Despliega y comprueba que queda **Running**:

```plain
kubectl apply -f /root/lab5/carrito-plantilla.yaml
kubectl get pod carrito -n tienda
```{{exec}}

> `CreateContainerConfigError` casi siempre es `runAsNonRoot: true` sin `runAsUser`: Kubernetes no puede probar que la imagen no es root. Mira `kubectl describe pod carrito -n tienda`.

Antes de verificar, compruébalo tú mismo: ¿puede el nuevo carrito escribir en su imagen? ¿y en /tmp?

```plain
kubectl exec carrito -n tienda -- sh -c 'touch /prueba && echo "escribió en la imagen"; touch /tmp/prueba && echo "escribió en /tmp"'
```{{exec}}

```plain
ct-check B
```{{exec}}

Para corregir y reintentar: `kubectl delete pod carrito -n tienda && kubectl apply -f /root/lab5/carrito-plantilla.yaml`.
