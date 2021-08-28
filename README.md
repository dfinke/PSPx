## Install

```powershell
Install-Module -Name PSPx
```

| Function | Description |
| --- | --- |
| `Invoke-ExecuteMarkdown` | Execute PowerShell written in markdown code blocks |
| `Invoke-ScriptAnalyzerMarkdown` | Run PowerShell Script Analyzer on code blocks written in markdown |
| `Get-MarkdownCodeBlock` | Install a module |

## Markdown scripts

`px` can execute scripts written in markdown ([examples/markdown.md](examples/markdown.md)):
```powershell
px examples/markdown.md
```

it can also execute scripts written in markdown from a `url`:

```powershell
px https://gist.githubusercontent.com/dfinke/610703acacd915a94afc1a4695fc6fce/raw/479e8a5edc62607ac5f753a4eb2a56ead43a841f/testErrors.md | fl
```

### Markdown

![](/media/PSMarkdown.png)

### Output

![](/media/PSOutput.png)

## Access Tokens

The `-Headers` parameter can be used to add access tokens to the request for markdown files behind a private Url. For example, if they are in a private GutHub repository, or Azure DevOps.

```powershell
$url = 'https://private.url.com/test.md'
$header = @{"Authorization"="token $($env:GITHUB_TOKEN)"}
Invoke-ExecuteMarkdown $url $header
```