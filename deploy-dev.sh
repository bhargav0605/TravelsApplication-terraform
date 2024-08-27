#!/bin/bash

set -e

terraform init

terraform plan -var-file ./_dev.tfvars -input=false -out dev.plan

echo "Do you want to proceed with terraform apply? (y/n): "
if ! read -t 30 -p "Your choice: " confirm; then
  echo "Time limit exceeded. Please run the script manually."
  exit 1
fi

if [[ "$confirm" == "y" ]]; then
    terraform apply -input=false dev.plan

    if [[ ! -f "ssh-pem" ]]; then
      terraform output -raw ssh-pem > ./ssh-key.pem
    else
      echo -e "PEM already generated, please use that."
    fi

    echo "Terraform apply completed and SSH key saved."

    public_ip=$(terraform output -raw webserver-ec2-ip)
    private_ip=$(terraform output -raw application-ec2-ip)

    pub_webserver_ssh_command="ssh -i ./ssh-key.pem ubuntu@$public_ip"
    pri_application_ssh_command="ssh -i ./ssh-key.pem ubuntu@$private_ip"

  cat << 'EOF' > destroy.sh
#!/bin/bash

# Delete the infrastructure
terraform destroy -var-file ./_dev.tfvars -input=false -auto-approve

# Remove the PEM file
rm -f ./ssh-key.pem

# Remove this script
rm -f "$0"
EOF

  # Make the destroy script executable
  chmod +x destroy.sh

  # Print SSH login command in color
  echo -e "\033[32mTo log in to your EC2 instance, use the following command:\033[0m"
  echo -e "\033[34m$pub_webserver_ssh_command\033[0m"
  echo -e "\033[34m$pri_application_ssh_command\033[0m"
  chmod 400 ./ssh-key.pem
  echo -e "\033[32mDestroy script created as 'destroy.sh'.\033[0m"
  echo "Run './destroy.sh' to destroy the infrastructure, delete the PEM file, and remove this script."

else
    echo "Aborted by the user."
    exit 1
fi