[System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(65001)
$OutputEncoding = [System.Text.Encoding]::GetEncoding(65001)

Write-Host "`n=== 开始安装 cjbind ===" -ForegroundColor Cyan

try {
    Write-Host "[1/3] 正在从GitHub获取最新版本..." -ForegroundColor Cyan
    
    $headers = @{}
    if ($env:GITHUB_TOKEN) {
        $headers["Authorization"] = "token $($env:GITHUB_TOKEN)"
    }

    $releaseInfo = Invoke-RestMethod -Uri 'https://api.github.com/repos/cjbind/cjbind/releases/latest' -Headers $headers -ErrorAction Stop
    
    $latestTag = $releaseInfo.tag_name
    Write-Host "    √ 获取到最新版本：$latestTag" -ForegroundColor Green
}
catch {
    Write-Host "错误：无法获取最新版本 - $_" -ForegroundColor Red
    exit 1
}

$targetDir = "$env:USERPROFILE\.cjpm\bin"
try {
    Write-Host "[2/3] 正在创建安装目录..." -ForegroundColor Cyan
    Write-Host "    目标路径：$targetDir"
    
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force -ErrorAction Stop | Out-Null
        Write-Host "    √ 目录创建成功" -ForegroundColor Green
    }
    else {
        Write-Host "    ! 目录已存在，跳过创建" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "错误：目录创建失败 - $_" -ForegroundColor Red
    exit 1
}

$downloadUrl = "https://github.com/cjbind/cjbind/releases/download/$latestTag/cjbind-windows-x64.exe"
$destination = "$targetDir\cjbind.exe"
try {
    Write-Host "[3/3] 正在下载程序文件..." -ForegroundColor Cyan
    Write-Host "    下载地址：$downloadUrl"
    Write-Host "    保存路径：$destination`n"

    $originalProgress = $global:ProgressPreference
    $global:ProgressPreference = 'Continue'

    Invoke-WebRequest -Uri $downloadUrl -OutFile $destination -ErrorAction Stop

    $global:ProgressPreference = $originalProgress

    Write-Host "`n    √ 文件下载完成" -ForegroundColor Green

    $fileSize = (Get-Item $destination).Length / 1MB
    Write-Host "    文件大小：{0:N2} MB" -f $fileSize
}
catch {
    Write-Host "`n错误：下载失败 - $_" -ForegroundColor Red
    exit 1
}

Write-Host "`n=== 安装成功 ===" -ForegroundColor Green
Write-Host "程序已安装到：$destination`n" -ForegroundColor Green