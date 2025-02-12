$latestTag = (Invoke-RestMethod -Uri 'https://api.github.com/repos/cjbind/cjbind/releases/latest').tag_name

$targetDir = "$env:USERPROFILE\.cjpm\bin"

New-Item -ItemType Directory -Force -Path $targetDir -ErrorAction Stop | Out-Null

$url = "https://github.com/cjbind/cjbind/releases/download/$latestTag/cjbind-windows-x64.exe"
try {
    Invoke-WebRequest -Uri $url -OutFile "$targetDir\cjbind.exe" -ErrorAction Stop
} catch {
    Write-Host "Download failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host "Installed to $targetDir\cjbind.exe" -ForegroundColor Green
