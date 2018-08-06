# Provision & Deprovision Azure VMSS using Terraform and a Jenkins pipeline

[Terraform](https://www.terraform.io/) enables you to safely and predictably provision, change, and improve infrastructure using [plans](https://www.terraform.io/docs/commands/plan.html) and [commands](https://www.terraform.io/docs/commands/index.html). This repo contains Terraform plans & commands for provisioning an [Azure VMSS](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview) from an image using a Jenkins pipeline.

![image](https://user-images.githubusercontent.com/17064840/34257086-1293ab1e-e661-11e7-88c5-a23e3b0b1502.png)



## Requirements

*The Jenkins pipelines in this repo leverage Kubernetes features such as pods and secrets while providing an elastic slave pool (each build runs in new pods).*

To use Terraform it is required to have Azure Service Principal.<br/>
Create an Azure Service Principal through [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/provision-an-azure-service-principal-azure-cli?toc=%2fazure%2fazure-resource-manager%2ftoc.json) or [Azure portal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-provision-service-principal-portal).

1. Install [Docker](https://www.docker.com/community-edition) on your computer.
2. Install [Kubernetes](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-deploy-cluster)
3. Install [Jenkins in Kubernetes](https://hub.kubeapps.com/charts/stable/jenkins) with [Helm](https://www.helm.sh/)
4. Provision a container registry such as [Azure Container Registry](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-prepare-acr) or create an account with [DockerHub](https://hub.docker.com/).

## Contents

1. Build Docker image with Azure CLI and Terraform. This image will be used later in Jenkins pipeline deployed in Kubernetes
2. Deployment
    - Provision Azure VM from Azure Marketplace plan.
    - Provision a VM image plan.
    - Provision VM or VMSS from a VM image.


### 1. Create Docker image with Azure CLI and Terraform. [Dockerfile](/terraform-az/Dockerfile)

- Build
    ```
    docker build -t <containerRegistry>/terraform-az terraform
    ```

- Push the Docker image to Azure Container Registry
    ```
    docker push <containerRegistry>/terraform-az
    ```

<hr/>

### 2. Deployment - Jenkins Pipeline in Kubernetes
- Provision VMSS from a VM image. 
    - Create Kubernetes [secret](/jenkins-pipelines/terraform-az-secret.yaml) with Azure Service principal. This is required for the following pipelines.
    - Setup [Azure Storage](https://docs.microsoft.com/en-us/azure/storage/common/storage-java-jenkins-continuous-integration-solution) in Jenkins and modify the pipelines accordingly with the relevant id, credentials and container name.
    - Jenkins Pipeline (Provision) [Jenkinsfile](/jenkins-pipelines/create-vmss-from-image/provision/Jenkinsfile)
    - Jenkins Pipeline (Deprovision) [Jenkinsfile](/jenkins-pipelines/create-vmss-from-image/deprovision/Jenkinsfile)

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
