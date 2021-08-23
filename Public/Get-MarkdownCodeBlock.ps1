function Get-MarkdownCodeBlock {
    <#
        .SYNOPSIS
            Extracts PowerShell code blocks from markdown
        .EXAMPLE
        Get-MarkdownCodeBlock -Path C:\temp\myfile.md
    #>
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        $Path
    )

    Process {
        if (!([System.Uri]::IsWellFormedUriString($Path, 'Absolute'))) {
            $Path = Resolve-Path $Path
            $mdContent = [System.IO.File]::ReadAllLines($Path)
        }
        else {
            $mdContent = Invoke-RestMethod $Path
            $mdContent = $mdContent -split "`n"
        }    

        $script = $null
        $found = $false
        
        switch ($mdContent) {
            { $_.StartsWith('```ps') -Or $_.StartsWith('```powershell') } { 
                $found = $true
                continue
            }
            
            { $_.StartsWith('```') } { 
                $found = $false 
                continue
            }
            
            default {
                if ($found -eq $true) {
                    $script += "{0}`r`n" -f $_
                }
            }
        }

        [PSCustomObject]@{
            Path   = $Path
            Script = $script
        }
    }
}