function Invoke-UpdateScriptFormat {
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