function Invoke-ExecuteMarkdown {
    <#
        .Synopsis
        Execute PowerShell written in markdown code blocks
        
        .Example
        px https://gist.githubusercontent.com/dfinke/610703acacd915a94afc1a4695fc6fce/raw/479e8a5edc62607ac5f753a4eb2a56ead43a841f/testErrors.md

        .Example
        $url = 'https://private.url.com/test.md'
        $header = @{"Authorization"="token $($env:GITHUB_TOKEN)"}
        Invoke-ExecuteMarkdown $url $header
    #>
    param(
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [Alias('FullName')]
        $Path,
        $Headers
    )

    Process {

        $mdCodeBlock = Get-MarkdownCodeBlock $Path -Headers $Headers
        if (!$mdCodeBlock.Error) {
            $PSNotebookRunspace = [PSNotebookRunspace]::new()
            $result = $null
        
            $invokeResult = $PSNotebookRunspace.Invoke($mdCodeBlock.script)
        
            if ($PSNotebookRunspace.PowerShell.Streams.Error.Count -gt 0) {
                $result = $PSNotebookRunspace.PowerShell.Streams.Error | Out-String                    
            }
        
            $result += $invokeResult

            $mdCodeBlock |
            Add-Member -PassThru -MemberType NoteProperty -Name Cmdlet -Value $MyInvocation.MyCommand |
            Add-Member -PassThru -MemberType NoteProperty -Name Result -Value $result

            $PSNotebookRunspace.Close()
        }
        else {
            $mdCodeBlock        
        }
    }
}
