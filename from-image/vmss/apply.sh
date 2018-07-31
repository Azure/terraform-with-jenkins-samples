#! /bin/sh

plan_filename=$deployment".tar.gz"
az storage blob download -f $plan_filename -c plans -n $plan_filename --account-name $storage_name --account-key $storage_access_key
tar -xzvmf $plan_filename
rm $plan_filename
terraform apply -input=false -auto-approve "tfplan"
tar -czvf $plan_filename .
az storage blob upload -f $plan_filename -c plans -n $plan_filename --account-name $storage_name --account-key $storage_access_key

rm -Rf .terraform
rm tfplan
rm *.tfstate