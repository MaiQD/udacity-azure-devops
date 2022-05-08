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
1. Create a new Azure policy

Open folder containing the resources you want to deploy with terminal.\
Run the following command to deploy the policy:

```bash
az policy definition create -n "tagged-policy" --mode All --rules "./tagging-policy.rules.json" --description "Ensures all indexed resources are tagged"
```
```bash
az policy assignment create --policy "tagged-policy" -n "tagged-policy" --description "Ensures all indexed resources are tagged"
```
### Output
1. You should see the following output when you use `az policy assignment list` to show the list of policy assignment:
![list policy assignment](assets/tagged-policy.png)