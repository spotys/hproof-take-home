# hyperproof.io Take Home Assessment

A [detailed take-home assignment text](doc/take-home.md) as well as the [Implementation Considerations](doc/implementation-prep.md) are available in the `doc` folder. For this Take Home Assesment the Terraform approach is used.

`Table of Contents`

- `<TBD>`

## Prerequisites

0. A functional git client

1. A google account and project with functional billing and Maps API enabled. For more details see [Google Cloud Documentation](https://developers.google.com/maps/documentation/routes/cloud-setup#gcloud-project-create). Get the following information ready:

    - your credentials

2. An Azure tenant and subscription. Get the following information ready:

    - tenant ID
    - subscription ID
    - your credentials
    - GitHub service principal (client_id, client_secret)

## Local Environment Setup

Local environment means users laptops or temprorary hosts used for brake-glass scenarios where users authenticate with their own credentials.

```bash
export ARM_SUBSCRIPTION_ID="<your-subscription-id>"
az login
gcloud auth application-default login
```

## Remote Environment Setup

Remote environments are systems used to do some work in automated fashion. In our case this is a GitHub service.
Those envs require a separate authentication methods i.e. a Service Account for Google and a Service Principal for Azure cloud.

If those credentials are used, you need to provide following set of environemnt variables to the running process:

```bash
export GOOGLE_CREDENTIALS="<google-credentials-json>" 
export ARM_SUBSCRIPTION_ID="<your-subscription-id>"
export ARM_CLIENT_ID="<azure-service-principal-client-id>" 
export ARM_CLIENT_SECRET="<azure-service-principal-client-secret>" 
```

Remote systems have different ways of storing these credentials. For GitHub we can use their secret store. All the values need to be stored as GitHub secrets manually. They can referenced within the GH workflows/actions to define the environment variables.

TBD

## Bootstraping the Azure Subscription

Bootstraping is a one off process which sets the given Azure Subscription up for the Take Home Assesment tasks.

During this phase a storage account gets created for saving the terraform state files of the later stages. As this is the first step of the entire process it's state file is stored locally and it's safe to store it in a git repository as long as it doesn't contain any sensitive information.

There is a terrafrorm target under `terraform/targets/boostrap-azure` with the `terraform/vars/boostrap-azure.terraform-shared.tfvars` tfvars file.

This step is intended to be run from a local environment.
To bootstrap your Azure Subscription run the following commands in your git root:

```bash
> cd terraform
> ./bootstrap-azure.sh
```

## Setting up the environment in Azure and Google clouds

The take-home assignment requires a bunch of resources that can either be spun up manually or by a terraform code.
There is a terrafrorm target under `terraform/targets/setup-environment` with the `terraform/vars/setup-environment.hproof-take-home.tfvars` tfvars file.

This step is intended to be run from a local environment.
To setup all necessary Azure and Google resources run the following commands in your git root:

```bash
> cd terraform
> ./setup-environment.sh
```

## Rotating a Google Maps API Key on a regular basis

The Google Maps API key gets rotated with a terraform target under `terraform/targets/rotate-secret` with the `terraform/vars/rotate-secret.hproof-take-home.tfvars` tfvars file.

This step is intended to be run from a local or remote environment.

```bash
> cd terraform
> ./rotate-secret.sh
```

This terraform target rotates the key once a day therefore consecutive runs of this target do not actually rotate the key. To rotate the key immediatelly you can use a git-ops driven approach i.e. changing the `vars/rotate-secret.hproof-take-home.tfvars:gcp/rotation/manual` token and re-run the `rotate-secret.sh`.

## Rotating a Google Maps API Key after evry use

TBD

## Automation with a GitHub Workflow

A GitHub Workflow has been setup to demostrate the automated API Key rotation functionality. It's working against a pre-set pair of Google and Azure accounts. To avoid additional resources being created in those accounts aside of what's required by this Take Home Assesment, the access to the repository is restricted to read-only. Therefore no changes can be made to the terraform code or the GH workflow. Access tokens to the Google and Azure accounts are stored in GitHub secret store and are therefore hidden from repo users.

The GH workflow is running periodically (every hour) and runs the `terraform/rotate-secret.sh` script which is pre-set to rotate the API key once a day (meaning that only one in any series of 24 consecutive executions actually rotates the API key).

The git-ops driven manual API key rotaion is only available to users with a rw-access to this repo.

### Workflow

TBD
