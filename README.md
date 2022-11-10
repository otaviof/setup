# Setup [Shipwright][shpGitHubOrg] (`v1`)

[![Build][useActionBadgeSVG]][useAction]

Deploys [Shipwright Build Controller][shpBuild], [CLI][shpCLI] and optionally a Container Registry instance, to perform continuous integration (CI) tests on the [`shipwright-io` projects][shpGitHubOrg].

## Usage

This action needs [`go`][actionSetupGo] and [`ko`][actionSetupKO] and a Kubernetes instance (available through `kubectl`), make sure those items are installed.

Given all the dependencies in place, the action performs the rollout and verification steps in the Kubernetes instance, the outcome is [`shipwright-io`][shpGitHubOrg] ready to use.

The snippet shows a complete usage example:

```yml
jobs:
  setup-shipwright:
    name: Shipwright
    steps:
      # using KinD to provide the Kubernetes instance and kubectl
      - uses: helm/kind-action@v1.2.0
      # golang is a required to deploy the build controller and CLI
      - uses: actions/setup-go@v3
        with:
          go-version: '1.18'
      # ko is a dependency to deploy the build controller instance
      - uses: imjasonh/setup-ko@v0.6

      # setting up Shipwright Build Controller, CLI and a Container Registry
      - uses: shipwright-io/setup@v1
```

### Inputs

Example usage using defaults:

```yml
jobs:
  use-action:
    steps:
      - uses: shipwright-io/setup@v1
        with:
          tekton-version: v0.38.3
          shipwright-ref: v0.11.0
          cli-ref: v0.11.0
          kind-cluster-name: kind
          setup-registry: true
          registry-hostname: registry.registry.svc.cluster.local
          patch-etc-hosts: true
```

The inputs are described below:

| Input               | Default                               | Description                                                                |
| ------------------- | ------------------------------------- | -------------------------------------------------------------------------- |
| `tekton-version`    | `v0.38.3`                             | [Tekton Pipeline][tektonPipeline] release version                          |
| `shipwright-ref`    | `v0.11.0`                             | [Shipwright Build Controller][shpBuild] repository tag or SHA              |
| `cli-ref`           | `v0.11.0`                             | [Shipwright CLI][shpCLI] repository tag or SHA                             |
| `kind-cluster-name` | `kind`                                | KinD cluster name                                                          |
| `setup-registry`    | `true`                                | Setup a Container Registry instance (`true` or `false`)                    |
| `registry-hostname` | `registry.registry.svc.cluster.local` | Container Registry hostname inside KinD                                    |
| `patch-etc-hosts`   | `true`                                | Patch "/etc/hosts" to alias the Container Registry hostname to "127.0.0.1" |

The Shipwright components [Build Controller][shpBuild] and [CLI][shpCLI] can be deployed using a specific commit SHA or tag.

### Inside the Shipwright Organization

By default the action execute a checkout of the Build and CLI repositories, however when working on those specific projects you can skip using `_ignore`. As the following example:

```yml
jobs:
  use-action:
    steps:
      - uses: shipwright-io/setup@v1
        with:
          shipwright-ref: _ignore
          cli-ref: _ignore
```

## Contributing

To run this action locally, you can use [`act`][nektosAct] as the following example:

```bash
act --secret="GITHUB_TOKEN=${GITHUB_TOKEN}"
```

The `GITHUB_TOKEN` is necessary for checking out the upstream repositories in the action workspace, and for this purpose the token only needs read-only permissions on the [`shipwright-io` organization][shpGitHubOrg]. The token is provided by default during GitHub Action execution inside GitHub.

### Troubleshooting

This action uses [KinD][kind] to instantiate a temporary Kubernetes and test itself against it, thus if you're using the same setup make sure there are no clusters left behind before running the action again.

```bash
kind delete cluster
```

When tests fail, you can use the context provided by KinD to connect on cluster, and then you're free to inspect all the components, logs, events, etc. For instance:

```bash
kind export kubeconfig
```

Once you set up the context you are able to inspect, for example, the Build controller logs.

```
kubectl --namespace=shipwright-build get pods
kubectl --namespace=shipwright-build logs --follow shipwright-build-controller-xxxxxxx
```

[actionSetupGo]: https://github.com/marketplace/actions/setup-go-environment
[actionSetupKO]: https://github.com/marketplace/actions/setup-ko
[kind]: https://kind.sigs.k8s.io/
[nektosAct]: https://github.com/nektos/act
[shpBuild]: https://github.com/shipwright-io/build
[shpCLI]: https://github.com/shipwright-io/cli
[shpGitHubOrg]: https://github.com/shipwright-io/build
[tektonPipeline]: https://github.com/tektoncd/pipeline
[useAction]: https://github.com/shipwright-io/setup/actions/workflows/use-action.yaml
[useActionBadgeSVG]:  https://github.com/shipwright-io/setup/actions/workflows/use-action.yaml/badge.svg