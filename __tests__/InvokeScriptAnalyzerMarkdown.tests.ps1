Import-Module $PSScriptRoot/../PSPx.psd1 -Force

Describe "Test Invoke Script Analyzer Markdown" -Tag "Invoke-ScriptAnalyzerMarkdown" {

    BeforeAll {
        $rootDir = "$PSScriptRoot/testMarkdownFiles"
    }

    It "Should run PSSA on the markdown blocks" {        
        $fileName = $rootDir + "/PSBlocksPSSA-Issues.md"

        $actual = Invoke-ScriptAnalyzerMarkdown $fileName
        
        $actual                            | Should -Not -BeNullOrEmpty
        $actual.ResultScriptAnalyzer.Count | Should -Be 2
    }
}