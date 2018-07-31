#! /bin/sh

export user="azureuser"
export vm_rg="vm-RG"
export vm_images_rg="vm-images-RG"
export image_name="vmimage01"
export vm_name="vm"
export location="northeurope"


docker run --rm -v ${PWD}:/opt/workspace -it -e user=$user -e vm_rg=$vm_rg -e vm_images_rg=$vm_images_rg \
-e image_name=$image_name -e vm_name=$vm_name -e location=$location \
-e ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID -e ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET -e ARM_TENANT_ID=$AZURE_TENANT_ID -e ARM_CLIENT_ID=$AZURE_CLIENT_ID \
<acrLoginServer>/terraform-az bash create.sh