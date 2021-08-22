class PSNotebookRunspace {
    $Runspace
    $PowerShell

    PSNotebookRunspace() {
        $this.Runspace = [runspacefactory]::CreateRunspace()
        $this.PowerShell = [powershell]::Create()
        $this.PowerShell.runspace = $this.Runspace
        $this.Runspace.Open()
    }

    [object]Invoke($code) {
        $this.PowerShell.AddScript(($code -join "`r`n"))
        return $this.PowerShell.Invoke()
    }

    [void]Close() {
        $this.Runspace.Close()
    }
}