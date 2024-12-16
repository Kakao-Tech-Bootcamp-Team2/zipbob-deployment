#!/bin/sh

# echo "\n🔌 Enabling NGINX Ingress Controller...\n"
# kubectl apply -f ./platform/development/ingress
# sleep 15

CHART_DIR="./platform/development/helm/vault/vault"
if [ ! -d "$CHART_DIR" ]; then
  echo "\n📦Pulling and unpacking Vault Helm chart..."
  helm pull hashicorp/vault --untar --untardir $CHART_DIR
  sleep 3
else
  echo "Vault Helm chart already exists."
fi

echo "\n📦 Deploying Vault with custom overrides and auto-unseal configurations..."
helm install zipbob-vault \
./platform/development/helm/vault/vault \
-f ./platform/development/helm/vault/override-values.yaml \
-f ./platform/development/helm/vault/auto-unseal.yaml
sleep 1

echo "\n📦 Deploying platform & application services's config..."
kubectl apply -f ./platform/development/services/config
kubectl apply -f ./applications/development/config
sleep 3

echo "\n📦 Deploying platform services..."
kubectl apply -f ./platform/development/services
sleep 1


echo "\n📦 Deploying applications..."
kubectl apply -f ./applications/development
sleep 2

echo "\n⛵ Just a little more patience, and everything will be deployed!\n"
echo "\n⛵ Happy Sailing!\n"