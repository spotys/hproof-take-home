# hyperproof.io Take Home Assessment

The [hyperproof take-home assessment](doc/take-home-assessment.md) as well as the [Updated Problem Statement](doc/problem-statement.md) are available in the `doc` folder.

`Table of Contents`

- [Prerequisites](#prerequisites)
- [Local Environment Setup](#local-environment-setup)
- [Remote Environment Setup](#remote-environment-setup)
- [Bootstraping the Azure Subscription](#stage-1-bootstraping-the-azure-subscription)
- [Setting up the environment in Azure and Google cloud](#stage-2-setting-up-the-environment-in-azure-and-google-cloud)
- [Rotating a Google Maps API Key on a regular basis](#stage-3-rotating-a-google-maps-api-key-on-a-regular-basis)
- [Automation with a GitHub Workflows](#automation-with-a-github-workflows)
- [References](#references)
- [Lessons Learned](#lessons-learned)

## Prerequisites

0. A functional git client

1. A google account with user credentials. Get the following information ready:

    - your credentials

2. An Azure tenant and subscription. Get the following information ready:

    - subscription ID
    - your credentials

## Local Environment Setup

Local Environments are laptops or temprorary hosts used for brake-glass scenarios where users authenticate with their own credentials.

```bash
export ARM_SUBSCRIPTION_ID="<your-subscription-id>"
az login --scope https://management.core.windows.net//.default
gcloud auth application-default login
```

## Remote Environment Setup

Remote Environments are systems used to do some work in an automated fashion. In our case this is a GitHub SaaS solution.
These envs require separate authentication methods i.e. a Service Account for Google and a Service Principal for Azure cloud in this case.

We will run both the API key rotation process as well as the app/service process in a GitHub workflow.

The following set of environemnt variables is needed to run Terraform (the API key rotation process):

```bash
export GOOGLE_CREDENTIALS="<google-credentials-json>"                   # Service Account auth
export ARM_CLIENT_ID="<azure-service-principal-client-id>"              # Azure Servcie Principal auth
export ARM_CLIENT_SECRET="<azure-service-principal-client-secret>"      # Azure Servcie Principal auth
export ARM_SUBSCRIPTION_ID="<your-subscription-id>"                     # Azure Subscription ID
```

The following set of environemnt variables is needed to run Azure CLI (the app/service process):

```bash
export AZURE_CLIENT_ID="<azure-service-principal-client-id>"              # Azure Servcie Principal auth
export AZURE_CLIENT_SECRET="<azure-service-principal-client-secret>"      # Azure Servcie Principal auth
export AZURE_SUBSCRIPTION_ID="<your-subscription-id>"                     # Azure Subscription ID
```

The GitHub Workflows are pre-configured to work with a specific pair of Google and Azure accounts.
The environment variables are populated from GitHub secret store. For more info see the [GitHub Workflows Section](#automation-with-a-github-workflows)

## [Stage 1] Bootstraping the Azure Subscription

Bootstraping is a one off process which sets the given Azure Subscription up for the Take Home Assesment tasks.

During this phase a storage account gets created for saving the terraform state files of the later stages. As this is the first step of the entire process it's state file is stored locally and it's safe to store it in a git repository as long as it doesn't contain any sensitive information.

There is a terrafrorm target under `terraform/targets/boostrap-azure` with the `terraform/vars/boostrap-azure.terraform-shared.tfvars` tfvars file.

This step is intended to be run from a `local environment`.
To bootstrap your Azure Subscription run the following commands in your git root:

```bash
> cd terraform
> ./bootstrap-azure.sh
```

## [Stage 2] Setting up the environment in Azure and Google cloud

The take-home assignment requires a bunch of resources that can either be spun up manually or by a terraform code.
There is a terrafrorm target under `terraform/targets/setup-environment` with the `terraform/vars/setup-environment.hproof-take-home.tfvars` tfvars file. The TF state file is stored in Azure Storage Account Container bootstraped during `Stage 1`. The following resources are provisioned:

Azure

- resource group
- KeyVault
- Service Principal (with a few role assignments)

Google

- Project
- Services enabled (apikeys.googleapis.com, static-maps-backend.googleapis.com)
- Service Account (with some IAM bindings and an SA key)

This step is intended to be run from a local environment.
To setup all necessary Azure and Google resources run the following commands in your git root:

```bash
> cd terraform
> ./setup-environment.sh
```

## [Stage 3] Rotating a Google Maps API Key

The Google Maps API key gets rotated with a terraform target under `terraform/targets/rotate-secret` with the `terraform/vars/rotate-secret.hproof-take-home.tfvars` tfvars file. The TF state file is also stored in Azure Storage Account Container bootstraped during `Stage 1`.

This step is intended to be run from a local or remote environment.

```bash
> cd terraform
> ./rotate-secret.sh
```

This terraform target rotates the key every 4 hours therefore consecutive runs of this target do not necessarily rotate the key.

## Automation with a GitHub Workflows

GitHub Workflows have been setup in `.github/workflows` to demostrate the automated API Key rotation and the API Key read functionality. They work with a pair of personal Google and Azure accounts. To avoid additional resources being created in those accounts aside of what's required by this Take Home Assesment, the access to the repository is restricted to read-only. Therefore no changes can be made to the terraform code or the GH workflow. Access tokens to the Google and Azure accounts are stored in GitHub secret store and are therefore hidden from repo users.

### API Key Rotation Workflow

This GH workflow is running periodically (every hour) and runs the `terraform/rotate-secret.sh` script which is pre-set to rotate the API key every 4 hours regardles of how many times the workflow runs in that time period.

The Workflow can also be triggered manually from the [GitHub UI](https://github.com/spotys/hproof-take-home/actions/workflows/rotate-api-key.yaml) by clicking the `Run workflow` button at the top right.

### Read API Key Workflow

This GH workflow can only be run on-demand from the [GitHub UI](https://github.com/spotys/hproof-take-home/actions/workflows/get-api-key.yaml) by clicking the `Run workflow` button at the top right. It simulates the app/service and runs a custom script using Azure CLI:

```bash
> az keyvault secret show --vault-name="hproof-take-home-kv" --name="GoogleMapKey"
```

## References

I created the entire repo content myself with use of the following tools:

- [Google Search](https://www.google.com) (for general documentation searches)
- [Stack Overflow](https://www.stackoverflow.com) (for troubleshooting)
- [Terraform Documentation](https://registry.terraform.io/browse/providers)
- [GitHub Documentation](https://docs.github.com/en/actions)
- [Google Cloud Documentation](https://cloud.google.com/docs)
- [Azure Documentation](https://learn.microsoft.com/en-us/azure/?product=popular)

AI was used to neither generate any part of the code nor document the work. It wasn't used in any other context of this work either.

## Lessons Learned

### The rotation logic language choice

An important thing about this work is that the API keys have to stay functional even after being rotated to avoid app/service failures before all pods get restarted (and reconfigured with the new API key) - as described in the [problem statement doc](doc/problem-statement.md) mentioned above.

I haven't fully realised what effect this would have on Terraform code. Although it's still doable with Terraform,  the readability suffers. I'll rather go with an imperative language like JS or Go for this logic next time.

### Google Cloud

I've never worked with GCP before and it took me some time to figure out how things are organised and configured.

### Azure Cloud

Although I've worked with Azure in the past, I'm still not fluent with Azure IAM, Access Polices, RBAC and other authorization and access related features. I fought with
service principal authorization and access policies.

### AI

I'm not sure about the code in this case, but perhaps I could have tried using AI for some parts of the documentation and navigation through different cloud provider specifics. It could have reduced the time needed to complete the work and improve the documentation readability.
