#!/usr/bin/env bash
# Instala o kit completo do Claude Code (Mac, Linux ou nuvem).
# Uso: bash instalar/instalar.sh   — pode rodar de novo para atualizar.
set -u

MARKETPLACE_REPO="fabricioemanoelcorreia-stack/painel-nivus-3d"
PLUGINS=(nivus-kit ponytail agent-skills cartographer mem headroom)
# Programas Python fixados: comando=pacote==versão
PY_TOOLS=("graphify=graphifyy==0.9.70" "headroom=headroom-ai==0.40.0")
PLAYWRIGHT_MCP_VERSION="0.0.83"
OMNIROUTE_VERSION="3.8.50"
COM_OMNIROUTE=0; [ "${1:-}" = "--com-omniroute" ] && COM_OMNIROUTE=1

ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$1"; }
step() { printf '\n\033[1m%s\033[0m\n' "$1"; }
falhas=0

step "1/4 Conferindo pré-requisitos"
if ! command -v claude >/dev/null 2>&1; then
  echo "  ✗ Claude Code não encontrado. Instale em https://code.claude.com e rode este script de novo."
  exit 1
fi
ok "Claude Code $(claude --version 2>/dev/null | head -1)"
command -v git >/dev/null 2>&1 && ok "git" || { warn "git não encontrado (necessário para baixar os plugins)"; falhas=$((falhas+1)); }
command -v npx >/dev/null 2>&1 && ok "Node.js/npx" || warn "Node.js não encontrado: o Playwright MCP não vai funcionar (instale em https://nodejs.org)"

step "2/4 Marketplace e plugins"
if claude plugin marketplace add "$MARKETPLACE_REPO" >/dev/null 2>&1 || claude plugin marketplace update nivus >/dev/null 2>&1; then
  ok "marketplace nivus"
else
  echo "  ✗ Não consegui acessar github.com/$MARKETPLACE_REPO."
  echo "    Confira a internet. Se o repositório for privado, faça login no GitHub ('gh auth login') e rode de novo."
  exit 1
fi
for p in "${PLUGINS[@]}"; do
  if claude plugin install "$p@nivus" --scope user >/dev/null 2>&1 || claude plugin update "$p@nivus" --scope user >/dev/null 2>&1; then
    ok "$p"
  else
    warn "falhou: $p"; falhas=$((falhas+1))
  fi
done
# Plugin oficial da Anthropic
claude plugin marketplace add anthropics/claude-plugins-official >/dev/null 2>&1 || claude plugin marketplace update claude-plugins-official >/dev/null 2>&1
if claude plugin install claude-code-setup@claude-plugins-official --scope user >/dev/null 2>&1; then ok "claude-code-setup (oficial)"; else warn "falhou: claude-code-setup"; falhas=$((falhas+1)); fi
# claude-mem envia estatísticas de uso por padrão; desligamos (não afeta a memória).
command -v node >/dev/null 2>&1 && node -e '
const fs=require("fs"),p=require("path").join(process.env.CLAUDE_CONFIG_DIR||require("os").homedir()+"/.claude","settings.json");
let s={};try{s=JSON.parse(fs.readFileSync(p,"utf8"))}catch{}
s.env={...(s.env||{}),CLAUDE_MEM_TELEMETRY:"0"};fs.writeFileSync(p,JSON.stringify(s,null,2));' && ok "telemetria do claude-mem desligada"

step "3/4 Programas Python (graphify e headroom)"
for t in "${PY_TOOLS[@]}"; do
  cmd=${t%%=*}; pkg=${t#*=}
  if command -v "$cmd" >/dev/null 2>&1; then ok "$cmd já instalado"
  elif command -v uv >/dev/null 2>&1 && uv tool install "$pkg" >/dev/null 2>&1; then ok "$cmd instalado com uv"
  elif command -v pipx >/dev/null 2>&1 && pipx install "$pkg" >/dev/null 2>&1; then ok "$cmd instalado com pipx"
  elif command -v python3 >/dev/null 2>&1 && python3 -m pip install --user "$pkg" >/dev/null 2>&1; then ok "$cmd instalado com pip"
  else warn "não instalei $cmd (precisa de Python 3.10+)"; fi
done

step "4/4 Navegador do Playwright MCP"
if [ -x /opt/pw-browsers/chromium ]; then
  ok "usando o Chromium já existente (nuvem)"
elif command -v npx >/dev/null 2>&1 && npx -y "@playwright/mcp@$PLAYWRIGHT_MCP_VERSION" install-browser chromium >/dev/null 2>&1; then
  ok "Chromium instalado"
else
  warn "não instalei agora; ele é baixado no primeiro uso"
fi

# Opcional: só com --com-omniroute. Instala o programa, mas não muda o Claude Code normal.
if [ "$COM_OMNIROUTE" -eq 1 ]; then
  step "Extra: OmniRoute"
  if command -v npm >/dev/null 2>&1 && npm install -g "omniroute@$OMNIROUTE_VERSION" >/dev/null 2>&1; then
    ok "OmniRoute $OMNIROUTE_VERSION instalado. Próximo passo: rode 'omniroute setup' (veja o LEIA-ME)"
  else
    warn "falhou: OmniRoute (precisa do Node.js/npm; no Mac/Linux pode exigir permissão para 'npm install -g')"; falhas=$((falhas+1))
  fi
fi

echo
if [ "$falhas" -eq 0 ]; then
  echo "Pronto! Reinicie o Claude Code. Para conferir, digite /plugin dentro dele."
  echo "Para ativar a compressão do Headroom: headroom init -g claude (veja o LEIA-ME)."
else
  echo "Terminou com $falhas aviso(s) acima. Corrija e rode o script de novo."
fi
