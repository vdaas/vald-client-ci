# GitHub Actions CI workflows, actions for Vald client

A repository of workflows and actions for Vald client CI configuration.

- [vald-client-go](https://github.com/vdaas/vald-client-go)
- [vald-client-node](https://github.com/vdaas/vald-client-node)
- [vald-client-python](https://github.com/vdaas/vald-client-python)
- [vald-client-java](https://github.com/vdaas/vald-client-java)

## The workflows/actions

### Workflows

- [Sync](./.github/workflows/sync.yaml)
  - This workflow is designed to handle synchronization with the Vald repository.
  - It checks for differences between the `main` branch of Vald client repository and the `main` branch of the Vald repository, and synchronizes API changes.
  - Additionally, it synchronizes release tags if a release occurs in the Vald repository.
  - This automation helps maintain alignment and reduces manual effort in keeping repositories synchronized.

- [Release](./.github/workflows/_release.yaml)
  - This workflow is designed to handle the release process, including  packaging the Vald client for distribution.
  - It also handles the publication to external package repositories, ensuring that the released versions are available to the community.
    - For Python projects, the release is published to [PyPi](https://pypi.org/project/vald-client-python/), allowing Python users to install via `pip`.
    - For Node.js projects, the release is published to [npm](https://www.npmjs.com/package/vald-client-node), enabling installation via `npm install`.
    - For Java projects, the release is published to [maven](https://central.sonatype.com/artifact/org.vdaas.vald/vald-client-java), enabling installation.

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
    uses: vdaas/vald-client-ci/.github/workflows/sync@main
    with:
      client_type: python # go, node, java
    secrets:
      CI_USER: ${{ secrets.DISPATCH_USER }}
      CI_TOKEN: ${{ secrets.DISPATCH_TOKEN }}
      GPG_PRIVATE_KEY: ${{ secrets.GPG_PRIVATE_KEY }}
```

- [Release](./.github/workflows/_release.yaml)

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
    uses: vdaas/vald-client-ci/.github/workflows/_release.yaml@main
    with:
      client_type: python # go, node, java
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
          client_type: python # go, node, java
````

## Important Notes

### Managing Secrets

Be sure to carefully manage and configure secrets used in these workflows. Improper handling of secrets can lead to security risks.

### Required `make` Command

The common workflows in this repository require the use of `make` commands. To ensure proper operation, please implement the following `make` commands in each Vald client repositories:

- `vald/clone`: Clones the Vald repository as the name `vald-origin`.

- `vald/checkout`: Switches branches or tags in the cloned Vald repository. The `VALD_CHECKOUT_REF` variable specifies the desired branch or tag.

- `vald/origin/sha/print`: Prints the SHA of the cloned Vald repository.

- `vald/sha/print`: Prints the SHA managed by the Vald client.

- `vald/sha/update`: Updates the SHA managed by the Vald client.

- `vald/client/version/update`: Updates the Vald client version.

- `proto`: Builds the protobuf using the croned Vald repository.

- `test`: Executes tests for the Vald client.

- `ci/deps/install`: Installs dependencies.

- `ci/deps/update`: Updates dependencies.

- `ci/package/prepare`: Prepares packages for publication.

- `ci/package/publish`: Publishes packages to external package repositories.


These `make` commands are essential for the proper functioning of the workflows and CI processes in this repository.

Ensure that these commands are correctly implemented in each Vald client repository
