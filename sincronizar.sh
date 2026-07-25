#!/usr/bin/env bash
# Lleva al repo del concurso los commits nuevos de cine-colombia-cli.
#
# Por qué no alcanza un `git push` a los dos remotos, como sugiere el README del
# hackathon: este repo tiene commits propios (la plantilla) y un merge, así que su
# historia no es un descendiente directo de la del código. Empujar una sobre la otra
# sería un non-fast-forward. Traer los cambios con merge sí funciona siempre.
set -euo pipefail

git fetch codigo main
git merge codigo/main --no-edit
git push origin main
echo "Listo: el repo del concurso quedó al día."
