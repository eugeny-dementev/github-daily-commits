Add-Type -AssemblyName System.Drawing

function Convert-BmpToIco {
    param(
        [string]$InputPath,
        [string]$OutputPath
    )

    $bitmap = [System.Drawing.Bitmap]::FromFile($InputPath)
    $icon = [System.Drawing.Icon]::FromHandle($bitmap.GetHicon())
    $fileStream = [System.IO.FileStream]::new($OutputPath, [System.IO.FileMode]::Create)
    $icon.Save($fileStream)
    $fileStream.Close()
    $icon.Dispose()
    $bitmap.Dispose()
}

# BMP file paths
$bmpFiles = @(
    "C:\Data\Soft\github-commits\icons\f1t4.bmp",
    "C:\Data\Soft\github-commits\icons\f5t6.bmp",
    "C:\Data\Soft\github-commits\icons\f7t9.bmp",
    "C:\Data\Soft\github-commits\icons\f10tX.bmp"
)

# Loop through each BMP file and convert to ICO
foreach ($bmpFile in $bmpFiles) {
    $icoFile = [System.IO.Path]::ChangeExtension($bmpFile, ".ico")
    Convert-BmpToIco -InputPath $bmpFile -OutputPath $icoFile
    Write-Host "Converted $bmpFile to $icoFile"
}
