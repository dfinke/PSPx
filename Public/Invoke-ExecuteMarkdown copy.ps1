function Invoke-ExecuteMarkdown {
    <#
        .Example
        px https://gist.githubusercontent.com/dfinke/610703acacd915a94afc1a4695fc6fce/raw/479e8a5edc62607ac5f753a4eb2a56ead43a841f/testErrors.md
    #>
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        $Path
    )

    Begin {
        $PSNotebookRunspace = [PSNotebookRunspace]::new()
    }

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
    }

    End {
        $PSNotebookRunspace.PowerShell.Streams.Error.Clear()
        $invokeResult = $PSNotebookRunspace.Invoke($script)
        
        if ($PSNotebookRunspace.PowerShell.Streams.Error.Count -gt 0) {
            $result = $PSNotebookRunspace.PowerShell.Streams.Error | Out-String                    
        }
        
        $result += $invokeResult

        [PSCustomObject][Ordered]@{
            Script = $script 
            Result = $result
        }

        $PSNotebookRunspace.Close()
    }
}
