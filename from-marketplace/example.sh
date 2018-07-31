#! /bin/sh


#docker run --rm  -v ${PWD}:/opt/workspace -e ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID -e ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET -e ARM_TENANT_ID=$AZURE_TENANT_ID -e ARM_CLIENT_ID=$AZURE_CLIENT_ID -it <acrLoginServer>/terraform-az terraform destroy -force

docker run --rm -v ${PWD}:/opt/workspace -it \
-e ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID -e ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET -e ARM_TENANT_ID=$AZURE_TENANT_ID -e ARM_CLIENT_ID=$AZURE_CLIENT_ID \
<acrLoginServer>/terraform-az terraform init

docker run --rm -v ${PWD}:/opt/workspace -it \
-e ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID -e ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET -e ARM_TENANT_ID=$AZURE_TENANT_ID -e ARM_CLIENT_ID=$AZURE_CLIENT_ID \
<acrLoginServer>/terraform-az terraform plan -out "tfplan"

docker run --rm -v ${PWD}:/opt/workspace -it \
-e ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID -e ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET -e ARM_TENANT_ID=$AZURE_TENANT_ID -e ARM_CLIENT_ID=$AZURE_CLIENT_ID \
<acrLoginServer>/terraform-az terraform apply -input=false -auto-approve "tfplan"