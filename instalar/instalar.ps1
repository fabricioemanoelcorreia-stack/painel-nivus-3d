# Instala o kit completo do Claude Code no Windows.
# Uso (PowerShell): powershell -ExecutionPolicy Bypass -File instalar\instalar.ps1
# Pode rodar de novo para atualizar. Opcional: -ComOmniroute

param([switch]$ComOmniroute)

$MarketplaceRepo      = "fabricioemanoelcorreia-stack/painel-nivus-3d"
$Plugins              = @("nivus-kit", "ponytail", "agent-skills", "cartographer", "mem", "headroom")
# Programas Python fixados: comando = pacote==versao
$PyTools              = [ordered]@{ "graphify" = "graphifyy==0.9.70"; "headroom" = "headroom-ai==0.40.0" }
$PlaywrightMcpVersion = "0.0.83"
$OmniRouteVersion     = "3.8.50"
$falhas = 0

function Ok($m)   { Write-Host "  [ok] $m" -ForegroundColor Green }
function Warn($m) { Write-Host "  [!]  $m" -ForegroundColor Yellow }
function Step($m) { Write-Host "`n$m" -ForegroundColor White }
function Has($c)  { [bool](Get-Command $c -ErrorAction SilentlyContinue) }
function Run($exe, [string[]]$a) { & $exe @a *> $null; return ($LASTEXITCODE -eq 0) }

Step "1/4 Conferindo pre-requisitos"
if (-not (Has "claude")) {
  Write-Host "  [x] Claude Code nao encontrado. Instale em https://code.claude.com e rode este script de novo." -ForegroundColor Red
  exit 1
}
Ok "Claude Code $(claude --version)"
if (Has "git") { Ok "git" } else { Warn "git nao encontrado (instale o Git for Windows: https://git-scm.com)"; $falhas++ }
if (Has "npx") { Ok "Node.js/npx" } else { Warn "Node.js nao encontrado: o Playwright MCP nao vai funcionar (https://nodejs.org)" }

Step "2/4 Marketplace e plugins"
if ((Run "claude" @("plugin","marketplace","add",$MarketplaceRepo)) -or (Run "claude" @("plugin","marketplace","update","nivus"))) {
  Ok "marketplace nivus"
} else {
  Write-Host "  [x] Nao consegui acessar github.com/$MarketplaceRepo." -ForegroundColor Red
      Write-Host "      Confira a internet. Se o repositorio for privado, faca login no GitHub ('gh auth login') e rode de novo."
  exit 1
}
foreach ($p in $Plugins) {
  if ((Run "claude" @("plugin","install","$p@nivus","--scope","user")) -or (Run "claude" @("plugin","update","$p@nivus","--scope","user"))) {
    Ok $p
  } else { Warn "falhou: $p"; $falhas++ }
}
# Plugin oficial da Anthropic
if (-not (Run "claude" @("plugin","marketplace","add","anthropics/claude-plugins-official"))) { Run "claude" @("plugin","marketplace","update","claude-plugins-official") | Out-Null }
if (Run "claude" @("plugin","install","claude-code-setup@claude-plugins-official","--scope","user")) { Ok "claude-code-setup (oficial)" } else { Warn "falhou: claude-code-setup"; $falhas++ }
# claude-mem envia estatisticas de uso por padrao; desligamos (nao afeta a memoria).
try {
  $cfg = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME ".claude" }
  $sp = Join-Path $cfg "settings.json"
  $s = if (Test-Path $sp) { Get-Content $sp -Raw | ConvertFrom-Json } else { [pscustomobject]@{} }
  if (-not $s.env) { $s | Add-Member -NotePropertyName env -NotePropertyValue ([pscustomobject]@{}) -Force }
  $s.env | Add-Member -NotePropertyName CLAUDE_MEM_TELEMETRY -NotePropertyValue "0" -Force
  $s | ConvertTo-Json -Depth 20 | Set-Content $sp -Encoding UTF8
  Ok "telemetria do claude-mem desligada"
} catch { Warn "nao consegui desligar a telemetria do claude-mem: $_" }

Step "3/4 Programas Python (graphify e headroom)"
foreach ($cmd in $PyTools.Keys) {
  $pkg = $PyTools[$cmd]
  if (Has $cmd) { Ok "$cmd ja instalado"; continue }
  if ((Has "uv") -and (Run "uv" @("tool","install",$pkg))) { Ok "$cmd instalado com uv" }
  elseif ((Has "pipx") -and (Run "pipx" @("install",$pkg))) { Ok "$cmd instalado com pipx" }
  elseif ((Has "py") -and (Run "py" @("-m","pip","install","--user",$pkg))) { Ok "$cmd instalado com pip" }
  elseif ((Has "python") -and (Run "python" @("-m","pip","install","--user",$pkg))) { Ok "$cmd instalado com pip" }
  else { Warn "nao instalei $cmd (precisa de Python 3.10+)"; continue }
  # pip --user instala em uma pasta Scripts que o Windows nao poe no PATH sozinho.
  if (-not (Has $cmd)) {
    foreach ($py in @("py", "python")) {
      if (-not (Has $py)) { continue }
      $dir = & $py -c "import sysconfig; print(sysconfig.get_path('scripts', 'nt_user'))" 2>$null
      if ($dir -and (Test-Path (Join-Path $dir "$cmd.exe"))) {
        $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($userPath -notlike "*$dir*") { [Environment]::SetEnvironmentVariable("Path", "$userPath;$dir", "User") }
        $env:Path += ";$dir"
        Ok "$cmd adicionado ao PATH ($dir)"
        break
      }
    }
  }
}

Step "4/4 Navegador do Playwright MCP"
if ((Has "npx") -and (Run "npx" @("-y","@playwright/mcp@$PlaywrightMcpVersion","install-browser","chromium"))) { Ok "Chromium instalado" }
else { Warn "nao instalei agora; ele e baixado no primeiro uso" }

# Opcional: so com -ComOmniroute. Instala o programa, mas nao muda o Claude Code normal.
if ($ComOmniroute) {
  Step "Extra: OmniRoute"
  if ((Has "npm") -and (Run "npm" @("install","-g","omniroute@$OmniRouteVersion"))) { Ok "OmniRoute $OmniRouteVersion instalado. Proximo passo: rode 'omniroute setup' (veja o LEIA-ME)" }
  else { Warn "falhou: OmniRoute (precisa do Node.js/npm)"; $falhas++ }
}

Write-Host ""
if ($falhas -eq 0) {
  Write-Host "Pronto! Reinicie o Claude Code. Para conferir, digite /plugin dentro dele." -ForegroundColor Green
  Write-Host "Para ativar a compressao do Headroom: headroom init -g claude (veja o LEIA-ME)."
}
else { Write-Host "Terminou com $falhas aviso(s) acima. Corrija e rode o script de novo." -ForegroundColor Yellow }
