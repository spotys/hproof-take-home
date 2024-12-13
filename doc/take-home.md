# Google Maps API Key Rotation with Azure Key Vault

## Problem Statement

You are tasked with implementing an automated process to rotate a Google Maps API key and securely store the updated key in an Azure Key Vault secret named GoogleMapKey. The goal is to enhance security by regularly changing the API key without disrupting services that rely on it. These services have both APIs and CLI tools. You may use either for this exercise, but you may find the CLIs easier to use in your scripts.

## Requirements

1. GitHub Actions Script: Write a GitHub Actions workflow that accomplishes the following steps:
    - Retrieve the existing Google Maps API key or service key needed to interact with Google Maps APIs
    - Generate a new API key (rotation).
    - Store the new API key securely in the Azure Key Vault secret GoogleMapKey.
2. Documentation and Explanation:
    - At Hyperproof we maintain operational documentation for running our services. Document anything necessary for other engineers to understand how to operate, maintain, and possibly enhance your solution.
    - Disclosure of AI Tools: You may use AI tools or external resources. However, you must disclose any tools you used and provide a summary of the benefits and drawbacks encountered during their implementation.

## References

- GitHub Actions
    GitHub Actions allows you to automate your software development workflows directly in your repository. You can create custom continuous integration (CI) workflows, deploy applications, and more. Explore the comprehensive documentation, examples, and guides:
    [GitHub Actions Documentation](https://docs.github.com/en/actions)
- Google Maps API:
    Google Maps Platform provides APIs and SDKs for integrating dynamic maps, geolocation, street view, and more into your web and mobile apps. Learn how to use the Maps JavaScript API, explore features, and build customized maps:
    [Google Maps Platform Documentation](https://developers.google.com/maps/documentation/)
- Azure Key Vault
    Azure Key Vault helps you create and manage keys, secrets, and certificates securely. It’s a critical component for safeguarding sensitive information in your cloud resources. Dive into tutorials, API references, and best practices:
    [Azure Key Vault Documentation](https://learn.microsoft.com/en-us/azure/key-vault/)

You will be assessed based on the following:

- Correctness and functionality of the GitHub Actions script.
- Proper handling of secrets and secure storage in Azure Key Vault.
- Clarity of documentation and explanation.
- Transparency in disclosing tools used and their impact.

Please let us know if you have any questions regarding this problem or need clarifications, please email `<email-redacted>`.
