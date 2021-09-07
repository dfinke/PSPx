Import-Module $PSScriptRoot/../PSPx.psd1 -Force

Describe "Test Invoke Update Script Format" -Tag "Invoke-UpdateScriptFormat" {
    It "Should update PS code in place" {
        $rootdir = Join-Path $PSScriptRoot 'testRawMDFiles'
        $fileName = Join-Path $rootDir 'hashtable.md'

        $actual = Invoke-UpdateScriptFormat $fileName

        $actual.Count | Should -Be 2

        $actual[0].Type | Should -BeExactly 'Markdown'
        $actual[0].Path | Should -BeExactly $fileName
        $actual[0].Text.Count | Should -Be 3
        $actual[0].Text[0] | Should -BeNullOrEmpty
        $actual[0].Text[1] | Should -Be '# a hashtable'
        $actual[0].Text[2] | Should -BeNullOrEmpty
        
        $actual[1].Type | Should -BeExactly 'PSScript'
        $actual[1].Path | Should -BeExactly $fileName
        $actual[1].Text.Count | Should -Be 1
        
        $text = $actual[1].Text -split "`n"
        $text.Count | Should -Be 7
        $text[0] | Should -Be '```ps1'
        $text[1] | Should -Be '@{'
        $text[2] | Should -Be "    10   = 'a'"
        $text[3] | Should -Be "    100  = 'a'"
        $text[4] | Should -Be "    1000 = 'a'"
        $text[5] | Should -Be '}'
        $text[6] | Should -Be '```'
    }
}