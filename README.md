# ptrs

ptrs (**p**enetration **t**est **r**eport **s**chema) is a schema for structured penetration test
reports.

The schema is defined using [CUE lang](https://cuelang.org/).
There is a separate sub-schema for findings.

## Why?

### Receiving a penetration test report

Ever received the results of a penetration test as a PDF and were then tasked with transferring
the findings into your company's ticketing system?

Not only is that tedious and boring but also error prone and time consuming.
With ptrs-formatted reports you can easily script the task once and then reuse your script
every time you receive a report.

### Generating a penetration test report

Suggest ptrs to your customers - they will love you for it!

Also, using a structured file format, you can focus on the content of the report without worrying
about formatting.

Still want a PDF report as well? You can create a template in a markup language like AsciiDoc
and convert it to PDF (see below).

## Validation

Report and finding files can be validated against the CUE schema files in this repository using
the `cue` CLI.

For the sample files in this repository:

```
cue vet -v -d "#Finding" schema/finding-schema.cue samples/sample-finding.yaml
cue vet -v -d "#Report" schema/*.cue samples/sample-report.yaml
```

### Custom validation

You might want to add constraints to your pentest finding reports. Maybe you want the severity
field to be more restricted and only allow certain values it.

You can do this by adding a more narrow CUE schema file and adding it to your validation.
Here is an example:

```
cue vet -v -d "#Report" schema/*.cue schema/samples/sample-finding-schema-extension.cue samples/sample-report.yaml
```

The definition in `schema/samples/sample-finding-schema-extension.cue` narrows the allowed values
for the severity field down to a list.

Alternatively, you can of course fork the schema files and adjust them as needed.

## Templating

You can feed a ptrs file to any templating engine that accepts yaml input. Or any other ones that
accept structured input formats to which you can convert yaml.

[This file is a go template](templates/sample-report-template.adoc) that can be templated using
`gomplate`:

```
gomplate -d report=samples/sample-report.yaml -f templates/sample-report-template.adoc > templated-sample-report.adoc
```

The resulting file can be turned into a PDF using `asciidoctor-pdf`:

```
asciidoctor-pdf templated-sample-report.adoc
```

Here is an example using a markdown template:

```
gomplate -d report=samples/sample-report.yaml -f templates/sample-report-template.md > templated-sample-report.md
```

And here an example of turning the resulting markdown file into HTML using pandoc:

```
pandoc -f markdown -t html templated-sample-report.md -o sample-report.html
```

## Querying, filtering, transforming

Since ptrs files are yaml, anything that can be done with yaml files is possible with ptrs files.

### Selecting with yq

[yq](https://mikefarah.gitbook.io/yq) is a great multi-purpose tool for working with yaml
(and various other file formats).

Here is an example of selecting findings with low severity from a report file:

```
yq '.findings[] | select(.severity == "Low")' samples/sample-report.yaml
```

Converting the report to json for further processing:

```
yq -o=json '.' -I=0 samples/sample-report.yaml
```

### Using fx

[fx](https://fx.wtf/) is another great tool. It is both a viewer and a processor. Mainly meant for
json, it can also work with yaml files.

This is doing the same as the yq example above; selecting only findings with low severity from
a report file:

```
cat samples/sample-report.yaml | fx --yaml '.findings' 'filter(x => x.severity == "Low")'
```

By default, fx's output is json.

### Using duckdb

[duckdb](https://duckdb.org/) is great for local, ad-hoc analysis with SQL. It is particularly
good for working with tabular data but can also be used on lists of nested, structured data.

While duckdb doesn't support yaml natively, it can load data from json. Here is an example
using duckdb in batch mode on a report that is first converted to json using yq:

```
yq -o=json -I=0 '.findings' samples/sample-report.yaml > findings.json
duckdb -c "select id, title from 'findings.json' where severity = 'Medium';"
```

Alternatively, duckdb can be used in interative mode as well.
