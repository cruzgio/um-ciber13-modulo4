# Bloque A — reconocimiento (banderas 6.1 a 6.3)

Objetivo: entender **quién está en la red** y **quién miente**.

## 6.1 · ¿Cuántos hosts conversan?

En una captura, cada equipo tiene una dirección **MAC**. Contá cuántas MAC distintas aparecen (sin contar el `broadcast ff:ff:ff:ff:ff:ff`, que no es un equipo).

```
ct-abrir "eth" 
```
O directo:
```
tshark -r /root/caso/condor_incidente2.pcap -T fields -e eth.src -e eth.dst | tr '\t' '\n' | grep -v -i ffff | sort -u
```
Cuando tengas el número:  `ct-bandera 1 <número>`

## 6.2 · ¿Cuál es la IP del atacante?

Antes de atacar, el atacante estuvo en la red **como un equipo normal**: pidió el gateway por ARP con su IP real. Después empezó a mentir. Buscá su IP real:

```
ct-abrir "arp.opcode==1"
```
Fijate qué MAC luego aparece decenas de veces mintiendo, y qué IP tenía esa MAC cuando se comportaba normal.
`ct-bandera 2 <ip>`

## 6.3 · ¿Qué MAC suplanta al gateway?

El gateway real es `192.168.30.1`. Alguien más dice ser él. Wireshark te lo resalta como **«duplicate use of 192.168.30.1 detected»**:

```
ct-abrir "arp.duplicate-address-detected"
```
La MAC que se repite diciendo ser `192.168.30.1`, y que **no** es la del primer ARP legítimo, es la suplantada.
`ct-bandera 3 <mac>`

---

**Cuando tengas las tres, cerraste el Bloque A.** Si te quedaste sin tiempo, `ct-retomar` te deja seguir con el Bloque B sin repetir esto.
