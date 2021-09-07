# 1.4.0

- Refactored `Get-MarkdownCodeBlock` to return markdown and code blocks
- Update `Invoke-*` functions to work with new refactoring
- Added `Invoke-UpdateScriptFormat`, uses the PSSA formatter to format each code block in place


# 1.3.0

- Added `Invoke-ScriptFormatterMarkdown`. Formats the PowerShell code block using ScriptAnalyzer

# 1.2.1

- Support ` ```ps1 ` code block

# 1.2.0

- Add -Headers parameter to `Get-MarkdownCodeBlock`, `Invoke-ExecuteMarkdown`, and `Invoke-ScriptAnalyzerMarkdown`

```powershell
$url = 'https://private.url.com/test.md'
$header = @{"Authorization"="token $($env:GITHUB_TOKEN)"}
Invoke-ExecuteMarkdown $url $header
```
# 1.1.0

- Added `Invoke-ScriptAnalyzerMarkdown` - Run PowerShell Script Analyzer on code blocks written in markdown
- Refactored, created `Get-MarkdownCodeBlock` - Extracts PowerShell code blocks from markdown

# 1.0.0
- `Invoke-ExecuteMarkdown` - Execute PowerShell written in markdown code blocks