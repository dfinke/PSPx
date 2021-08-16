# Markdown Scripts

It's possible to write scripts using markdown. Only code blocks will be executed
by `px`. Try to run `px .\examples\markdown.md | % result`.

```ps
$PSVersionTable
$pwd
```

Display the `APPDATA` environment variable:

```ps
$env:APPDATA
```

We can create functions to be used in subsequent code blocks:

```ps
function Get-Info {
    "Test Info $(get-date)"
}
```

Use `Get-Info` here:

```ps
Get-Info
```

Other code blocks are ignored:

```css
body .hero {
    margin: 42px;
}
```