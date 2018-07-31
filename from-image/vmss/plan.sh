#! /bin/sh

#deployment="client01"
#storage_access_key="<storage_access_key>"
#storage_name="terraformfiles"
#vm_images_rg="vm-images-RG"
#vmss_rg="vmss_RG"
#image_name="vmimage01"
#vmss_name="testvmss"
#location="northeurope"

image_id=$(az image show -g $vm_images_rg -n $image_name --query "{VMName:id}" --out tsv)

terraform plan -out=tfplan -input=false -var "terraform_resource_group="$vmss_rg -var "terraform_vmss_name="$vmss_name \
-var "terraform_azure_region="$location -var "terraform_image_id="$image_id

plan_filename=$deployment".tar.gz"
tar -czvf $plan_filename .
az storage container create -n plans --account-name $storage_name --account-key $storage_access_key
az storage blob upload -f $plan_filename -c plans -n $plan_filename --account-name $storage_name --account-key $storage_access_key
rm $plan_filename
rm -Rf .terraform
rm tfplan