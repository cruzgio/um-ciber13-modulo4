# Lab 3 — El IDS de Cóndor Tech (Suricata offline)

Escenario de Killercoda para la Clase 7 del Módulo 4 (CIBER13, Universidad de Montevideo).

El estudiante opera un IDS (Suricata 7 + ET Open) en modo offline sobre tres capturas
de la red de Cóndor Tech: lee las alertas, caza lo que el IDS dejó pasar y escribe su
propia regla de detección. Doble nivel en cada checkpoint (mínimo / completo).

- `escaneo.pcap`  — barrido de puertos; dispara ET SCAN al SQL del ERP (SID 2010935).
- `mitm_clase6.pcap` — la MISMA captura de la clase 6; una regla local (clave=) canta la credencial (SID 9000001). Suricata es ciego al ARP: ese es el punto ciego (3.2c).
- `malware.pcap` — beacon a un C2 (203.0.113.66, dominio cdn-updates-pool.top) con User-Agent CondorLoader.

Banderas: categoría "Lab 3" en CTFd. Cárgalas con `CTFd_Lab3_Retos.csv`.
Publicación: https://killercoda.com/cruzgio/scenario/lab3-ids-condortech
