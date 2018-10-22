#!/bin/bash

# Set up Minikube
eval $(minikube docker-env)
minikube addons enable ingress

# Builds docker image
docker build -t idwall-app .

# Initiate pods
kubectl create -f idwall-chart/templates/namespace.yaml || kubectl apply -f idwall-chart/templates/namespace.yaml
kubectl create -f idwall-chart/templates/service.yaml || kubectl apply -f idwall-chart/templates/service.yaml
kubectl create -f idwall-chart/templates/deploy.yaml || kubectl apply -f idwall-chart/templates/deploy.yaml
kubectl create -f idwall-chart/templates/ingress.yaml || kubectl apply -f idwall-chart/templates/ingress.yaml

# Set host on current machine
host=$(kubectl get ingresses.extensions --namespace=idwall-app --no-headers | awk {'print $2'})

if ! grep -q "$host" /etc/hosts; then
	echo "$(minikube ip) $host" | sudo tee -a /etc/hosts
fi

# Prints host to operator
LIGHT_GREEN="\033[1;32m"
NC="\033[0m"
echo ""
echo -e "${LIGHT_GREEN}Please access: $host${NC}"