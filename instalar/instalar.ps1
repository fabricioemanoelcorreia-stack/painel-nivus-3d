# Instala o kit completo do Claude Code no Windows.
# Uso (PowerShell): powershell -ExecutionPolicy Bypass -File instalar\instalar.ps1
# Pode rodar de novo para atualizar.

$MarketplaceRepo      = "fabricioemanoelcorreia-stack/painel-nivus-3d"
$Plugins              = @("nivus-kit", "ponytail", "agent-skills")
$GraphifyVersion      = "0.9.70"
$PlaywrightMcpVersion = "0.0.83"
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
  Write-Host "      O repositorio e privado: faca login no GitHub neste PC (ex.: 'gh auth login') e rode de novo."
  exit 1
}
foreach ($p in $Plugins) {
  if ((Run "claude" @("plugin","install","$p@nivus","--scope","user")) -or (Run "claude" @("plugin","update","$p@nivus","--scope","user"))) {
    Ok $p
  } else { Warn "falhou: $p"; $falhas++ }
}

Step "3/4 graphify (programa usado pela skill /graphify)"
if (Has "graphify") { Ok "ja instalado" }
elseif ((Has "uv") -and (Run "uv" @("tool","install","graphifyy==$GraphifyVersion"))) { Ok "instalado com uv" }
elseif ((Has "pipx") -and (Run "pipx" @("install","graphifyy==$GraphifyVersion"))) { Ok "instalado com pipx" }
elseif ((Has "py") -and (Run "py" @("-m","pip","install","--user","graphifyy==$GraphifyVersion"))) { Ok "instalado com pip" }
elseif ((Has "python") -and (Run "python" @("-m","pip","install","--user","graphifyy==$GraphifyVersion"))) { Ok "instalado com pip" }
else { Warn "nao instalei agora; a skill instala sozinha no primeiro uso (precisa de Python 3.10+)" }

Step "4/4 Navegador do Playwright MCP"
if ((Has "npx") -and (Run "npx" @("-y","@playwright/mcp@$PlaywrightMcpVersion","install-browser","chromium"))) { Ok "Chromium instalado" }
else { Warn "nao instalei agora; ele e baixado no primeiro uso" }

Write-Host ""
if ($falhas -eq 0) { Write-Host "Pronto! Reinicie o Claude Code. Para conferir, digite /plugin dentro dele." -ForegroundColor Green }
else { Write-Host "Terminou com $falhas aviso(s) acima. Corrija e rode o script de novo." -ForegroundColor Yellow }
