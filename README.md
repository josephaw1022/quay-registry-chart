# Quay Registry Helm Chart Repository

[![Lint and Test Chart](https://github.com/josephaw1022/quay-registry-chart/actions/workflows/pr-test.yml/badge.svg)](https://github.com/josephaw1022/quay-registry-chart/actions/workflows/pr-test.yml)
[![Publish OCI Helm Chart](https://github.com/josephaw1022/quay-registry-chart/actions/workflows/release.yml/badge.svg)](https://github.com/josephaw1022/quay-registry-chart/actions/workflows/release.yml)

This repository contains the CNCF-compliant Helm chart for [Project Quay](https://github.com/quay/quay) Enterprise Container Registry.

## Key Features

- 🐳 **Decoupled Architecture**: Does **not** package internal PostgreSQL or Valkey/Redis databases. Configured purely via connection secrets and external endpoints.
- 📦 **OCI Helm Artifacts**: Packaged and published as OCI artifacts to GitHub Container Registry (`ghcr.io/josephaw1022/charts/quay-registry`).
- 🤖 **Automated Image Updates**: Configured with Renovate & Dependabot to automatically track upstream `quay` and `clair` container image releases.
- 🧪 **Automated Testing**: Tested via `helm-unittest` and linted against `values.schema.json` in GitHub Actions on every pull request.
- 🌐 **OpenShift & Kubernetes Support**: Native support for Kubernetes Ingress and OpenShift Routes.

## Repository Layout

```
.
├── .github/
│   ├── dependabot.yml              # Dependabot config for GitHub Actions
│   ├── renovate.json5              # Renovate config for Quay/Clair container images
│   └── workflows/
│       ├── pr-test.yml             # PR lint & helm-unittest verification workflow
│       └── release.yml             # OCI release and GHCR publish workflow
├── charts/
│   └── quay-registry/              # Main Helm Chart
│       ├── Chart.yaml              # Chart metadata
│       ├── values.yaml             # Default values
│       ├── values.schema.json      # JSON Schema validation
│       ├── README.md               # Chart specific documentation
│       ├── templates/              # Kubernetes manifest templates
│       └── tests/                  # Helm Unit Tests (helm-unittest)
├── Makefile                        # Local development targets
└── README.md                       # Project documentation
```

## Quick Start

### 1. Test and Lint Locally

```bash
make lint
make test
```

### 2. Package Locally

```bash
make package
```

### 3. Install via Helm OCI

```bash
helm install quay oci://ghcr.io/josephaw1022/charts/quay-registry \
  --version 0.1.0 \
  --set config.serverHostname="quay.example.com" \
  --set database.existingSecret="quay-postgres-secret" \
  --set redis.host="quay-valkey.example.com"
```

## License

Apache-2.0
