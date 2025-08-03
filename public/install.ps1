try {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8
} catch {
    $OutputEncoding = [System.Text.Encoding]::UTF8
}
# 检查是否使用镜像
$UseMirror = $false
foreach ($arg in $args) {
    if ($arg -eq "--mirror" -or $arg -eq "-m") {
        $UseMirror = $true
        break
    }
}

Write-Host "`n=== Starting cjbind installation ===" -ForegroundColor Cyan

try {
    Write-Host "[1/3] Fetching latest version from GitHub..." -ForegroundColor Cyan
    
    $headers = @{}
    if ($env:GITHUB_TOKEN) {
        $headers["Authorization"] = "token $($env:GITHUB_TOKEN)"
    }

    $releaseInfo = Invoke-RestMethod -Uri 'https://api.github.com/repos/cjbind/cjbind/releases/latest' -Headers $headers -ErrorAction Stop
    
    $latestTag = $releaseInfo.tag_name
    Write-Host "    Latest version retrieved: $latestTag" -ForegroundColor Green
}
catch {
    Write-Host "Error: Failed to get latest version - $_" -ForegroundColor Red
    exit 1
}

$targetDir = "$env:USERPROFILE\.cjpm\bin"
try {
    Write-Host "[2/3] Creating installation directory..." -ForegroundColor Cyan
    Write-Host "    Target path: $targetDir"
    
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force -ErrorAction Stop | Out-Null
        Write-Host "    Directory created successfully" -ForegroundColor Green
    }
    else {
    Write-Host "    ! Directory already exists, skipping creation" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Error: Failed to create directory - $_" -ForegroundColor Red
    exit 1
}

if ($UseMirror) {
    $downloadUrl = "https://gitcode.com/Cangjie-TPC/cjbind/releases/download/$latestTag/cjbind-windows-x64.exe"
    $mirrorStatus = "Yes"
} else {
    $downloadUrl = "https://github.com/cjbind/cjbind/releases/download/$latestTag/cjbind-windows-x64.exe"
    $mirrorStatus = "No"
}
$destination = "$targetDir\cjbind.exe"
try {
    Write-Host "[3/3] Downloading program file..." -ForegroundColor Cyan
    Write-Host "    Using mirror: $mirrorStatus" -ForegroundColor Yellow
    Write-Host "    Download URL: $downloadUrl"
    Write-Host "    Save path: $destination`n"

    $originalProgress = $global:ProgressPreference
    $global:ProgressPreference = 'Continue'

    Invoke-WebRequest -Uri $downloadUrl -OutFile $destination -ErrorAction Stop

    $global:ProgressPreference = $originalProgress

    Write-Host "`n    File download completed" -ForegroundColor Green

    $fileSize = (Get-Item $destination).Length / 1MB
    Write-Host ("    File size: {0:N2} MB" -f $fileSize) -ForegroundColor Cyan
}
catch {
    Write-Host "`nError: Download failed - $_" -ForegroundColor Red
    exit 1
}

Write-Host "`n=== Installation successful ===" -ForegroundColor Green
Write-Host "Program installed to: $destination`n" -ForegroundColor Green