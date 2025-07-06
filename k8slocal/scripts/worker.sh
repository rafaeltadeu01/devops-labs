#!/bin/bash
set -e

echo "[Worker] Aguardando comando join.sh do master..."

# Aguarda o master criar o join.sh
while [ ! -f /vagrant/join.sh ]; do
  sleep 5
done

echo "[Worker] Executando join.sh para ingressar no cluster..."
bash /vagrant/join.sh
