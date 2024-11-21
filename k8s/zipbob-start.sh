#!/bin/sh

# echo "\n🔌 Enabling NGINX Ingress Controller...\n"
# kubectl apply -f ./platform/development/ingress
# sleep 15

echo "\n📦 Deploying platform services's config..."
kubectl apply -f ./platform/development/services/config
sleep 3

echo "\n📦 Deploying platform services..."
kubectl apply -f ./platform/development/services
sleep 1


echo "\n📦 Deploying applications..."
kubectl apply -f ./applications/development
sleep 2

echo "\n⛵ Just a little more patience, and everything will be deployed!\n"
echo "\n⛵ Happy Sailing!\n"