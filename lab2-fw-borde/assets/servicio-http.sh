#!/usr/bin/env bash
# Responde una petición HTTP mínima. $1 = clave del cuerpo (sin espacios).
CUERPO="$(cat "/opt/ct/cuerpos/${1}.txt" 2>/dev/null)"
printf 'HTTP/1.1 200 OK\r\nServer: condor-tech\r\nContent-Type: text/plain\r\nContent-Length: %s\r\nConnection: close\r\n\r\n%s' "${#CUERPO}" "$CUERPO"
