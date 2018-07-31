#! /bin/sh

export storage_name="terraformfiles"
export deployment="client01"


plan_filename=$deployment".tar.gz"
az storage blob download -f $plan_filename -c plans -n $plan_filename --account-name $storage_name --account-key $storage_access_key
tar -xzvmf $plan_filename

docker run --rm -v ${PWD}:/opt/workspace -it \
-e ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID -e ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET -e ARM_TENANT_ID=$AZURE_TENANT_ID -e ARM_CLIENT_ID=$AZURE_CLIENT_ID \
<acrLoginServer>/terraform-az terraform destroy -force -var="terraform_image_id=foo"

rm $plan_filename
rm -Rf .terraform
rm tfplan
rm *.tfstate