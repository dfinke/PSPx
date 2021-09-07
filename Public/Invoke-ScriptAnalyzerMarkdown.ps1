function Invoke-ScriptAnalyzerMarkdown {
    <#
        .Synopsis
        Run PowerShell Script Analyzer on code blocks written in markdown
        
        .Example
        Invoke-ScriptAnalyzerMarkdown https://gist.githubusercontent.com/dfinke/610703acacd915a94afc1a4695fc6fce/raw/479e8a5edc62607ac5f753a4eb2a56ead43a841f/testErrors.md

        .Example
        $url = 'https://private.url.com/test.md'
        $header = @{"Authorization"="token $($env:GITHUB_TOKEN)"}
        Invoke-ScriptAnalyzerMarkdown $url $header

    #>
    param(
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [Alias('FullName')]
        $Path,
        $Headers
    )

    Process {
        $mdCodeBlock = Get-MarkdownCodeBlock -Path $Path -Headers $Headers

        if (!$mdCodeBlock.Error) {

            $result = Invoke-ScriptAnalyzer -ScriptDefinition ($mdCodeBlock.script -join "`n")
    
            $mdCodeBlock |
            Add-Member -PassThru -MemberType NoteProperty -Name Cmdlet -Value $MyInvocation.MyCommand |
            Add-Member -PassThru -MemberType NoteProperty -Name Result -Value $result
        }
        else {
            $mdCodeBlock
        }
    }
}
