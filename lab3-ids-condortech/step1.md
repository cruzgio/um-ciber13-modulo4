# Bloque A — leer, priorizar y cazar (3.1 a 3.3)

Un IDS te dice en segundos cosas que a mano toman una hora. Pero también **alerta de más, alerta de menos, y es ciego a algunas cosas**. Hoy aprendés las tres.

## 3.1 · El escaneo

Alguien barrió la red esta mañana. Suricata ya lo procesó:

```
ct-alertas escaneo.pcap
```

**Mínimo:** se repite una alerta **ET SCAN** contra el puerto del SQL del ERP (1433). El número `[1:XXXXXXX:1]` es el **SID**.
```
ct-bandera 3.1 <SID>
```

**Completo:** el IDS alertó por **un** puerto, pero el escaneo tocó ~20. Un analista confirma el **alcance real**: ¿qué activo encontró abierto el atacante donde no debía, y siguió golpeando? Mirá el pcap, no solo el fast.log:
```
tshark -r /opt/ct/pcaps/escaneo.pcap -Y "tcp.flags.syn==1 && tcp.flags.ack==0" \
  -T fields -e ip.dst -e tcp.dstport | sort | uniq -c | sort -rn
```
```
ct-bandera 3.1c <ip:puerto>     (¿sin idea? ct-pista 3.1c)
```

## 3.2 · La captura de la clase 6, ahora con un IDS

Es **la misma captura** que investigaste a mano en la clase 6 (el MitM). Antes te tomó una hora.

```
ct-alertas mitm_clase6.pcap
```

**Mínimo:** sale **una sola** alerta. Ese es el momento clave: una regla habría cantado en segundos lo que reconstruiste paquete a paquete. Fijate su SID.
```
ct-bandera 3.2 <SID>
```

**Completo — el punto ciego:** Suricata **no inspecciona ARP**, así que el ataque real (la suplantación del gateway) es **invisible** para él. La credencial la cantó; el envenenamiento, no. Sacá del pcap la **MAC que suplantó al gateway** — la que el IDS nunca te reportó:
```
tshark -r /opt/ct/pcaps/mitm_clase6.pcap -Y "arp.duplicate-address-detected" \
  -T fields -e arp.src.hw_mac | sort -u
```
```
ct-bandera 3.2c <MAC>     (¿sin idea? ct-pista 3.2c)
```

> Lección: un IDS de red es una capa, no toda la defensa. Lo que no inspecciona, no lo ve.

## 3.3 · ¿A dónde llama el malware?

La «factura» que abrió contabilidad dejó rastro:

```
ct-buscar malware.pcap
```

**Mínimo:** la IP a la que el equipo hace *beacon* una y otra vez es el **C2**. Usá el `jq` de los destinos HTTP.
```
ct-bandera 3.3 <IP del C2>
```

**Completo:** antes de llamar al C2 por IP, el equipo **resolvió un dominio** por DNS. Cazalo con jq sobre las respuestas DNS:
```
ct-bandera 3.3c <dominio>     (¿sin idea? ct-pista 3.3c)
```

---

**Cerraste el Bloque A** cuando tenés al menos los tres mínimos. Los completos suman. Ahora te toca escribir una regla.
