# ptrs

ptrs (**p**enetration **t**est **r**eport **s**chema) is a schema for structured penetration test
reports.

The schema is defined using [JSON schema](https://json-schema.org/).
There is a separate sub-schema for findings.

## Why?

### Receiving a penetration test report

Ever received the results of a penetration test as a PDF and were then tasked with transferring
the findings into your company's ticketing system?

Not only is that tedious and boring but also error prone and time consuming.
With ptrs-formattted reports you can easily script the task once and then reuse your script
every time you receive a report.

### Generating a penetration test report

Suggest ptrs to your customers - they will love you for it!

Also, using a structured file format you can focus on the content of the report without worrying
about formatting.

Still want a PDF report as well? You can create a template in a markup language like AsciiDoc
and convert it to PDF (see below).

## Validation

Report and finding files can be validated against the CUE schema files in this repository using
the `cue` CLI.

For the sample files in this repository:

```
$ cue vet -v -d "#Finding" schema/finding-schema.cue samples/sample-finding.yaml
$ cue vet -v -d "#Report" schema/*.cue samples/sample-report.yaml
```


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
