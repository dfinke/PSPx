Import-Module $PSScriptRoot/../PSPx.psd1 -Force

Describe "Test Invoke Script Formatter Markdown" -Tag "Invoke-ScriptFormatterMarkdown" -Skip {

    BeforeAll {
        $rootDir = "$PSScriptRoot/testMarkdownFiles"
    }

    It "Should run PSSA formatter on the markdown script blocks" {        
        #$fileName = $rootDir + "/PSBlocksPSSA-Issues.md"
        $s = @'
```ps1
@{
1='a'
10='b'
100='c'
}
```
'@
        $actual = Invoke-ScriptFormatterMarkdown $s

        $actual | Should -Be "hello"
    }
}