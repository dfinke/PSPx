Import-Module $PSScriptRoot/../PSPx.psd1 -Force

Describe "Test Get Markdown CodeBlock" -Tag "Get-MarkdownCodeBlock" {

    BeforeAll {
        $rootDir = Join-Path $PSScriptRoot 'testMarkdownFiles'
    }

    It "Should read a local markdown file" {
        $fileName = Join-Path $rootDir 'basicPSBlocks.md'

        $actual = Get-MarkdownCodeBlock $fileName
        $scriptAsLines = $actual[0].Script.Split("`n")

        $actual.Path | Should -BeExactly $fileName
        $scriptAsLines.Count | Should -Be 9
    }

    It "Should read a url" {
        $url = 'https://raw.githubusercontent.com/dfinke/PSPx/master/examples/markdown.md'
        
        $actual = Get-MarkdownCodeBlock $url
        
        $actual.Path   | Should -BeExactly $url
        $actual.Script | Should -Not -BeNullOrEmpty
        
        $lines = $actual.Script -split "`n"
        $lines.Count | Should -Be 8
        
        $lines[0].Trim() | Should -BeExactly '$PSVersionTable'
        $lines[1].Trim() | Should -BeExactly '$pwd'
        $lines[2].Trim() | Should -BeExactly '$env:APPDATA'
        $lines[3].Trim() | Should -BeExactly 'function Get-Info {'
        $lines[4].Trim() | Should -BeExactly '"Test Info $(get-date)"'
        $lines[5].Trim() | Should -BeExactly '}'
        $lines[6].Trim() | Should -BeExactly 'Get-Info'
    }
    
    It "Should throw if no Headers param on the function" {
        $url = 'https://raw.githubusercontent.com/dfinke/pstestX/main/test.md'
        { Get-MarkdownCodeBlock -Path $url -Headers @{"A" = 1 } } | Should -Not -Throw 
    }

    It "Should get an error with a private url" {
        $url = 'https://raw.githubusercontent.com/dfinke/pstestX/main/test.md'
        # $header = @{"Authorization"="token $($env:GITHUB_TOKEN)"}        
        $actual = Get-MarkdownCodeBlock $url

        $actual.Path  | Should -BeExactly $url
        $actual.Error | Should -BeExactly "404: Not Found"
    }
}