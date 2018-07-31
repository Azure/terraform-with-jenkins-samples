#! /bin/sh

server=$(az vm show -d -g $vm_rg -n $vm_name --query "{VMIp:publicIps}" --out tsv)

ssh -i ~/.ssh/id_rsa -oStrictHostKeyChecking=no $user@$server << EOF
  sudo waagent -deprovision+user -force;
  exit
EOF

az vm deallocate \
  --resource-group $vm_rg \
  --name $vm_name

az vm generalize \
  --resource-group $vm_rg \
  --name $vm_name

vm_id=$(az vm show -g $vm_rg -n $vm_name --query "{VMId:id}" --out tsv)

terraform init -input=false
terraform plan -input=false -var "terraform_resource_group="$vm_images_rg -var "terraform_image_name="$image_name -var "terraform_vm_id="$vm_id -var "terraform_azure_region="$location -out "tfplan"
terraform apply -input=false -auto-approve "tfplan"