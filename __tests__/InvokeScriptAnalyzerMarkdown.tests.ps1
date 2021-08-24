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
}