#!/bin/bash

eval $(minikube docker-env)
minikube addons enable ingress
docker build -t idwall-app .
kubectl create -f service.yaml || kubectl apply -f service.yaml
kubectl create -f deploy.yaml || kubectl apply -f deploy.yaml
kubectl create -f ingress.yaml || kubectl apply -f ingress.yaml
if ! grep -q "idwall-app.local.com" /etc/hosts; then
	echo "$(minikube ip) idwall-app.local.com" | sudo tee -a /etc/hosts
fi