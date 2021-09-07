function New-MardownEntry {
    param(
        [ValidateSet('markdown', 'psscript')]
        $type,
        $text
    )

    [pscustomobject]@{Type = $type; Text = @($text) }
}

function Get-PSScript {
    param(
        $parsedMarkdown
    )

    $parsedMarkdown | Where-Object type -eq 'psscript' | 
    ForEach-Object { 
        $end = $_.Text.Count - 2
        $_.Text[1..$end]
    }
}

function Update-MarkdownCodeFormatting {
    param(
        [Parameter(Mandatory)]
        $parsedMarkdown
    )

    switch ($parsedMarkdown) {
        { $_.Type -eq 'markdown' } {
            continue 
        }
        { $_.Type -eq 'psscript' } {
            $end = $_.Text.Count - 2
            $s = $_.Text[1..$end] -join "`n"
            $s = Invoke-Formatter -ScriptDefinition $s

            $_.Text = "{0}`n{1}`n{2}" -f $_.Text[0], $s, $_.Text[-1]
            continue 
        }
    }
    
    $parsedMarkdown
} 

function Invoke-ParseMarkdown {
    param(
        [string[]]$markdown,
        [Switch]$Raw
    )

    $parsedMD = @()

    $newMarkdowEntry = $true
    $found = $false

    switch ($markdown) {
        { $_.Trim() -eq '```ps' -Or $_.Trim() -eq '```ps1' -Or $_.Trim() -eq '```powershell' } {
            $parsedMD += New-MardownEntry "PSScript" ("{0}" -f $_)
            $found = $true
            continue
        }
    
        { $_.StartsWith('```') } { 
            $found = $false 
            $parsedMD[-1].Text += "{0}" -f $_
            $newMarkdowEntry = $true
            continue
        }
    
        default {
            if ($found -eq $true) {
                $parsedMD[-1].Text += "{0}" -f $_
            }
            else {
                if ($newMarkdowEntry -eq $true) {
                    $parsedMD += New-MardownEntry "Markdown"
                    $newMarkdowEntry = $false                
                }
                $parsedMD[-1].Text += "{0}" -f $_
            }
        }
    }

    if ($Raw) {
        $parsedMD | Add-Member -PassThru -MemberType NoteProperty -Name Path -Value $Path
    }
    else {
        [PSCustomObject]@{
            Path   = $Path
            Script = (Get-PSScript $parsedMD)
        }
    }
}

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
        $Headers,
        [Switch]$Raw
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

        Invoke-ParseMarkdown $mdContent -Raw:$Raw
    }
}