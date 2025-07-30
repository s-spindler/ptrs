# Penetration Test Report

{{ $r := (ds "report")}}
{{- $r.provider.organization.name }}, {{ $ts := $r.provider.testers }}{{ conv.Join $ts ", " -}}

{{- if has $r "introduction" }}

## Introduction

{{ $r.introduction }}
{{- end }}

{{- if has $r "scope" }}
## Scope
{{ range $r.scope }}
* {{ . }}
{{- end }}

{{- end }}

## Identified Vulnerabilities

{{ range $finding := $r.findings -}}
### {{ $finding.id }}: {{ $finding.title }} ({{ $finding.severity }})

#### Description

{{ $finding.description }}

#### Risk

{{ $finding.risk }}
#### Reproduction
{{ if has $finding "reproduction" -}}
{{ if has $finding.reproduction "steps" -}}
{{ range $step := $finding.reproduction.steps }}
* {{ $step }}
{{- end -}}
{{ end }}
{{ if has $finding.reproduction "poc" -}}
```
{{ $finding.reproduction.poc -}}
```
{{ end }}
{{ if has $finding.reproduction "description" -}}
{{ $finding.reproduction.description }}
{{ end -}}
{{ end }}

#### Mitigation

{{ $finding.mitigation }}
{{ end -}}

{{ if has $r "conclusion" -}}
## Conclusions

{{ $r.conclusion }}
{{- end }}
