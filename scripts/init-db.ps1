$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$DbPath = Join-Path $Root "nodered-data\escola.db"
$InitSql = Join-Path $Root "db\init.sql"

if (Test-Path $DbPath) {
    Write-Host "Banco ja existe: $DbPath"
    exit 0
}

if (Get-Command sqlite3 -ErrorAction SilentlyContinue) {
    cmd /c "sqlite3 ""$DbPath"" < ""$InitSql"""
    Write-Host "Banco criado: $DbPath"
    exit 0
}

if (Get-Command docker -ErrorAction SilentlyContinue) {
    $noderedData = Join-Path $Root "nodered-data"
    $dbFolder = Join-Path $Root "db"
    docker run --rm `
        -v "${noderedData}:/data" `
        -v "${dbFolder}:/db:ro" `
        alpine:3.20 `
        sh -c "apk add --no-cache sqlite >/dev/null && sqlite3 /data/escola.db < /db/init.sql"
    Write-Host "Banco criado via Docker: $DbPath"
    exit 0
}

Write-Error "Instale sqlite3 (https://www.sqlite.org/download.html) ou Docker Desktop para criar o banco."
exit 1
