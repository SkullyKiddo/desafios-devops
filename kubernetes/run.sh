#!/bin/bash

# Set up Minikube
eval $(minikube docker-env)
minikube addons enable ingress

# Builds docker image
docker build -t idwall-app .

# Initiate pods
helm upgrade --install --namespace=idwall-app idwall-app ./idwall-chart/

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