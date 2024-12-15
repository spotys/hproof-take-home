# Problem Statement

## Initial Thoughts

The take-home problem statement requires building a GH workflow accomplishing the following steps:

1. Retrieve the existing Google Maps API key or service key needed to interact with Google Maps APIs
2. Generate a new API key (rotation).
3. Store the new API key securely in the Azure Key Vault secret GoogleMapKey.

Let's imagine the GH workflow above simulates a real-life app/service. This approach is nearly ideal from security perspective as the app/service only uses the API key 'once' and replaces it afterwords thus the API key is hard to get stolen and misused. However, there are some serious issues with this approach too:

- it's slow to rotate an API key after every use therefore in practice we could use this approach on application startup and/or cache the API key for a while before it gets rotated,
- there's no good reason for this approach to store the API key in Azure KeyVault as it could be retrieved from Google and used directly,
- in case there's multiple instances of the app/service, it's not guaranteed, that the rotated API key gets used exactly once anyway. Race conditions will lead to situations where the generated API key will be either used more than once or not even once. That leads to a "worse than expected" security.
- the need for the secret rotation done by the app/service requires the app/service to possess with Google credentials, which negatively affects the attack surface (especially if the app/service is exposed to internet traffic).
- API key retention mechanism is completely missing as rotating a Google API key basically requires a new API key to be issued. Similarly KeyVault creates new version of the secret holding the updated API key while access to the older versions is still possible.

To fix those issues I suggest separating the rotation logic from the app/service itself which will allow for:

- No Google credentials required by the app/service (attack surface reduction).
- Fast access to the API key through Azure KeyVault (the app/service only reads from Azure KeyVault).
- The app/service can be pre-configured with an API key by the orchestration framework (Kubernetes, Container service, etc.).
- Regular API key rotation (in arbitrary time intervals) done by a separate process which can live within a secured environment with no exposure to external traffic.

A proper API key retention logic still needs to be implemented.

## The App/Service Logic

The app/service logic is arbitrary and the only requirement here is to retrieve the API key from Azure KeyVault. According to the Twelve Factor framework it's undesirable to retrieve the API key by the app/service code, but rather configure processes with an API key to be used over the entire process lifetime by the service orchestration framework. Within Kubernetes this can be achieved with e.g. the External Secrets operator (which retrieves keys from the secure store) and the Reloader operator (which triggers a rolling restart of the affected deployments).

Having said that, to fulfill the Take Home Assessment requirements I will create a code for reading a secret value from Azure KeyVault and printing it to stardard output (just for validation).

## The API Key Rotation Logic

There are multiple ways of approaching this task. I will implement the API key rotation in Terraform as Terraform is a de-facto industry standard for infrastructure management, it typically runs in a separate environment which doesn't serve any customer traffic, and there will be also more Terraform code neede for the entire environment setup for this Take Home Assessment.
