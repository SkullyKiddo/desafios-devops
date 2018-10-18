#!/bin/bash
clear

# Sets AWS Access Key
printf "AWS Access Key: "
read access_key
clear

# Sets AWS Secret Key
printf "AWS Secret Key: "
read secret_key
clear

# Terraform commands
terraform init
terraform destroy -var access_key=${access_key} -var secret_key=${secret_key}
