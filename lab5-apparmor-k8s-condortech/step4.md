# B1 · Encontrar el Pod privilegiado (mínimo aceptable · 2 pts)

Cambiamos de capa: la **Zona B** de Cóndor Tech es un clúster de Kubernetes que el proveedor *«construyó rápido y nunca auditó»*. Un **Pod** es la unidad mínima que Kubernetes ejecuta (uno o más contenedores juntos); un **nodo** es la máquina donde corren; `kubectl` es la herramienta con la que hablas con el clúster. Nada más hace falta hoy.

```plain
kubectl get pods -n tienda -o wide
```{{exec}}

Tres Pods. **Predice** antes de abrir ningún manifiesto: ¿cuántos de los tres crees que corren como root dentro del contenedor? (Pista para pensar: ¿qué pasa cuando un manifiesto no dice nada?)

```plain
ct-predigo b1 ____
```{{copy}}

Ahora investiga. Uno de los tres está lanzado con `privileged: true` (y algo más): es la Intro de hoy hecha realidad, ese contenedor puede leer el disco del nodo. Abre el manifiesto de cada uno y busca `securityContext`, `hostPID`, `hostPath` y `env`:

```plain
kubectl get pod NOMBRE -n tienda -o yaml
```{{copy}}

Si prefieres preguntarle al clúster de una, `ct-pista b1` tiene la consulta con `jq`. Responde con el nombre del Pod privilegiado:

```plain
ct-responder b1 NOMBRE
```{{copy}}

Pregunta de paso, para el artefacto: ¿qué está viviendo en las variables de entorno de `pagos-worker`? ¿Quién puede leerlo con un `kubectl get pod -o yaml`?
