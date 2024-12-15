# hyperproof.io Take Home Assessment

The [hyperproof take-home assessment](doc/take-home-assessment.md) as well as the [Problem Statement](doc/problem-statement.md) are available in the `doc` folder.

`Table of Contents`

- `<TBD>`

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

The following set of environemnt variables is need to run Terraform (the API key rotation process):

```bash
export GOOGLE_CREDENTIALS="<google-credentials-json>"                   # Service Account auth
export ARM_CLIENT_ID="<azure-service-principal-client-id>"              # Azure Servcie Principal auth
export ARM_CLIENT_SECRET="<azure-service-principal-client-secret>"      # Azure Servcie Principal auth
export ARM_SUBSCRIPTION_ID="<your-subscription-id>"                     # Azure Subscription ID
```

The following set of environemnt variables is need to run Go (the app/service process):

```bash
export AZURE_CLIENT_ID="<azure-service-principal-client-id>"              # Azure Servcie Principal auth
export AZURE_CLIENT_SECRET="<azure-service-principal-client-secret>"      # Azure Servcie Principal auth
export AZURE_SUBSCRIPTION_ID="<your-subscription-id>"                     # Azure Subscription ID
```

The GitHub Workflows are pre-configured to work with a specific pair of Google and Azure accounts.
The environment variables are populated from GitHub secret store.

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

## [Stage 2] Setting up the environment in Azure and Google clouds

The take-home assignment requires a bunch of resources that can either be spun up manually or by a terraform code.
There is a terrafrorm target under `terraform/targets/setup-environment` with the `terraform/vars/setup-environment.hproof-take-home.tfvars` tfvars file. The following resources are provisioned:

Azure

- resource group
- KeyVault
- Service Principal with some role assignments

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

## [Stage 3] Rotating a Google Maps API Key on a regular basis

The Google Maps API key gets rotated with a terraform target under `terraform/targets/rotate-secret` with the `terraform/vars/rotate-secret.hproof-take-home.tfvars` tfvars file.

This step is intended to be run from a local or remote environment.

```bash
> cd terraform
> ./rotate-secret.sh
```

This terraform target rotates the key once a day therefore consecutive runs of this target do not actually rotate the key. To rotate the key immediatelly you can use a git-ops driven approach i.e. changing the `vars/rotate-secret.hproof-take-home.tfvars:gcp/rotation/manual` token and re-run the `rotate-secret.sh`.

## Reading the API Key from Azure KeyVault

TBD

## Automation with a GitHub Workflow

A GitHub Workflow has been setup in `.github/workflows` to demostrate the automated API Key rotation functionality. It's working against a pre-set pair of Google and Azure accounts. To avoid additional resources being created in those accounts aside of what's required by this Take Home Assesment, the access to the repository is restricted to read-only. Therefore no changes can be made to the terraform code or the GH workflow. Access tokens to the Google and Azure accounts are stored in GitHub secret store and are therefore hidden from repo users.

The GH workflow is running periodically (every hour) and runs the `terraform/rotate-secret.sh` script which is pre-set to rotate the API key once a day (meaning that only one in any series of 24 consecutive executions actually rotates the API key).

The git-ops driven manual API key rotaion is only available to users with a rw-access to this repo.

### Workflow

TBD
