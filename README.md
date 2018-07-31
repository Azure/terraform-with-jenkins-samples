# Provision & Deprovision Azure VM and VMSS using Terraform and a Jenkins pipeline

[Terraform](https://www.terraform.io/) enables you to safely and predictably provision, change, and improve infrastructure using [plans](https://www.terraform.io/docs/commands/plan.html) and [commands](https://www.terraform.io/docs/commands/index.html). This repo contains Terraform plans & commands for provisioning an [Azure VMSS](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview) from an image using a Jenkins pipeline.

![jenkins](https://user-images.githubusercontent.com/17064840/34257878-57d1f228-e664-11e7-98bd-4a1e63b3860c.png)
![image](https://user-images.githubusercontent.com/17064840/34257086-1293ab1e-e661-11e7-88c5-a23e3b0b1502.png)


## Requirements

To use Terraform it is required to have Azure Service Principal.<br/>
Create an Azure Service Principal through [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/provision-an-azure-service-principal-azure-cli?toc=%2fazure%2fazure-resource-manager%2ftoc.json) or [Azure portal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-provision-service-principal-portal).


#### Windows
- [Docker for Windows](https://docs.docker.com/docker-for-windows/)
- It is recommended to use [WSL](https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly) with Docker or change variables such as `${PWD}` to their Windows equivalents.

#### macOS
- [Docker for Mac](https://docs.docker.com/docker-for-mac/)
   

#### Kubernetes
1. [Kubernetes](https://docs.microsoft.com/en-us/azure/aks/)
2. [Helm](https://www.helm.sh/)
3. [Jenkins in Kubernetes](https://hub.kubeapps.com/charts/stable/jenkins)
4. [Azure Container Registry](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-prepare-acr)

## Contents

1. Build Docker image with Azure CLI and Terraform. This image will be used later locally or with Jenkins in Kubernetes
2. Deployment
    - Provision Azure VM from Azure Marketplace plan.
    - Provision a VM image plan.
    - Provision VM or VMSS from a VM image.


### 1. Create Docker image with Azure CLI and Terraform. [Dockerfile](/terraform-az/Dockerfile)

- Build
    ```
    docker build -t <acrLoginServer>/terraform-az terraform
    ```

- Optional: Run locally
    ```
    docker run --rm -v ${PWD}:/opt/workspace -v ~/.ssh:/.ssh -it <acrLoginServer>/terraform-az terraform
    ```

    **Note**

    The Docker run commands contains:
    1. `-v ${PWD}:/opt/workspace`. This mount points to the current folder that contains the current scripts.
    2. `-v ~/.ssh:/.ssh`. This mounts the SSH public and private keys that are neccessary the VM's and images creation. You don't need it if you change your terraform plans to use only passwords.
    3. Set the Service Principal credentials in the container with the following environment variables:
    ```
    -e ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID -e ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET -e ARM_TENANT_ID=$AZURE_TENANT_ID -e ARM_CLIENT_ID=$AZURE_CLIENT_ID
    ``` 

- Push the Docker image to Azure Container Registry
    ```
    docker push <acrLoginServer>/terraform-az
    ```

<hr/>

### 2. Deployment Options

#### Run locally
 - Provision an Ubuntu VM from a marketplace image. 
[Example.sh](/from-marketplace/example.sh)
 - Provision a managed VM image from a VM.
 [Example.sh](/provision-image/example.sh)
 - Provision VMSS from a VM image. [Example.sh](/from-image/vmss/example.sh)


#### Jenkins Pipeline in Kubernetes
 - Provision an Ubuntu VM from a marketplace image. 
[Jenkinsfile](/jenkins/pipeline/from-marketplace/Jenkinsfile)
 - Provision a managed VM image from a VM.
 [Jenkinsfile](/jenkins/pipeline/create-image/Jenkinsfile)
 - Provision VMSS from a VM image. 
    - Create Kubernetes [secret](/jenkins/pipeline/terraform-az-secret.yaml) with Azure Service principal. This is required for the following pipelines.
    - Setup [Azure Storage](https://docs.microsoft.com/en-us/azure/storage/common/storage-java-jenkins-continuous-integration-solution) in Jenkins and modify the pipelines accordingly with the relevant id, credentials and container name.
    - Jenkins Pipeline (Provision) [Jenkinsfile](/jenkins/pipeline/from-image/vmss/provision/Jenkinsfile)
    - Jenkins Pipeline (Deprovision) [Jenkinsfile](/jenkins/pipeline/from-image/vmss/deprovision/Jenkinsfile)

    ***The VMSS plan and tfstate are saved in Azure Blob Storage under `plans` and `tfstate` storage containers to support better automation***

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.