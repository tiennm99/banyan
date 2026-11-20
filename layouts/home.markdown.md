{{- /* Markdown version of the bio page, for READMEs and AI agents.
       Rendered only when the site registers a "markdown" output format and
       lists it in outputs.home (see README, "Markdown output"). It mirrors
       bio-card.html: sections win over flat links, and links outside their
       visibility window are skipped. */ -}}
{{- $name := site.Params.name | default site.Title -}}
{{- $sections := site.Params.sections -}}
{{- if not $sections -}}
  {{- $sections = slice (dict "links" site.Params.links) -}}
{{- end -}}
# {{ $name }}
{{ with site.Params.avatar }}
<img src="{{ if strings.HasPrefix . "http" }}{{ . }}{{ else }}{{ . | strings.TrimPrefix "/" | absURL }}{{ end }}" alt="{{ $name }}" width="120" height="120">
{{ end -}}
{{ with site.Params.tagline }}
**{{ . }}**
{{ end -}}
{{ with site.Params.bio }}
{{ . }}
{{ end -}}
{{ range $sections -}}
{{ $visible := slice -}}
{{ range .links }}{{ if partial "link-visible.html" . }}{{ $visible = $visible | append . }}{{ end }}{{ end -}}
{{ if $visible -}}
{{ with .title }}
## {{ . }}
{{ end -}}
{{ with .description }}
{{ . }}
{{ end }}
{{ range $visible -}}
- [{{ .title }}]({{ .url }}){{ with .note }} — {{ . }}{{ end }}
{{ end -}}
{{ end -}}
{{ end }}
---

{{ with site.Params.footerText }}{{ . }} · {{ end }}[Web version]({{ site.Home.Permalink }})
{{ with site.Params.markdownFooter }}
{{ . }}
{{ end -}}
