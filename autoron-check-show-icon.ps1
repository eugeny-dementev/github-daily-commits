# Get the current directory where this script is located
$currentDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Check if show-icon.ps1 exists in the current directory
$showIconPath = Join-Path -Path $currentDirectory -ChildPath "show-icon.ps1"
if (Test-Path $showIconPath) {
    # Check if show-icon.ps1 is running
    $isRunning = Get-Process | Where-Object { $_.Path -like "*\show-icon.ps1" }

    if (-not $isRunning) {
        # Run show-icon.ps1 in the background
        Start-Process powershell.exe -ArgumentList "-File '$showIconPath'" -WindowStyle Hidden
    }
} else {
    Write-Host "show-icon.ps1 not found in the current directory."
}
