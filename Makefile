# Makefile for Quay Registry Helm Chart

CHART_DIR := charts/quay-registry
DIST_DIR := dist

.PHONY: help
help: ## Show available Makefile commands.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
	/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Validation & Testing

.PHONY: lint
lint: ## Lint the Helm chart.
	@echo "🔍 Linting Quay Registry Helm chart..."
	helm lint $(CHART_DIR)

.PHONY: test
test: ## Run helm unit tests.
	@echo "🧪 Running Helm unit tests..."
	helm unittest $(CHART_DIR)

.PHONY: template
template: ## Render chart templates locally for inspection.
	@echo "📋 Rendering Helm templates..."
	helm template quay-test $(CHART_DIR) --debug

.PHONY: validate-schema
validate-schema: lint template ## Validate chart values against values.schema.json.
	@echo "✅ Schema validation passed."

##@ Packaging & Release

.PHONY: package
package: test ## Package the Helm chart into a .tgz archive in dist/.
	@echo "📦 Packaging chart..."
	mkdir -p $(DIST_DIR)
	helm package $(CHART_DIR) --destination $(DIST_DIR)
	@echo "✅ Package created in $(DIST_DIR)"

.PHONY: clean
clean: ## Clean generated packages.
	@echo "🧹 Cleaning dist directory..."
	rm -rf $(DIST_DIR)
