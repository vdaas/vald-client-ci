# GitHub Actions CI workflows, actions for Vald client

A repository of workflows and actions for Vald client CI configuration.

- [vald-client-go](https://github.com/vdaas/vald-client-go)
- [vald-client-node](https://github.com/vdaas/vald-client-node)
- [vald-client-python](https://github.com/vdaas/vald-client-python)
- [vald-client-java](https://github.com/vdaas/vald-client-java)
- [vald-client-clj](https://github.com/vdaas/vald-client-clj)

## The workflows/actions

### Workflows

- [Sync](./.github/workflows/sync.yaml)
  - This workflow is designed to handle synchronization with the Vald repository.
  - It checks for differences between the `main` branch of the Vald client repository and the `main` branch of the Vald repository, and synchronizes API changes.
  - Additionally, it synchronizes release tags if a release occurs in the Vald repository.
  - This automation helps maintain alignment and reduces manual effort in keeping repositories synchronized.

- [Release](./.github/workflows/release.yaml)
  - This workflow is designed to handle the release process, including  packaging the Vald client for distribution.
  - It also handles the publication to external package repositories, ensuring that the released versions are available to the community.
    - For Python projects, the release is published to [PyPi](https://pypi.org/project/vald-client-python/), allowing Python users to install via `pip`.
    - For Node.js projects, you can find the release on [npm](https://www.npmjs.com/package/vald-client-node) and install it using `npm install`.
    - For Java projects, Maven artifacts are available [here](https://central.sonatype.com/artifact/org.vdaas.vald/vald-client-java) for integration into projects.
    - For Clojure projects, Clojars artifacts are available [here](https://clojars.org/vald-client-clj) for integration into projects.

### Actions

- [E2E](./.github/actions/e2e/action.yaml)
  - This action is designed to run End-to-End (E2E) tests on GitHub Actions CI.
  - It sets up a Kubernetes cluster in the CI environment and deploys the Vald to it.
  - The action then executes E2E tests against the deployed Vald cluster to ensure that the service functions as expected.
  - This process helps to validate the entire Vald client stack and catch any issues early in the CI pipeline.

## How to use workflows/actions

### workflows

- [Sync](./.github/workflows/sync.yaml)

```yaml
name: "Sync Vald"
on:
  workflow_dispatch:
  schedule:
    - cron: "*/5 * * * *"
jobs:
  sync:
    uses: vdaas/vald-client-ci/.github/workflows/sync.yaml@main
    with:
      client_type: python # go, node, java, clj
    secrets:
      CI_USER: ${{ secrets.YOUR_CI_USER }}  # The CI user to be used in your environment
      CI_TOKEN: ${{ secrets.YOUR_CI_TOKEN }}  # The CI token for accessing the repository in your environment
      GPG_PRIVATE_KEY: ${{ secrets.YOUR_GPG_PRIVATE_KEY }}  # Your GPG private key for signing
```

- [Release](./.github/workflows/release.yaml)

```yaml
name: "Run release"
on:
  push:
    tags:
      - '*.*.*'
      - 'v*.*.*'
      - '*.*.*-*'
      - 'v*.*.*-*'
jobs:
  release:
    uses: vdaas/vald-client-ci/.github/workflows/release.yaml@main
    with:
      client_type: python # go, node, java, clj
    secrets: inherit

```

### Actions

- [E2E](./.github/actions/e2e/action.yaml)

```yaml
name: "Run E2E test"
on:
  push:
    branches:
      - main
  pull_request:

jobs:
  e2e:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: vdaas/vald-client-ci/.github/actions/e2e@main
        with:
          client_type: python # go, node, java, clj
````

## :warning: Important Notes

### Managing Secrets

Be sure to carefully manage and configure secrets used in these workflows. Improper handling of secrets can lead to security risks.

#### Required Secrets

- `CI_USER`: The username used in CI/CD processes. This user should have appropriate permissions.

- `CI_TOKEN`: The token required for GitHub Actions to access the repository. Make sure it has proper permissions, like repo and workflow.

- `GPG_PRIVATE_KEY`: The GPG private key used for signing, crucial for the release process.

#### Required Secrets for vald-client-python

- `PIP_USERNAME`: The username used to publish packages to PyPi. This is necessary for distributing Python packages via pip.

- `PIP_TOKEN`: The token used for authentication to PyPi, allowing you to publish Python.

#### Required Secrets for vald-client-node

- `NPM_AUTH_TOKEN`: The authentication token for npm, required to publish packages to the npm registry.

#### Required Secrets for vald-client-java

- `GPG_KEYID`: The key ID for GPG, which is used for signing Maven artifacts.

- `GPG_PASSPHRASE`: The passphrase for the GPG key, required when signing artifacts.

- `PGP_PRIVATE_KEY`: The PGP private key used for signing Maven artifacts. This key is crucial for ensuring secure distribution of Java packages.

- `SONATYPE_USERNAME`: The username for accessing the Sonatype repository (like Maven Central), where Java packages are published.

- `SONATYPE_PASSWORD`: The password for the Sonatype repository, used in conjunction with the username for authentication.

#### Required Secrets for vald-client-clj

- `CLOJARS_USER`: The username for Clojars, required to publish Clojure packages.

- `CLOJARS_PASS`: The password for Clojars, used for authentication when publishing Clojure packages.


### Required `make` Command

The common workflows in this repository require the use of `make` commands. To ensure proper operation, please implement the following `make` commands in each Vald client repositories:

- `vald/checkout`: Switches branches or tags in the cloned Vald repository. The `VALD_CHECKOUT_REF` variable specifies the desired branch or tag.

- `vald/origin/sha/print`: Prints the SHA of the cloned Vald repository.

- `vald/sha/print`: Prints the SHA managed by the Vald client.

- `vald/sha/update`: Updates the SHA managed by the Vald client.

- `vald/client/version/print`: Prints the Vald client version.

- `vald/client/version/update`: Updates the Vald client version.

- `proto`: Builds the protobuf using the croned Vald repository.

- `test`: Executes tests for the Vald client.

- `ci/deps/install`: Installs dependencies.

- `ci/deps/update`: Updates dependencies.

- `ci/package/prepare`: Prepares packages for publication.

- `ci/package/publish`: Publishes packages to external package repositories.

- `version/go`: Prints the Go version. It is for Go language environment.

- `version/node`: Prints the Node version. It is for Node language environment.

- `version/python`: Prints the Python version. It is for Python language environment.

- `version/java`: Prints the Java version. It is for Java language environment.

These `make` commands are essential for the proper functioning of the workflows and CI processes in this repository.

Ensure that these commands are correctly implemented in each Vald client repository
