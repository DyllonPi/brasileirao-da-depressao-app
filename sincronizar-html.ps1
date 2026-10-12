$ErrorActionPreference = "Stop"

$android = Join-Path $PSScriptRoot "app\src\main\assets\index.html"
$web = Join-Path $PSScriptRoot "cloudflare-site\index.html"

if (!(Test-Path $android)) {
    throw "HTML principal do Android não encontrado: $android"
}

if (!(Test-Path $web)) {
    throw "HTML do Cloudflare não encontrado: $web"
}

Copy-Item $android $web -Force

$hashAndroid = (Get-FileHash $android -Algorithm SHA256).Hash
$hashWeb = (Get-FileHash $web -Algorithm SHA256).Hash

if ($hashAndroid -ne $hashWeb) {
    throw "Falha na sincronização: os arquivos estão diferentes."
}

Write-Host "Sincronização concluída!" -ForegroundColor Green
Write-Host "Android e Cloudflare estão com o mesmo HTML."
Write-Host "Hash: $hashAndroid"

$serviceWorker = Join-Path $PSScriptRoot "cloudflare-site\firebase-messaging-sw.js"

if (Test-Path $serviceWorker) {
    Write-Host "Service worker web preservado."
} else {
    Write-Warning "O service worker web não foi encontrado."
}
