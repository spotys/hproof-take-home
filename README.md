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

```bash
export ARM_SUBSCRIPTION_ID="<your-subscription-id>"
export GOOGLE_CREDENTIALS="<google-service-account>"
az login
gcloud auth application-default login
```

## Bootstraping the Azure Subscription

Bootstraping is a one off process which sets the given Azure Subscription up for the Take Home Assesment tasks.

During this phase a storage account gets created for saving the terraform state files of the later stages. As this is the first step of the entire process it's state file is stored locally and it's safe to store it in a git repository as long as it doesn't contain any sensitive information.

To bootstrap your Azure Subscription run the following commands in your git root, after cloing this repository.

```bash
> cd terraform
> ./bootstrap-azure.sh
```

## Setting up the environment in Azure

```bash
> cd terraform
> ./setup-environment.sh
```

## Rotating a Google Maps API Key

```bash
> cd terraform
> ./rotate-secret.sh
```

A git-ops driven manual API key rotation is possible by changing the `vars/rotate-secret.hproof-take-home.tfvars:gcp/rotation/manual` token.

## Automation with a GitHub Workflow

A GitHub Workflow has been setup to demostrate the automated API Key rotation functionality. It's working against a pre-set pair of Google and Azure accounts. To avoid additional resources being created in those accounts aside of what's required by this Take Home Assesment, the access to the repository is restricted to read-only. Therefore no changes can be made to the terraform code or the GH workflow. Access tokens to the Google and Azure accounts are stored in GitHub secret store and are therefore hidden from repo users.

The GH workflow is running periodically (every hour) and runs the `terraform/rotate-secret.sh` script which is pre-set to rotate the API key once a day (meaning that only one in any series of 24 consecutive executions actually rotates the API key).

The git-ops driven manual API key rotaion is only available to users with a rw-access to this repo.

### GitHub Environment Setup

#### Secrets

#### Workflow
