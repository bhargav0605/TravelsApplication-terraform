#!/bin/bash

set -e

terraform init

# terraform plan -var-file ./_dev.tfvars -input=false -no-color -out dev.plan
terraform plan -var-file ./_dev.tfvars -input=false -out dev.plan

# read -p "Do you want to proceed with terraform apply? (y/n): " confirm
# Ask user for confirmation before proceeding with a timeout of 30 seconds
echo "Do you want to proceed with terraform apply? (y/n): "
if ! read -t 30 -p "Your choice: " confirm; then
  echo "Time limit exceeded. Please run the script manually."
  exit 1
fi

if [[ "$confirm" == "y" ]]; then
    terraform apply -input=false dev.plan
    terraform output -raw ssh-pem > ./ssh-key.pem
    # chmod 400 ./ssh-key.pem
    echo "Terraform apply completed and SSH key saved."

    # Extract the EC2 instance public IP address
    public_ip=$(terraform output -raw webserver-ec2-ip)

    # Create the SSH login command
    ssh_command="ssh -i ./ssh-key.pem ubuntu@$public_ip"

    # Create a temporary alias for the done command
    # alias done='terraform destroy -var-file ./_dev.tfvars -input=false -auto-approve'

    # echo "Temporary alias 'done' created."
    # echo "You can now use the 'done' command to destroy the infrastructure."

    # Create the destroy script file
  cat << 'EOF' > destroy.sh
#!/bin/bash

# Delete the infrastructure
terraform destroy -var-file ./_dev.tfvars -input=false -no-color -auto-approve

# Remove the PEM file
rm -f ./ssh-key.pem

# Remove this script
rm -f "$0"
EOF

  # Make the destroy script executable
  chmod +x destroy.sh

  # Print SSH login command in color
  echo -e "\e[32mTo log in to your EC2 instance, use the following command:\e[0m"
  echo -e "\e[34m$ssh_command\e[0m"
  chmod 400 ./ssh-key.pem
  echo -e "\e[32mDestroy script created as 'destroy.sh'.\e[0m"
  echo "Run './destroy.sh' to destroy the infrastructure, delete the PEM file, and remove this script."

else
    echo "Aborted by the user."
    exit 1
fi

# terraform destroy -var-file=./_dev.tfvars -input=false -no-color  -auto-approve
