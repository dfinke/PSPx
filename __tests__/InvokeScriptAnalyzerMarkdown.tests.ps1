Import-Module $PSScriptRoot/../PSPx.psd1 -Force

Describe "Test Invoke Script Analyzer Markdown" -Tag "Invoke-ScriptAnalyzerMarkdown" {

    BeforeAll {
        $rootDir = "$PSScriptRoot/testMarkdownFiles"
    }

    It "Should run PSSA on the markdown blocks" {        
        $fileName = $rootDir + "/PSBlocksPSSA-Issues.md"

        $actual = Invoke-ScriptAnalyzerMarkdown $fileName
        
        $actual              | Should -Not -BeNullOrEmpty
        $actual.Result.Count | Should -Be 2
    }

    It "Should execute mutiple markdown files" {
        $actual = Get-ChildItem $rootDir *.md | Invoke-ScriptAnalyzerMarkdown

        $actual.Count | Should -Be 2 # should find two files

        $actual[0].Cmdlet | Should -BeExactly 'Invoke-ScriptAnalyzerMarkdown'
        $actual[1].Cmdlet | Should -BeExactly 'Invoke-ScriptAnalyzerMarkdown'
        
        # first file
        $scriptAsLines = $actual[0].Script.Split("`n")
        $scriptAsLines.Count | Should -Be 8

        # second file
        $scriptAsLines = $actual[1].Script.Split("`n")
        $scriptAsLines.Count | Should -Be 4
    }
    It "Should analyze markdown strings directly" {
        $md = @'
```powershell
"Hello World"
```
'@
        $actual = Invoke-ScriptAnalyzerMarkdown $md
        $scriptAsLines = $actual[0].Script.Split("`n")

        $scriptAsLines.Count | Should -Be 2

    }

    It "Should analyze markdown strings piped" {
        $md = @'
```powershell
"Hello World"
```
'@
        $actual = $md | Invoke-ScriptAnalyzerMarkdown
        $scriptAsLines = $actual[0].Script.Split("`n")

        $scriptAsLines.Count | Should -Be 2
    }

    It "Should throw if no Headers param on the function" {
        $url = 'https://raw.githubusercontent.com/dfinke/pstestX/main/test.md'
        { Invoke-ScriptAnalyzerMarkdown -Path $url -Headers @{"A" = 1 } } | Should -Not -Throw 
    }

    It "Should get an error with a private url" {
        $url = 'https://raw.githubusercontent.com/dfinke/pstestX/main/test.md'
        # $header = @{"Authorization"="token $($env:GITHUB_TOKEN)"}        
        $actual = Invoke-ScriptAnalyzerMarkdown -Path $url

        $actual.Path  | Should -BeExactly $url
        $actual.Error | Should -BeExactly "404: Not Found"
    }

}