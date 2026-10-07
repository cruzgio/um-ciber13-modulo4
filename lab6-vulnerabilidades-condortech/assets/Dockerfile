# Imagen del carrito de Cóndor Tech. Para remediar: edita requirements.txt y reconstruye (ct-construir).
FROM python:3.8-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
ENV PASARELA_URL=http://pasarela.condortech.local/cobrar
EXPOSE 8080
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]
