
# Jenkins Pipeline installation guide

1. Create a Kubernetes secret with the following azure parameters:
```
  tenantid:
  subscriptionid:
  clientid:
  clientsecret:
```

You can find an example secret file [here](/jenkins-pipelines/terraform-az-secret.yaml)

2. Apply the secret file
    ```sh
    kubectl apply -f terraform-az-secret.yaml --namespace jenkins
    ```

2. Install Jenkins in Kubernetes
    ```sh
    helm install --name jenkins stable/jenkins --namespace jenkins
    ```

3. Install the Jenkins Azure Storage Plugin
![image](https://user-images.githubusercontent.com/17064840/43886692-3a82a64c-9bc5-11e8-8f40-483b731648cc.png)

4. Enter your Azure Storage Details
![image](https://user-images.githubusercontent.com/17064840/43887024-32a18f0a-9bc6-11e8-85ea-120b27812473.png)

5. (Optional) Enter your public ssh key for the new VMSS
5. Create a new pipeline
![image](https://user-images.githubusercontent.com/17064840/43887100-74231886-9bc6-11e8-8f9e-9f6001ff4e71.png)

6. Enter your pipeline parameters:
    1. `deployment` - The name of the deployment
    2. `vm_images_rg` - The name of the VM image resource group
    3. `vmss_rg` - The name of the VMSS resource group
    4. `image_name` - The name of the VM image
    5. `vmss_name` - The name of the VMSS
    6. `location` - The resources location name
![image](https://user-images.githubusercontent.com/17064840/43887162-a085a196-9bc6-11e8-9150-a388cf360715.png)
7. Replace the following values in the pipeline
    1. `<containerRegistry>` - The docker image with azure cli and Terraform
    2. `<your-secret-name>` - Kubernetes secret name
    3. Optional `<your-public-key-id>` - Your SSH public key for the VMSS.
    4. `<container-name>` - The Azure Blob storage container name to host the Terraform state files
    5. `<jenkins-storage-id>` - The id of the Azure Storage Credentials in Jenkins

8. Invoke the pipeline