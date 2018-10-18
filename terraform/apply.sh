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

# Sets AWS Region
printf "AWS Region: "
read region 
clear


# Creates terraform.tfvars file with:
#  - Security Group (SSH) range IPs;
#  - Region;
i=0
input="."
outfile="./terraform.tfvars"
while [[ $input != "" ]]; do
	printf "Please add an IP (with mask - X.Y.Z.W/K) to the Security Group SSH IP range: "
    read input
    if [[ $input != "" ]]; then
      ips[$i]=\"$input\"
    fi
    ((i++))
    clear
    echo "Included $input to ip range"
    echo "TO END: leave the input empty and press ENTER"
done
clear

(IFS=', '; echo "ip_ssh_range = [ ${ips[*]} ]") > "${outfile}"
echo region = \"$region\" >> "${outfile}"

# Terraform commands
terraform init
terraform apply -var access_key=${access_key} -var secret_key=${secret_key}
