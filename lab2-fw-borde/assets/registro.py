#!/usr/bin/env python3
"""Lee el ruleset de nftables en JSON y trabaja con las reglas de registro.

  registro.py prefijos              < json      -> lista de prefijos
  registro.py disparado <json_antes> < json_despues -> prefijo cuyo contador subió
"""
import json, sys

def reglas_log(doc):
    """[(prefijo, paquetes)] de cada regla que tenga log con prefix."""
    out = []
    for item in doc.get("nftables", []):
        r = item.get("rule")
        if not r:
            continue
        prefijo, paquetes = None, None
        for e in r.get("expr", []):
            if "log" in e and isinstance(e["log"], dict) and "prefix" in e["log"]:
                prefijo = e["log"]["prefix"]
            if "counter" in e and isinstance(e["counter"], dict):
                paquetes = e["counter"].get("packets")
        if prefijo is not None:
            out.append((prefijo.strip(), paquetes))
    return out

def cargar(txt):
    try:
        return json.loads(txt)
    except Exception:
        return {"nftables": []}

modo = sys.argv[1] if len(sys.argv) > 1 else ""

if modo == "prefijos":
    for p, _ in reglas_log(cargar(sys.stdin.read())):
        print(p)

elif modo == "disparado":
    antes = {p: (c or 0) for p, c in reglas_log(cargar(sys.argv[2]))}
    for p, c in reglas_log(cargar(sys.stdin.read())):
        if c is None:
            continue
        if c > antes.get(p, 0):
            print(p)
            break
