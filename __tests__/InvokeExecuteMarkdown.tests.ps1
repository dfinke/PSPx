Import-Module $PSScriptRoot/../PSPx.psd1 -Force

Describe "Test Invoke Execute Markdown" -Tag "Invoke-ExecuteMarkdown" {

    BeforeAll {
        $rootDir = "$PSScriptRoot/testMarkdownFiles"
    }

    It "Should execute the markdown and return results" {        
        $fileName = $rootDir + "/basicPSBlocks.md"

        $actual = Invoke-ExecuteMarkdown $fileName
        
        $actual | Should -Not -BeNullOrEmpty
        
        $actual.Result.Count | Should -Be 6

        $actual.Result[0] | Should -BeExactly 'Hello World'
        $actual.Result[1] | Should -BeExactly 'Goodbye'
        $actual.Result[2] | Should -BeExactly 1
        $actual.Result[3] | Should -BeExactly 2
        $actual.Result[4] | Should -BeExactly 3        
        $actual.Result[5] | Should -BeExactly 'This is a powershell block'
    }

    It "Should execute the markdown from a URL" {
        $url = 'https://raw.githubusercontent.com/dfinke/PSPx/master/examples/markdown.md'
        
        $actual = Invoke-ExecuteMarkdown $url 
 
        $actual | Should -Not -BeNullOrEmpty
 
        $actual.Result.Count | Should -Be 4

        $expected = '$PSVersionTable
$pwd
$env:APPDATA
function Get-Info {
    "Test Info $(get-date)"
}
Get-Info
'
        $actual.Script | Should -Be $expected
    }
}