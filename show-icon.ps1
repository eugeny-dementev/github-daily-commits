Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$scriptName = $MyInvocation.MyCommand.Name
$currentPID = $PID
$runningScripts = Get-Process | Where-Object { 
    ($_ -match 'powershell' -or $_ -match 'powershell_ise') -and 
    $_.MainWindowTitle -like "*$scriptName*" -and 
    $_.Id -ne $currentPID 
}

foreach ($script in $runningScripts) {
    Stop-Process -Id $script.Id -Force
    Write-Host "Stopped previous script instance with PID: $($script.Id)"
}

# Function to create the notify icon
function Register-NotifyIcon {
    param(
        [string]$IconPath
    )

    if (-not (Test-Path $IconPath)) {
        Write-Error "Icon file not found at path: $IconPath"
        return $null
    }

    try {
        $icon = New-Object System.Drawing.Icon($IconPath)
    } catch {
        Write-Error "Failed to create icon from file: $_"
        return $null
    }

    $notifyIcon = New-Object System.Windows.Forms.NotifyIcon
    $notifyIcon.Icon = $icon
    $notifyIcon.Visible = $true
    $notifyIcon.Text = "GitHub daily commits"

    return $notifyIcon
}

# Path to the text file and icons
$textFilePath = "C:\Data\Soft\github-commits\status.txt"
$iconPaths = @("C:\Data\Soft\github-commits\icons\f0t0.ico", "C:\Data\Soft\github-commits\icons\f1t4.ico", "C:\Data\Soft\github-commits\icons\f5t6.ico", "C:\Data\Soft\github-commits\icons\f7t9.ico", "C:\Data\Soft\github-commits\icons\f10tX.ico") # Paths to your icons

# Create the initial icon
$notifyIcon = Register-NotifyIcon -IconPath $iconPaths[0]

# Update the icon based on the value in the text file
while ($true) {
    Start-Sleep -Seconds 10 # Update every 10 seconds

    $value = Get-Content -Path $textFilePath
    $iconIndex = 0

    if ($value -eq 0) {
        $iconIndex = 0
    } elseif ($value -ge 1 -and $value -le 4) {
        $iconIndex = 1
    } elseif ($value -ge 5 -and $value -le 6) {
        $iconIndex = 2
    } elseif ($value -ge 7 -and $value -le 9) {
        $iconIndex = 3
    } elseif ($value -ge 10) {
        $iconIndex = 4
    }

    if ($iconIndex -lt $iconPaths.Length -and $iconIndex -ge 0) {
        # Dispose the current icon if it exists
        if ($null -ne $notifyIcon.Icon) {
            $notifyIcon.Icon.Dispose()
        }

        # Set the new icon
        $notifyIcon.Icon = New-Object System.Drawing.Icon($iconPaths[$iconIndex])
    }
}

# Cleanup
$notifyIcon.Dispose()
