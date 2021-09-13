function Invoke-UpdateScriptFormat {
    <#
        .SYNOPSIS
            Run PowerShell Script Analyzer Formatter on code blocks, and return both markdown and formatted code blocks as a string.
            
        .EXAMPLE
        Invoke-UpdateScriptFormat 'https://gist.githubusercontent.com/dfinke/610703acacd915a94afc1a4695fc6fce/raw/479e8a5edc62607ac5f753a4eb2a56ead43a841f/testErrors.md'

    #>
    param(
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [Alias('FullName')]
        $Path,
        $Headers
    )

    Process {
        $md = Get-MarkdownCodeBlock -Path $Path -Raw -Headers $Headers
        (Update-MarkdownCodeFormatting $md).Text
    }
}