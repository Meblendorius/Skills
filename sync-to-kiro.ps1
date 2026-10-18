# Liga o conteúdo de ~/.agents ao Kiro global (~/.kiro).
# - Skills: junction (atalho de pasta, não precisa de admin). Editou em .agents, o Kiro já vê.
# - Steering e agente: hardlink (mesmo arquivo nos dois lugares, não precisa de admin).
# Uso:  powershell -ExecutionPolicy Bypass -File "$HOME\.agents\sync-to-kiro.ps1"
# Se preferir cópia simples em vez de link: adicione -Copy

param([switch]$Copy)

$src  = Join-Path $HOME ".agents"
$kiro = Join-Path $HOME ".kiro"

$skills = @("code-walkthrough", "decision-rationale", "airflow-dag-review", "spark-dataflow-review", "pipeline-code-review")
$files  = @(
    @{ From = "steering\code-documentation-standards.md"; To = "steering\code-documentation-standards.md" },
    @{ From = "agents\code-explainer.md";                 To = "agents\code-explainer.md" }
)

foreach ($d in @("skills", "steering", "agents")) {
    New-Item -ItemType Directory -Force -Path (Join-Path $kiro $d) | Out-Null
}

foreach ($s in $skills) {
    $target = Join-Path $src  "skills\$s"
    $link   = Join-Path $kiro "skills\$s"
    if (Test-Path $link) { Write-Host "Já existe, pulando: $link"; continue }
    if ($Copy) { Copy-Item -Recurse $target $link }
    else       { New-Item -ItemType Junction -Path $link -Target $target | Out-Null }
    Write-Host "OK skill: $s"
}

foreach ($f in $files) {
    $target = Join-Path $src  $f.From
    $link   = Join-Path $kiro $f.To
    if (Test-Path $link) { Write-Host "Já existe, pulando: $link"; continue }
    if ($Copy) { Copy-Item $target $link }
    else       { New-Item -ItemType HardLink -Path $link -Target $target | Out-Null }
    Write-Host "OK arquivo: $($f.To)"
}

Write-Host "`nPronto. Reinicie o Kiro e digite / no chat para ver as skills."
