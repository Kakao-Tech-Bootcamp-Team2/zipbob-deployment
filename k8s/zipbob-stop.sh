#!/bin/sh

echo "\n📦 Stopping platform services..."
kubectl delete -f ./platform/development/services
sleep 1

echo "\n📦 Stopping platform services's config..."
kubectl delete -f ./platform/development/services/config
sleep 2

echo "\n📦 Stopping applications..."
kubectl delete -f ./applications/development
sleep 2

# echo "\n🔄 Disabling NGINX Ingress Controller...\n"
# kubectl delete -f ./platform/development/ingress
# sleep 2

echo "\n⛵ All Clear!! Goodbye!\n"
