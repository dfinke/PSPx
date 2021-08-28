function Get-MarkdownCodeBlock {
    <#
        .SYNOPSIS
            Extracts PowerShell code blocks from markdown
        
        .EXAMPLE
        Get-MarkdownCodeBlock -Path C:\temp\myfile.md
        
        .Example
        $url = 'https://private.url.com/test.md'
        $header = @{"Authorization"="token $($env:GITHUB_TOKEN)"}
        Get-MarkdownCodeBlock $url $header        
    #>
    param(
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [Alias('FullName')]
        $Path,
        $Headers
    )

    Process {
        if (([System.Uri]::IsWellFormedUriString($Path, 'Absolute'))) {
            $InvokeParams = @{Uri = $Path }
            
            if ($Headers) {
                $InvokeParams["Headers"] = $Headers
            }

            try {
                $Error.Clear()
                $mdContent = Invoke-RestMethod @InvokeParams
            }
            catch {
                $err = [PSCustomObject]@{
                    Path  = $Path
                    Error = $_
                }
                
                return $err
            }
            
            $mdContent = $mdContent -split "`n"
        }
        elseif (Test-Path $Path) {
            $Path = Resolve-Path $Path
            $mdContent = [System.IO.File]::ReadAllLines($Path)
        }    
        elseif ($Path -is [string]) {
            $mdContent = $Path -split "`n"
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