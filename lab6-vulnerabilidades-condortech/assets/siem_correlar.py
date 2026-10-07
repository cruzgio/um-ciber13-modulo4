#!/usr/bin/env python3
"""Mini-SIEM de la clase 11 (Cóndor Tech): de evento crudo a alerta correlacionada.

Uso:  siem_correlar.py normalizar <access.log>      → muestra la normalización (campos comunes)
      siem_correlar.py correlar  <access.log>       → aplica 3 reglas y emite alertas
Acepta logs de acceso en formato combinado (nginx/apache) y líneas de gunicorn/CTFd con la misma forma.
Las IPs listadas en EXCLUIR nunca se imprimen (IP del docente).
"""
import re, sys, collections, datetime

EXCLUIR = {"181.63.25.119"}
RE = re.compile(r'^(?P<ip>\d+\.\d+\.\d+\.\d+)\s+\S+\s+\S+\s+\[(?P<ts>[^\]]+)\]\s+"(?P<metodo>[A-Z]+)\s+(?P<ruta>\S+)[^"]*"\s+(?P<status>\d{3})\s+(?P<bytes>\S+)(?:\s+"(?P<ref>[^"]*)"\s+"(?P<ua>[^"]*)")?')

def parse(path):
    evs = []
    for n, line in enumerate(open(path, errors="replace"), 1):
        m = RE.match(line.strip())
        if not m: continue
        d = m.groupdict()
        if d["ip"] in EXCLUIR: continue
        try: d["t"] = datetime.datetime.strptime(d["ts"].split()[0], "%d/%b/%Y:%H:%M:%S")
        except ValueError: continue
        d["status"] = int(d["status"]); d["linea"] = n
        evs.append(d)
    return evs

def normalizar(path):
    evs = parse(path)
    print(f"== 2) Normalizar: {len(evs)} eventos → campos comunes (src_ip, hora, acción, recurso, resultado, agente) ==")
    print(f"{'src_ip':<16}{'hora':<20}{'acción':<7}{'recurso':<28}{'resultado':<10}agente")
    for e in evs[:6] + evs[-6:]:
        print(f"{e['ip']:<16}{e['t'].strftime('%Y-%m-%d %H:%M:%S'):<20}{e['metodo']:<7}{e['ruta'][:26]:<28}{e['status']:<10}{(e['ua'] or '')[:30]}")
    print("...")
    por_ip = collections.Counter(e["ip"] for e in evs)
    print(f"\nFuentes distintas: {len(por_ip)}. Las 5 más activas: {por_ip.most_common(5)}")
    print("Esto ya se puede contar, agrupar y comparar. Todavía no es una alerta.")

def ventana(evs, pred, ventana_s, umbral, nombre, que_mirar):
    """Regla de umbral en ventana deslizante por IP."""
    alertas = []
    por_ip = collections.defaultdict(list)
    for e in evs:
        if pred(e): por_ip[e["ip"]].append(e)
    for ip, lst in por_ip.items():
        lst.sort(key=lambda e: e["t"]); i = 0
        for j in range(len(lst)):
            while (lst[j]["t"] - lst[i]["t"]).total_seconds() > ventana_s: i += 1
            if j - i + 1 >= umbral:
                alertas.append((lst[i]["t"], ip, nombre, j - i + 1, ventana_s, que_mirar)); break
    return alertas

def correlar(path):
    evs = parse(path)
    print(f"== 3) Correlar: {len(evs)} eventos normalizados → reglas con umbral y ventana ==")
    reglas = [
        ("R1 escaneo de rutas", lambda e: e["status"] == 404, 60, 20, "una IP busca >20 rutas inexistentes en 1 min (T1595 reconocimiento activo)"),
        ("R2 fuerza bruta de login", lambda e: e["ruta"].startswith("/login") and e["metodo"] == "POST" and e["status"] in (401, 403), 120, 10, "≥10 intentos fallidos de login en 2 min desde la misma IP (T1110)"),
        ("R3 primer contacto externo", None, 0, 0, "primera petición que no viene de una IP conocida del curso: cuánto tardó el descubrimiento"),
    ]
    alertas = []
    for nombre, pred, w, u, desc in reglas:
        if pred: alertas += ventana(evs, pred, w, u, nombre, desc)
    # R3: primer visitante con agente de escáner o fuera de las primeras N fuentes
    primeros = [e for e in evs if e["ua"] and re.search(r"zgrab|masscan|nmap|python-requests|curl|Go-http", e["ua"], re.I)]
    if primeros:
        e = primeros[0]; alertas.append((e["t"], e["ip"], "R3 primer contacto automatizado", 1, 0, f"agente «{e['ua'][:30]}» — primera herramienta automatizada que tocó el servicio"))
    alertas.sort()
    if not alertas:
        print("Sin alertas con estas reglas. ¿Umbral demasiado alto, o el log no trae lo que buscas?"); return
    print(f"\n{len(evs)} eventos crudos → {len(alertas)} ALERTAS. Esto sí lo puede mirar una persona:\n")
    for t, ip, nombre, n, w, desc in alertas:
        print(f"  [{t.strftime('%Y-%m-%d %H:%M:%S')} UTC]  {nombre:<32} src={ip:<16} n={n:<3} {desc}")
    print("\nLa pregunta de Target: ¿quién recibe estas alertas, con qué prioridad y qué hace en los primeros 15 minutos? Sin dueño, no es monitoreo: es mirar.")

if __name__ == "__main__":
    if len(sys.argv) < 3: print(__doc__); sys.exit(2)
    {"normalizar": normalizar, "correlar": correlar}[sys.argv[1]](sys.argv[2])
