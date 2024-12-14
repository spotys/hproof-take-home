# Implementation Considerations

## Initial Thoughts

The purpose of API key rotation is mainly an increased security. Therefore the rotation process should be fully automated i.e. run periodically in the background without any human intervention.

The API key rotation should be predictable in the sense that it should rotate the secret neither significantly faster nor slower than expected by security guidelines. Therefore it's desirable to maintain an inner state which allows for time based rotation. A solution which runs the workflow periodically at a specific time interval is indeed acceptable and the inner state is kept within the CD solution itself.

In the following sections I'm looking at various options of the automation logic. Different solutions take care of the rotation period in different ways. Some contain the full logic i.e. the rotation (aka state management) and the secret management, within a single unit of easily portable code which can be advatageous in case of migration to another CD system is required. Some have the state management hardcoded in the workflow while the secret management logic is done with a separate code/script.

Other metrics to look at across varous solutions could be:

- a use of industry standards (how hard it is for newcomers to get acquainted with the code)
- complexity e.g. code size (how hard is for dev/tech ops to understand the solution)
- execution time (how long it takes for the rotation to happen i.e. time to deliver)
- integration with the selected CD solution

## Terraform

The entire workflow could be implemented using `google` terraform provider plus the [`google_apikeys_key`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/apikeys_key) resource for creating a Google Maps Key and using the `azurerm` terraform provider plus [`azurerm_key_vault_secret`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) resources for storing the key as a secret in Azure KeyVault.

### Pros

- using an industry standard (terraform) that most dev/tech ops are familliar with
- entire business logic contained in the terraform code
  - easy migration from GitHub workflow to another CD system
  - easy to understand the entire solution
- state management built in terraform infra (the backend)

### Cons

- support for terraform in GitHub is not very good, only a text output from the `tf plan/apply` run is available, which is hard to read (good enough for small projects though)
- the execution time tends to be slower compared to the other options although not a big deal for this particular task

## CLI tools

Implemented with `google` and `azure` CLI tools.

### Pros

- short code,
- fast execution
- easy to understand for dev/tech ops

### Cons

- state management hardcoded in the workflow (otherwise needs to be implemented and  stored externally)
- migration to a different CD system requires a rewrite of the "state" logic (if hardcoded in the workflow)

## SDK tools

Using `google` and `azure` SDKs for JS/TS, Go, or any other language.

### Pros

- fast execution
- easy migration from GitHub workflow to another CD system.

### Cons

- state management hardcoded in the workflow (otherwise needs to be implemented and  stored externally)
- migration to a different CD system requires a rewrite of the "state" logic (if hardcoded in the workflow)
