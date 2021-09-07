Import-Module $PSScriptRoot/../PSPx.psd1 -Force

Describe "Test Invoke Update Script Format" -Tag "Invoke-UpdateScriptFormat" {
    It "Should update PS code in place" {
        $rootdir = Join-Path $PSScriptRoot 'testRawMDFiles'
        $fileName = Join-Path $rootDir 'hashtable.md'

        $actual = Invoke-UpdateScriptFormat $fileName

        $actual.Count | Should -Be 4

        $actual[0] | Should -BeNullOrEmpty 
        $actual[1] | Should -BeExactly '# a hashtable'
        $actual[2] | Should -BeNullOrEmpty 
        
        $text = $actual[3] -split "`n"

        $text[0] | Should -BeExactly '```ps1'
        $text[1] | Should -BeExactly '@{'
        $text[2] | Should -BeExactly "    10   = 'a'"
        $text[3] | Should -BeExactly "    100  = 'a'"
        $text[4] | Should -BeExactly "    1000 = 'a'"
        $text[5] | Should -BeExactly '}'
        $text[6] | Should -BeExactly '```'
    }
}