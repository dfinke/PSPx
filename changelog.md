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