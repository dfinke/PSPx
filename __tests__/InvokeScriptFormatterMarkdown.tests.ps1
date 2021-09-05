Import-Module $PSScriptRoot/../PSPx.psd1 -Force

Describe "Test Invoke Script Formatter Markdown" -Tag "Invoke-ScriptFormatterMarkdown" {

    BeforeAll {
        $rootDir = "$PSScriptRoot/testMarkdownFiles"
    }

    It "Should handle formatting script blocks" {
        $fileName = $rootDir + "/FormatPSBlocks.md"

        $actual = Invoke-ScriptFormatterMarkdown $fileName
        $lines = $actual.Result -split "`n"

        $actual.Cmdlet | Should -BeExactly 'Invoke-ScriptFormatterMarkdown'
        
        $lines.Count | Should -Be 5
        $lines[0] | Should -BeExactly '@{'
        $lines[1] | Should -BeExactly "    1   ='a'"
        $lines[2] | Should -BeExactly "    10  ='b'"
        $lines[3] | Should -BeExactly "    100 ='c'"
        $lines[4] | Should -BeExactly '}'
    }
}