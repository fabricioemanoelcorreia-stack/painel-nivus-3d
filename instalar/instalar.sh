#!/usr/bin/env bash
# Instala o kit completo do Claude Code (Mac, Linux ou nuvem).
# Uso: bash instalar/instalar.sh   — pode rodar de novo para atualizar.
set -u

MARKETPLACE_REPO="fabricioemanoelcorreia-stack/painel-nivus-3d"
PLUGINS=(nivus-kit ponytail agent-skills)
GRAPHIFY_VERSION="0.9.70"
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

step "3/4 graphify (programa usado pela skill /graphify)"
if command -v graphify >/dev/null 2>&1; then
  ok "já instalado"
elif command -v uv >/dev/null 2>&1 && uv tool install "graphifyy==$GRAPHIFY_VERSION" >/dev/null 2>&1; then
  ok "instalado com uv"
elif command -v pipx >/dev/null 2>&1 && pipx install "graphifyy==$GRAPHIFY_VERSION" >/dev/null 2>&1; then
  ok "instalado com pipx"
elif command -v python3 >/dev/null 2>&1 && python3 -m pip install --user "graphifyy==$GRAPHIFY_VERSION" >/dev/null 2>&1; then
  ok "instalado com pip"
else
  warn "não instalei agora; a skill instala sozinha no primeiro uso (precisa de Python 3.10+)"
fi

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
else
  echo "Terminou com $falhas aviso(s) acima. Corrija e rode o script de novo."
fi
