# Project Quay Helm Chart

CNCF-compliant Helm Chart to deploy [Project Quay](https://github.com/quay/quay) Enterprise Container Registry with [Clair](https://github.com/quay/clair) security vulnerability scanner and external PostgreSQL / Redis / Valkey integration.

## Architecture & Design Principles

- **No Bundled Database**: PostgreSQL is **not** deployed inside this chart. You must provide database connection strings/secrets created in advance.
- **No Bundled Cache**: Valkey / Redis is **not** deployed inside this chart. An external or pre-existing instance is referenced via `redis.host` and `redis.port`.
- **OCI Helm Packaging**: Published to GitHub Packages (GHCR) as an OCI artifact: `oci://ghcr.io/josephaw1022/charts/quay-registry`.
- **Automated Image Updates**: Renovate and Dependabot configurations track and update upstream Quay and Clair container images.
- **Schema Validation**: Validated with JSON Schema (`values.schema.json`) and automated unit tests (`helm-unittest`).

---

## Prerequisites

1. **Kubernetes 1.26+** or **OpenShift 4.12+**
2. **Helm v3.8.0+** (with OCI support)
3. **Pre-existing PostgreSQL Database**:
   - Database for Quay (e.g. `quay`)
   - Database for Clair (e.g. `clair` with `uuid-ossp` and `pgcrypto` extensions)
4. **Pre-existing Redis or Valkey instance**:
   - Host & port accessible from the cluster.

---

## Quickstart

### 1. Create Database Secret

Create a Kubernetes Secret containing your PostgreSQL connection string:

```bash
kubectl create secret generic quay-postgres-secret \
  --from-literal=DB_URI="postgresql://quay:quaypass@postgres.example.com:5432/quay"
```

For Clair (if enabled):

```bash
kubectl create secret generic quay-clair-postgres-secret \
  --from-literal=CLAIR_DB_URI="host=postgres.example.com port=5432 dbname=clair user=quay password=quaypass sslmode=disable"
```

### 2. Install Chart from OCI Registry

```bash
helm install my-quay oci://ghcr.io/josephaw1022/charts/quay-registry \
  --version 0.1.0 \
  --set config.serverHostname="quay.example.com" \
  --set database.existingSecret="quay-postgres-secret" \
  --set database.existingSecretUriKey="DB_URI" \
  --set redis.host="quay-valkey.example.com" \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host="quay.example.com"
```

---

## Configuration Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of Quay replicas | `1` |
| `image.repository` | Quay container image repository | `quay.io/projectquay/quay` |
| `image.tag` | Quay container image tag | `v3.13.0` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `service.type` | Service type (`ClusterIP`, `NodePort`, `LoadBalancer`) | `ClusterIP` |
| `service.port` | Quay HTTP port | `8080` |
| `service.httpsPort` | Quay HTTPS port | `8443` |
| `ingress.enabled` | Enable Kubernetes Ingress | `false` |
| `route.enabled` | Enable OpenShift Route | `false` |
| `persistence.enabled` | Enable storage PVC for local storage driver | `true` |
| `persistence.size` | PVC storage size | `50Gi` |
| `database.existingSecret` | Name of pre-existing Secret with DB connection string | `""` |
| `database.existingSecretUriKey` | Key in secret containing DB connection string | `"DB_URI"` |
| `database.uri` | Direct database connection URI (if not using secret) | `""` |
| `redis.host` | Hostname / IP of external Redis/Valkey instance | `"quay-valkey.example.com"` |
| `redis.port` | Port of external Redis/Valkey instance | `6379` |
| `config.serverHostname` | Public hostname for Quay | `"quay.example.com"` |
| `config.registryTitle` | Title displayed in Quay UI | `"Homelab Quay Registry"` |
| `config.features.proxyCache` | Enable upstream pull-through cache | `true` |
| `config.features.garbageCollection` | Enable garbage collection | `true` |
| `config.features.changeTagExpiration`| Enable tag expiration policy | `true` |
| `config.features.securityScanner` | Enable Clair vulnerability scanner | `true` |
| `config.oidc.enabled` | Enable OIDC / Microsoft Entra ID integration | `false` |
| `clair.enabled` | Deploy Clair security scanner component | `true` |
| `clair.image.repository` | Clair container image repository | `quay.io/projectquay/clair` |
| `clair.image.tag` | Clair container image tag | `4.9.0` |
| `clair.database.existingSecret` | Pre-existing secret for Clair DB connection | `""` |
