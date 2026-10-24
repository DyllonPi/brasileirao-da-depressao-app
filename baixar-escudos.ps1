$ErrorActionPreference = "Stop"

$destino = Join-Path $PSScriptRoot "app\src\main\assets\images"
New-Item -ItemType Directory -Path $destino -Force | Out-Null

$times = @(
    @{ Nome = "athletico-paranaense"; Id = 3432 },
    @{ Nome = "atletico-mineiro"; Id = 3427 },
    @{ Nome = "bahia"; Id = 692 },
    @{ Nome = "botafogo"; Id = 2864 },
    @{ Nome = "chapecoense"; Id = 710 },
    @{ Nome = "corinthians"; Id = 303 },
    @{ Nome = "coritiba"; Id = 6285 },
    @{ Nome = "cruzeiro"; Id = 3371 },
    @{ Nome = "flamengo"; Id = 1024 },
    @{ Nome = "fluminense"; Id = 1095 },
    @{ Nome = "gremio"; Id = 2925 },
    @{ Nome = "internacional"; Id = 2696 },
    @{ Nome = "mirassol"; Id = 11126 },
    @{ Nome = "palmeiras"; Id = 3422 },
    @{ Nome = "red-bull-bragantino"; Id = 7808 },
    @{ Nome = "remo"; Id = 11550 },
    @{ Nome = "santos"; Id = 3684 },
    @{ Nome = "sao-paulo"; Id = 3496 },
    @{ Nome = "vasco"; Id = 696 },
    @{ Nome = "vitoria"; Id = 3440 }
)

$ok = 0
foreach ($time in $times) {
    $pastaCdn = $time.Id % 32
    $url = "https://cdn.sportmonks.com/images/soccer/teams/$pastaCdn/$($time.Id).png"
    $arquivo = Join-Path $destino "$($time.Nome).png"

    try {
        Invoke-WebRequest -Uri $url -OutFile $arquivo -UseBasicParsing
        $bytes = (Get-Item $arquivo).Length
        if ($bytes -lt 100) {
            Remove-Item $arquivo -Force -ErrorAction SilentlyContinue
            Write-Warning "Arquivo inválido para $($time.Nome)"
            continue
        }
        Write-Host "OK: $($time.Nome).png ($bytes bytes)"
        $ok++
    } catch {
        Remove-Item $arquivo -Force -ErrorAction SilentlyContinue
        Write-Warning "Falha ao baixar $($time.Nome): $($_.Exception.Message)"
    }
}
Write-Host ""
Write-Host "Concluído: $ok de $($times.Count) escudos salvos em $destino"
if ($ok -ne $times.Count) {
    Write-Warning "Confira os avisos acima antes de recompilar o APK."
}