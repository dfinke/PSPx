foreach ($directory in @('Private', 'Public')) {
    Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1" -ErrorAction SilentlyContinue | ForEach-Object { 
        . $_.FullName 
    }
}

Set-Alias px Invoke-ExecuteMarkdown
