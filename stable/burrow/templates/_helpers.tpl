{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "burrow.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "burrow.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "burrow.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Formulate the how the seeds feed is populated.
*/}}
{{- define "burrow.seeds" -}}
{{- if (and .Values.peer.ingress.enabled (not (eq (len .Values.peer.ingress.hosts) 0))) -}}
{{- $host := index .Values.peer.ingress.hosts 0 -}}
{{- range $index, $val := $.Values.validators -}}
{{- $addr := $val.nodeAddress | lower -}}
{{- $node := printf "%03d" $index -}}
tcp://{{ $addr }}@{{ $node }}.{{ $host }}:{{ $.Values.config.Tendermint.ListenPort }},
{{- end -}}
{{- if not (eq (len .Values.chain.extraSeeds) 0) -}}
{{- range .Values.chain.extraSeeds -}},{{ . }}{{- end -}}
{{- end -}}
{{- else -}}
{{- range $index, $val := $.Values.validators -}}
{{- $addr := $val.nodeAddress | lower -}}
{{- $node := printf "%03d" $index -}}
tcp://{{ $addr }}@{{ template "burrow.fullname" $ }}-peer-{{ $node }}:{{ $.Values.config.Tendermint.ListenPort }},
{{- end -}}
{{- if not (eq (len .Values.chain.extraSeeds) 0) -}}
{{- range .Values.chain.extraSeeds -}},{{ . }}{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
