$ErrorActionPreference = 'Stop'

$sdk = 'C:\Users\dyllo\AppData\Local\Android\Sdk'
$tools = "$sdk\build-tools\35.0.0"
$platform = "$sdk\platforms\android-35\android.jar"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$out = Join-Path $root 'build'
$obj = Join-Path $out 'obj'

Write-Host "==> Verificando ferramentas..."

if (!(Test-Path $platform)) {
    throw "android.jar nao encontrado: $platform"
}

if (!(Test-Path "$tools\aapt2.exe")) {
    throw "aapt2.exe nao encontrado."
}

if (!(Test-Path "$tools\aapt.exe")) {
    throw "aapt.exe nao encontrado."
}

if (!(Test-Path "$tools\d8.bat")) {
    throw "d8.bat nao encontrado."
}

if (!(Test-Path "$tools\zipalign.exe")) {
    throw "zipalign.exe nao encontrado."
}

if (!(Test-Path "$tools\apksigner.bat")) {
    throw "apksigner.bat nao encontrado."
}

# ============================================================
# LIMPA BUILD
# ============================================================

Write-Host "==> Limpando build anterior..."

if (Test-Path $out) {
    Remove-Item $out -Recurse -Force
}

# ============================================================
# CRIA DIRETORIOS
# ============================================================

Write-Host "==> Criando diretorios..."

New-Item -ItemType Directory -Force -Path $out | Out-Null
New-Item -ItemType Directory -Force -Path $obj | Out-Null
New-Item -ItemType Directory -Force -Path "$obj\res" | Out-Null
New-Item -ItemType Directory -Force -Path "$obj\classes" | Out-Null
New-Item -ItemType Directory -Force -Path "$obj\dex" | Out-Null

# ============================================================
# COMPILA JAVA
# ============================================================

Write-Host "==> Compilando Java..."

$javaFiles = @(
    "$root\app\src\main\java\br\com\palpiteiro\app\MainActivity.java"
    "$root\app\src\main\java\br\com\palpiteiro\app\HistoryDbHelper.java"
)

& javac -encoding UTF-8 -source 8 -target 8 -classpath $platform -d "$obj\classes" $javaFiles

if ($LASTEXITCODE -ne 0) {
    throw "Falha na compilacao Java."
}

if (!(Test-Path "$obj\classes\br\com\palpiteiro\app\MainActivity.class")) {
    throw "MainActivity.class nao foi gerado."
}

if (!(Test-Path "$obj\classes\br\com\palpiteiro\app\HistoryDbHelper.class")) {
    throw "HistoryDbHelper.class nao foi gerado."
}

Write-Host "==> Java compilado com sucesso."

# ============================================================
# COMPILA RECURSOS
# ============================================================

Write-Host "==> Compilando recursos..."

& "$tools\aapt2.exe" compile --dir "$root\app\src\main\res" -o "$obj\res.zip"

if ($LASTEXITCODE -ne 0) {
    throw "Falha na compilacao dos recursos."
}

if (!(Test-Path "$obj\res.zip")) {
    throw "res.zip nao foi gerado."
}

# ============================================================
# GERA APK BASE
# ============================================================

Write-Host "==> Gerando APK base..."

& "$tools\aapt2.exe" link `
    -I $platform `
    --manifest "$root\app\src\main\AndroidManifest.xml" `
    -o "$obj\unsigned.apk" `
    "$obj\res.zip"

if ($LASTEXITCODE -ne 0) {
    throw "Falha ao gerar o APK base."
}

if (!(Test-Path "$obj\unsigned.apk")) {
    throw "unsigned.apk nao foi gerado."
}

# ============================================================
# COPIA ASSETS
# ============================================================

Write-Host "==> Copiando assets..."

$assetsSource = "$root\app\src\main\assets"

if (!(Test-Path $assetsSource)) {
    throw "Pasta assets nao encontrada: $assetsSource"
}

if (!(Test-Path "$assetsSource\index.html")) {
    throw "assets/index.html nao encontrado."
}

if (!(Test-Path "$assetsSource\historico.json")) {
    throw "assets/historico.json nao encontrado."
}

Copy-Item $assetsSource "$obj\assets" -Recurse -Force

# ============================================================
# ADICIONA TODOS OS ASSETS NO APK
# ============================================================

Write-Host "==> Adicionando assets ao APK..."

Push-Location $obj

try {

    $assetFiles = @(
        Get-ChildItem "assets" -Recurse -File |
        ForEach-Object {
            $_.FullName.Substring($obj.Length + 1).Replace('\','/')
        }
    )

    if ($assetFiles.Count -eq 0) {
        throw "Nenhum asset encontrado."
    }

    Write-Host "==> Assets encontrados: $($assetFiles.Count)"

    foreach ($asset in $assetFiles) {
        Write-Host "    $asset"
    }

    & "$tools\aapt.exe" add unsigned.apk $assetFiles

    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao adicionar os assets."
    }

}
finally {
    Pop-Location
}

Write-Host "==> Assets adicionados."

# ============================================================
# GERA DEX
# ============================================================

Write-Host "==> Gerando classes.dex..."

$dexZip = "$obj\classes-dex.zip"

$classFiles = @(
    Get-ChildItem "$obj\classes" -Recurse -Filter "*.class" |
    ForEach-Object {
        $_.FullName
    }
)

if ($classFiles.Count -eq 0) {
    throw "Nenhum arquivo .class encontrado."
}

Write-Host "==> Classes encontradas: $($classFiles.Count)"

foreach ($classFile in $classFiles) {
    Write-Host "    $classFile"
}

& "$tools\d8.bat" --lib $platform --output $dexZip $classFiles

if ($LASTEXITCODE -ne 0) {
    throw "Falha ao gerar classes.dex."
}

if (!(Test-Path $dexZip)) {
    throw "classes-dex.zip nao foi gerado."
}

# ============================================================
# EXTRAI DEX
# ============================================================

Write-Host "==> Extraindo classes.dex..."

Expand-Archive $dexZip "$obj\dex" -Force

if (!(Test-Path "$obj\dex\classes.dex")) {
    throw "classes.dex nao foi encontrado."
}

# ============================================================
# ADICIONA DEX
# ============================================================

Write-Host "==> Adicionando classes.dex..."

Push-Location "$obj\dex"

try {

    & "$tools\aapt.exe" add ..\unsigned.apk classes.dex

    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao adicionar classes.dex."
    }

}
finally {
    Pop-Location
}

# ============================================================
# VERIFICA APK BASE
# ============================================================

Write-Host "==> Verificando APK base..."

$apkContents = & "$tools\aapt.exe" list "$obj\unsigned.apk"

if ($LASTEXITCODE -ne 0) {
    throw "Nao foi possivel verificar o APK."
}

if ($apkContents -notcontains "classes.dex") {
    throw "ERRO: classes.dex nao esta na raiz."
}

if ($apkContents -contains "dex/classes.dex") {
    throw "ERRO: dex/classes.dex esta presente."
}

if ($apkContents -notcontains "assets/index.html") {
    throw "ERRO: index.html nao esta no APK."
}

if ($apkContents -notcontains "assets/historico.json") {
    throw "ERRO: historico.json nao esta no APK."
}

if ($apkContents -notcontains "assets/images/logo-azul.jpeg") {
    throw "ERRO: logo-azul.jpeg nao esta no APK."
}

if ($apkContents -notcontains "assets/images/logo-amarela.jpeg") {
    throw "ERRO: logo-amarela.jpeg nao esta no APK."
}

Write-Host "==> APK base verificado."
Write-Host "==> Logos presentes."

# ============================================================
# KEYSTORE
# ============================================================

Write-Host "==> Preparando assinatura..."

$keystore = "$out\debug.keystore"

if (!(Test-Path $keystore)) {

    & keytool `
        -genkeypair `
        -keystore $keystore `
        -storepass android `
        -keypass android `
        -alias brasileiraodadepressao `
        -dname 'CN=Brasileirao da Depressao' `
        -keyalg RSA `
        -keysize 2048 `
        -validity 10000

    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao criar o keystore."
    }
}

# ============================================================
# ZIPALIGN
# ============================================================

Write-Host "==> Executando zipalign..."

$alignedApk = "$out\BrasileiraoDaDepressao-unsigned-aligned.apk"

& "$tools\zipalign.exe" -f 4 "$obj\unsigned.apk" $alignedApk

if ($LASTEXITCODE -ne 0) {
    throw "Falha no zipalign."
}

if (!(Test-Path $alignedApk)) {
    throw "APK alinhado nao foi gerado."
}

# ============================================================
# ASSINATURA
# ============================================================

Write-Host "==> Assinando APK..."

$finalApk = "$out\BrasileiraoDaDepressao.apk"

& "$tools\apksigner.bat" `
    sign `
    --ks $keystore `
    --ks-pass pass:android `
    --key-pass pass:android `
    --out $finalApk `
    $alignedApk

if ($LASTEXITCODE -ne 0) {
    throw "Falha ao assinar APK."
}

if (!(Test-Path $finalApk)) {
    throw "BrasileiraoDaDepressao.apk nao foi gerado."
}

# ============================================================
# VERIFICA ASSINATURA
# ============================================================

Write-Host "==> Verificando assinatura..."

& "$tools\apksigner.bat" verify --verbose $finalApk

if ($LASTEXITCODE -ne 0) {
    throw "O APK nao passou na verificacao da assinatura."
}

# ============================================================
# VERIFICA APK FINAL
# ============================================================

Write-Host "==> Verificando APK final..."

$finalContents = & "$tools\aapt.exe" list "$finalApk"

if ($LASTEXITCODE -ne 0) {
    throw "Nao foi possivel verificar o APK final."
}

if ($finalContents -notcontains "classes.dex") {
    throw "ERRO: classes.dex nao esta na raiz do APK final."
}

if ($finalContents -contains "dex/classes.dex") {
    throw "ERRO: dex/classes.dex esta presente."
}

if ($finalContents -notcontains "assets/index.html") {
    throw "ERRO: index.html nao esta no APK final."
}

if ($finalContents -notcontains "assets/historico.json") {
    throw "ERRO: historico.json nao esta no APK final."
}

if ($finalContents -notcontains "assets/images/logo-azul.jpeg") {
    throw "ERRO: logo-azul.jpeg nao esta no APK final."
}

if ($finalContents -notcontains "assets/images/logo-amarela.jpeg") {
    throw "ERRO: logo-amarela.jpeg nao esta no APK final."
}

# ============================================================
# TAMANHO
# ============================================================

$apk = Get-Item $finalApk

if ($apk.Length -le 0) {
    throw "O APK foi gerado vazio."
}

# ============================================================
# SUCESSO
# ============================================================

Write-Host ""
Write-Host "========================================"
Write-Host " APK criado com sucesso!"
Write-Host " Tamanho: $($apk.Length) bytes"
Write-Host " Arquivo: $($apk.FullName)"
Write-Host " classes.dex: OK"
Write-Host " Assets: OK"
Write-Host " Logos: OK"
Write-Host " Assinatura: OK"
Write-Host " Nome: BrasileiraoDaDepressao.apk"
Write-Host "========================================"