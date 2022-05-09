# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction

For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started

1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies

1. Create an [Azure Account](https://portal.azure.com)
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

## Instructions
1. Login to Azure
```bash
az login
```
2. Create a new Azure policy

Open folder containing the resources you want to deploy with terminal.\
Run the following command to deploy the policy:

```bash
az policy definition create -n "tagged-policy" --mode All --rules "./tagging-policy.rules.json" --description "Ensures all indexed resources are tagged"
```
```bash
az policy assignment create --policy "tagged-policy" -n "tagged-policy" --description "Ensures all indexed resources are tagged"
```

3. Create a new Azure resource group
```bash
az group create -l "eastasia" -n "udacity-vm-images" --tags "udacity[=project1]"
```

4. Deploy a new image to Azure
```bash
packer build  -var 'subscription_id=YOUR_SUBSCRIPTION_ID' .\server.json
```
### Output
1. You should see the following output when you use `az policy assignment list` to show the list of policy assignment:
![list policy assignment](assets/tagged-policy.png)
2. When you use `az image show -n "udacity-vm-image" -g "udacity-vm-images"`, you should see the detail of following image:
![vm image deploy by packer](assets/udacity-vm-image.png)