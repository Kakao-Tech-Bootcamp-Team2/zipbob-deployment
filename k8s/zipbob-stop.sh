#!/bin/sh

echo "\n📦 Stopping platform services..."
kubectl delete -f ./platform/development/services
sleep 1

echo "\n📦 Stopping platform & application services's config..."
kubectl delete -f ./platform/development/services/config
kubectl delete -f ./applications/development/config
sleep 2

echo "\n📦 Stopping applications..."
kubectl delete -f ./applications/development
sleep 2

echo "\n📦 Stopping vault..."
helm delete zipbob-vault
sleep 2

# echo "\n🔄 Disabling NGINX Ingress Controller...\n"
# kubectl delete -f ./platform/development/ingress
# sleep 2

echo "\n⛵ All Clear!! Goodbye!\n"
