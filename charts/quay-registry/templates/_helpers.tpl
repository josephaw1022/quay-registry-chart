{{/*
Expand the name of the chart.
*/}}
{{- define "quay-registry.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "quay-registry.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "quay-registry.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "quay-registry.labels" -}}
helm.sh/chart: {{ include "quay-registry.chart" . }}
{{ include "quay-registry.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for Quay
*/}}
{{- define "quay-registry.selectorLabels" -}}
app.kubernetes.io/name: {{ include "quay-registry.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: registry
{{- end }}

{{/*
Common labels for Clair
*/}}
{{- define "quay-registry.clairLabels" -}}
helm.sh/chart: {{ include "quay-registry.chart" . }}
{{ include "quay-registry.clairSelectorLabels" . }}
{{- if .Values.clair.image.tag }}
app.kubernetes.io/version: {{ .Values.clair.image.tag | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for Clair
*/}}
{{- define "quay-registry.clairSelectorLabels" -}}
app.kubernetes.io/name: {{ include "quay-registry.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: security-scanner
{{- end }}

{{/*
Name of Clair service / host
*/}}
{{- define "quay-registry.clairFullname" -}}
{{- printf "%s-clair" (include "quay-registry.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "quay-registry.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "quay-registry.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Quay Secret name
*/}}
{{- define "quay-registry.secretName" -}}
{{- if .Values.secrets.existingSecret }}
{{- .Values.secrets.existingSecret }}
{{- else }}
{{- printf "%s-secret" (include "quay-registry.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Quay Config Secret/ConfigMap name
*/}}
{{- define "quay-registry.configSecretName" -}}
{{- if .Values.config.existingSecret }}
{{- .Values.config.existingSecret }}
{{- else }}
{{- printf "%s-config" (include "quay-registry.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
