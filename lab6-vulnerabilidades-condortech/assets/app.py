# Carrito de compras de Cóndor Tech — versión "legacy" que Zona B puso en producción.
# Expuesto en el puerto 8080. NO cambies este archivo para remediar: cambia requirements.txt.
import os, yaml, requests
from flask import Flask, request, jsonify

app = Flask(__name__)
PASARELA = os.environ.get("PASARELA_URL", "http://pasarela.condortech.local/cobrar")
TOKEN = os.environ.get("PASARELA_TOKEN", "ct-token-demo")
CARRITO = {}

@app.route("/")
def inicio():
    return jsonify(servicio="carrito", version="legacy", items=len(CARRITO), estado="ok")

@app.route("/importar", methods=["POST"])
def importar():
    # Importa un carrito guardado que envía el cliente, en formato YAML
    datos = yaml.load(request.data, Loader=yaml.FullLoader)   # <- entrada del cliente
    if isinstance(datos, dict):
        CARRITO.update(datos)
    return jsonify(importados=len(CARRITO))

@app.route("/cobrar", methods=["POST"])
def cobrar():
    # Envía el carrito a la pasarela de pagos con el token en la cabecera
    try:
        r = requests.post(PASARELA, json=CARRITO, headers={"Authorization": "Bearer " + TOKEN}, timeout=2)
        return jsonify(pasarela=r.status_code)
    except Exception as e:
        return jsonify(error=str(e)), 502

# Miniaturas de producto: la función nunca se activó en producción (FEATURE_MINIATURAS=0),
# pero la dependencia Pillow quedó instalada en la imagen.
if os.environ.get("FEATURE_MINIATURAS") == "1":
    from PIL import Image
