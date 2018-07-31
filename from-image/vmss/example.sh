#! /bin/sh

export deployment="client01"
#export storage_access_key="<storage_access_key>"
export storage_name="terraformfiles"
export vm_images_rg="vm-images-RG"
export vmss_rg=$deployment"_RG"
export image_name="vmimage01"
export vmss_name="testvmss"
export location="northeurope"


docker run --rm -v ${PWD}:/opt/workspace -it -e deployment=$deployment -e storage_access_key=$storage_access_key -e storage_name=$storage_name \
-e vm_images_rg=$vm_images_rg -e image_name=$image_name \
-e ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID -e ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET -e ARM_TENANT_ID=$AZURE_TENANT_ID -e ARM_CLIENT_ID=$AZURE_CLIENT_ID \
<acrLoginServer>/terraform-az terraform init

docker run --rm -v ${PWD}:/opt/workspace -v ~/.ssh:/.ssh -it -e deployment=$deployment -e storage_access_key=$storage_access_key -e storage_name=$storage_name \
-e vm_images_rg=$vm_images_rg -e image_name=$image_name -e vmss_rg=$vmss_rg -e vmss_name=$vmss_name -e location=$location \
-e ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID -e ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET -e ARM_TENANT_ID=$AZURE_TENANT_ID -e ARM_CLIENT_ID=$AZURE_CLIENT_ID \
<acrLoginServer>/terraform-az bash plan.sh

docker run --rm -v ${PWD}:/opt/workspace -v ~/.ssh:/.ssh -it -e deployment=$deployment -e storage_access_key=$storage_access_key -e storage_name=$storage_name \
-e ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID -e ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET -e ARM_TENANT_ID=$AZURE_TENANT_ID -e ARM_CLIENT_ID=$AZURE_CLIENT_ID \
<acrLoginServer>/terraform-az bash apply.sh