{{- define "django-app.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "django-app.fullname" -}}
{{ printf "%s-%s" .Release.Name (include "django-app.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
