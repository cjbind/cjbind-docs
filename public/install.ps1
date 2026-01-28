try {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8
} catch {
    $OutputEncoding = [System.Text.Encoding]::UTF8
}

function Show-Help {
    Write-Host @"
Usage: install.ps1 [OPTIONS]

Options:
  -m, --mirror    Use mirror source (gitcode.com)
  -d, --dynamic   Install dynamic build (requires system LLVM, smaller size)
  -h, --help      Show this help message

By default, the static build is installed (includes LLVM, larger size).

Examples:
  .\install.ps1              # Install static build from GitHub
  .\install.ps1 --dynamic    # Install dynamic build from GitHub
  .\install.ps1 --mirror     # Install static build from mirror
  .\install.ps1 -d -m        # Install dynamic build from mirror
"@
    exit 0
}

# 检查命令行参数
$UseMirror = $false
$UseStatic = $true
foreach ($arg in $args) {
    if ($arg -eq "--mirror" -or $arg -eq "-m") {
        $UseMirror = $true
    }
    elseif ($arg -eq "--dynamic" -or $arg -eq "-d") {
        $UseStatic = $false
    }
    elseif ($arg -eq "--help" -or $arg -eq "-h") {
        Show-Help
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

$linkType = if ($UseStatic) { "static" } else { "dynamic" }
$filename = "cjbind-windows-x64-$linkType.exe"

if ($UseMirror) {
    $downloadUrl = "https://gitcode.com/Cangjie-TPC/cjbind/releases/download/$latestTag/$filename"
    $mirrorStatus = "Yes"
} else {
    $downloadUrl = "https://github.com/cjbind/cjbind/releases/download/$latestTag/$filename"
    $mirrorStatus = "No"
}

$linkTypeDesc = if ($UseStatic) { "Static (includes LLVM, larger size)" } else { "Dynamic (requires system LLVM, smaller size)" }

$destination = "$targetDir\cjbind.exe"
try {
    Write-Host "[3/3] Downloading program file..." -ForegroundColor Cyan
    Write-Host "    Using mirror: $mirrorStatus" -ForegroundColor Yellow
    Write-Host "    Link type: $linkTypeDesc" -ForegroundColor Cyan
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