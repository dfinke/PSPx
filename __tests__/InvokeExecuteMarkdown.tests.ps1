Import-Module $PSScriptRoot/../PSPx.psd1 -Force

Describe "Test Invoke Execute Markdown" -Tag "Invoke-ExecuteMarkdown" {

    BeforeAll {
        $rootDir = "$PSScriptRoot/testMarkdownFiles"
    }

    It "Should have `px` alias" {
        Get-Alias px | Should -Not -BeNullOrEmpty
    }

    It "Should execute the markdown and return results" {
        $fileName = $rootDir + "/basicPSBlocks.md"

        $actual = Invoke-ExecuteMarkdown $fileName
        
        $actual              | Should -Not -BeNullOrEmpty        
        $actual.Result.Count | Should -Be 7
        $actual.Result[0]    | Should -BeExactly 'Hello World'
        $actual.Result[1]    | Should -BeExactly 'Goodbye'
        $actual.Result[2]    | Should -BeExactly 1
        $actual.Result[3]    | Should -BeExactly 2
        $actual.Result[4]    | Should -BeExactly 3        
        $actual.Result[5]    | Should -BeExactly 'This is a powershell block'
    }

    It "Should execute the markdown from a URL" {
        $url = 'https://raw.githubusercontent.com/dfinke/PSPx/master/examples/markdown.md'
        
        $actual = Invoke-ExecuteMarkdown $url 
 
        $actual              | Should -Not -BeNullOrEmpty 
        $actual.Result.Count | Should -Be 4
        $actual.Script       | Should -Not -BeNullOrEmpty
    }
    
    It "Should execute mutiple markdown files" {
        $actual = Get-ChildItem $rootDir *.md | Invoke-ExecuteMarkdown

        $actual.Count | Should -Be 3

        $actual[0].Cmdlet | Should -BeExactly 'Invoke-ExecuteMarkdown'
        $actual[1].Cmdlet | Should -BeExactly 'Invoke-ExecuteMarkdown'
        
        # first file
        $scriptAsLines = $actual[0].Script.Split("`n")
        $scriptAsLines.Count | Should -Be 8

        # second file
        $scriptAsLines = $actual[1].Script.Split("`n")
        $scriptAsLines.Count | Should -Be 5
    }

    It "Should execute markdown strings directly" {
        $md = @'
```powershell
"Hello World"
```
'@
        $actual = Invoke-ExecuteMarkdown $md
        $scriptAsLines = $actual[0].Script.Split("`n")

        $scriptAsLines.Count | Should -Be 1

    }

    It "Should execute markdown strings piped" {
        $md = @'
```powershell
"Hello World"
```
'@
        $actual = $md | Invoke-ExecuteMarkdown
        $scriptAsLines = $actual[0].Script.Split("`n")

        $scriptAsLines.Count | Should -Be 1
    }

    It "Should throw if no Headers param on the function" {
        $url = 'https://raw.githubusercontent.com/dfinke/pstestX/main/test.md'
        { Invoke-ExecuteMarkdown -Path $url -Headers @{"A" = 1 } } | Should -Not -Throw 
    }

    It "Should get an error with a private url" {
        $url = 'https://raw.githubusercontent.com/dfinke/pstestX/main/test.md'
        # $header = @{"Authorization"="token $($env:GITHUB_TOKEN)"}        
        $actual = Invoke-ExecuteMarkdown $url

        $actual.Path  | Should -BeExactly $url
        $actual.Error | Should -BeExactly "404: Not Found"
    }
}