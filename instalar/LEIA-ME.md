# Kit do Claude Code — como instalar

Tudo o que você pediu fica reunido no marketplace `nivus` (este repositório), mais um plugin oficial da Anthropic.
Instalando uma vez no seu PC, eles valem em **todos os projetos**, inclusive os que você ainda vai criar.

| Plugin | O que traz |
|---|---|
| **nivus-kit** | taste-skill e variações de estilo (minimalista, brutalista, soft, redesign, stitch, image-to-code, imagegen…), biblioteca **DESIGN.md** com 74 marcas, **Web Interface Guidelines** da Vercel (+ revisão automática depois de editar arquivos de interface), **Playwright MCP** (navegador para prints), **graphify** (mapa do código) e o **MCP da Kairogen** (precisa de login: digite `/mcp` no Claude Code, escolha `kairogen` e entre com sua conta) |
| **ponytail** | modo "dev sênior preguiçoso": a solução mais simples que funciona |
| **agent-skills** | processo de engenharia do Addy Osmani: `/spec`, `/plan`, `/build`, `/test`, `/review`, `/webperf`, `/ship` + 4 agentes |
| **cartographer** | mapeia o projeto com vários subagentes e gera `docs/CODEBASE_MAP.md` |
| **mem** (claude-mem) | memória entre sessões: lembra o que foi feito e injeta no começo da próxima |
| **headroom** | compressão de contexto local para gastar menos tokens (precisa ser ativado, seção 8) |
| **claude-code-setup** (oficial) | analisa o projeto e sugere hooks, skills, MCPs e agentes |

> O **OmniRoute** é opcional e instalado à parte — veja a seção 7.

---

## 1. Antes de começar (uma vez só)

Instale, se ainda não tiver:

1. **Claude Code** — https://code.claude.com
2. **Git** — Windows: https://git-scm.com · Mac: já vem (ou `xcode-select --install`)
3. **Node.js** (LTS) — https://nodejs.org — necessário para o Playwright MCP
4. **Python 3.10+** (opcional) — https://python.org — usado pelo graphify. Se não tiver, só o graphify fica de fora.
5. **Login no GitHub** — só é necessário se este repositório for privado. Nesse caso, instale o GitHub CLI
   (https://cli.github.com) e rode `gh auth login`.

## 2. Instalar tudo

Baixe este repositório (ou só a pasta `instalar/`) e rode **um** comando:

**Windows** (PowerShell):
```powershell
git clone https://github.com/fabricioemanoelcorreia-stack/painel-nivus-3d
powershell -ExecutionPolicy Bypass -File painel-nivus-3d\instalar\instalar.ps1
```

**Mac / Linux** (Terminal):
```bash
git clone https://github.com/fabricioemanoelcorreia-stack/painel-nivus-3d
bash painel-nivus-3d/instalar/instalar.sh
```

O script mostra ✓ em cada passo. No fim, **reinicie o Claude Code**.

<details>
<summary>Prefere fazer à mão, dentro do Claude Code?</summary>

```
/plugin marketplace add fabricioemanoelcorreia-stack/painel-nivus-3d
/plugin install nivus-kit@nivus
/plugin install ponytail@nivus
/plugin install agent-skills@nivus
```
Escolha o escopo **user** quando ele perguntar.
</details>

## 3. Conferir

Abra o Claude Code em qualquer pasta e digite `/plugin` — os três devem aparecer como ativos.
Teste rápido: `/web-interface-guidelines`, `/ponytail`, `/spec` e `/graphify .` devem existir.

## 4. Sessões na nuvem (claude.ai/code)

Cada sessão na nuvem começa do zero. Para o kit vir sempre junto:
menu do ambiente (topo da sessão) → **Edit** → **Setup script** → cole o conteúdo de
[`setup-nuvem.sh`](setup-nuvem.sh).

## 5. Atualizar

Rode o mesmo script de novo. Ele atualiza o marketplace e os plugins.
As versões de terceiros (ponytail, agent-skills, graphify, Playwright) ficam **fixadas** em versões revisadas;
para subir de versão, peça ao Claude para revisar a nova e atualizar este repositório.

## 6. Desligar ou remover

- Desligar um plugin: `/plugin` → escolha → disable.
- Desligar o ponytail só na conversa: diga "stop ponytail".
- Remover tudo: `claude plugin uninstall nivus-kit@nivus` (idem para `ponytail` e `agent-skills`)
  e `claude plugin marketplace remove nivus`.

## 7. OmniRoute (opcional)

Rode o instalador com a opção extra:

- Windows: `powershell -ExecutionPolicy Bypass -File painel-nivus-3d\instalar\instalar.ps1 -ComOmniroute`
- Mac/Linux: `bash painel-nivus-3d/instalar/instalar.sh --com-omniroute`

Isso instala o programa `omniroute` (versão 3.8.50) **sem mexer no seu Claude Code normal**: `claude` continua
usando a sua conta da Anthropic. Para usar o OmniRoute:

1. `omniroute setup` — assistente inicial; conecte os provedores e crie a chave dele.
2. `omniroute serve` — deixe rodando (painel em http://localhost:20128).
3. `omniroute run claude` — abre um Claude Code que passa pelo OmniRoute. Só esse terminal usa o roteador.

Antes de usar, saiba:

- **Seu código e conversas vão para os provedores que você conectar.** Conecte só os que você confia, com contas suas.
- **Não conecte sua assinatura do Claude (Pro/Max) a ele.** Usar a assinatura por um proxy de terceiros pode
  violar os termos da Anthropic e bloquear sua conta. Os provedores marcados como "avoid" no painel dele têm o mesmo risco.
- Ele não funciona nas sessões na nuvem (precisa ficar ligado no seu PC).
- Para remover: `npm uninstall -g omniroute`.

## 8. Headroom e claude-mem: o que saber

**Headroom** — o instalador coloca o plugin e o programa `headroom` (0.40.0), mas **não liga** a compressão.
Para ligar: `headroom init -g claude`. Isso faz o Claude Code passar por um proxy **no seu próprio PC**
(porta 8787), que enxuga o contexto antes de enviar para a Anthropic. Se algo der errado com ele, o Claude Code
para de responder: confira com `headroom doctor` e desfaça com `headroom unwrap claude`
(e `claude plugin disable headroom@nivus`). O instalador desliga a telemetria dele (`HEADROOM_BEACON=off`).

**claude-mem** (`mem`) — guarda um resumo do que acontece nas sessões num banco local e usa o próprio Claude para
resumir, então **gasta um pouco da sua cota**. No Windows pode piscar uma janela de console a cada ferramenta
(problema conhecido do projeto). O instalador **desliga a telemetria** dele (`CLAUDE_MEM_TELEMETRY=0`).
A sincronização na nuvem (cmem.ai) só liga se você configurar.

## Problemas comuns

| Mensagem | Solução |
|---|---|
| "Não consegui acessar github.com/…" | Confira a internet; se o repositório for privado, rode `gh auth login` e tente de novo. |
| Playwright não abre o navegador | Instale o Node.js e rode o script de novo. |
| `/graphify` reclama de Python | Instale o Python 3.10+; a skill instala o resto sozinha. |
| `graphify` "não é reconhecido" (Windows) | Rode o instalador de novo: ele adiciona a pasta do graphify ao PATH. Depois abra um terminal novo. |
| Windows bloqueou o script | Use exatamente `powershell -ExecutionPolicy Bypass -File …`. |
