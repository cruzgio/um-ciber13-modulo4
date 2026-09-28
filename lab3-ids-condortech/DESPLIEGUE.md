# Cómo publicar el Lab 3 en Killercoda

Igual que los labs anteriores: un `git push` a tu repo `um-ciber13-modulo4` y Killercoda
lo publica en menos de un minuto.

## Camino recomendado (usa el instalador de un solo archivo)

1. Cloná tu repo y entrá:
   ```
   git clone https://github.com/cruzgio/um-ciber13-modulo4.git
   cd um-ciber13-modulo4
   ```
2. Copiá `crear-lab3.sh` a la raíz del repo y corré:
   ```
   bash crear-lab3.sh
   ```
   Genera la carpeta `lab3-ids-condortech/` con los permisos de ejecución ya puestos
   (funciona en macOS y Linux; decodifica por stdin y usa shasum si hace falta).
3. Subí:
   ```
   git add -A && git commit -m "Lab 3: IDS Suricata" && git push
   ```
4. Cargá los nueve retos en CTFd:
   Admin → Challenges → Import CSV con `CTFd_Lab3_Retos.csv`
   (categoría "Lab 3"; activá las pistas nativas con costo 1 en los tres completos).

## Si preferís subir la carpeta a mano

Descomprimí `lab3-ids-condortech.zip` y copiá la carpeta a la raíz del repo, al lado de
las de los labs anteriores. Si subís por la web de GitHub, los scripts pierden el permiso
de ejecución: usá la línea de comandos, o corré después
`chmod +x lab3-ids-condortech/*.sh lab3-ids-condortech/assets/ct-*` y
`git update-index --chmod=+x` sobre esos archivos.

## Notas de operación

- El montaje descarga ET Open y pre-procesa los tres pcaps (~2 min). Abrí un escenario
  vos mismo 5 minutos antes de la clase para que quede caliente.
- Killercoda da 60 min de sesión en capa gratuita; el lab está partido en Bloque A / B
  para que quepa con holgura.
