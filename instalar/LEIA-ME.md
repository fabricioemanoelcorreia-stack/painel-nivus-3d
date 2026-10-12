# Kit do Claude Code — como instalar

Tudo o que você pediu fica reunido em **3 plugins** no marketplace `nivus` (este repositório).
Instalando uma vez no seu PC, eles valem em **todos os projetos**, inclusive os que você ainda vai criar.

| Plugin | O que traz |
|---|---|
| **nivus-kit** | taste-skill e variações de estilo (minimalista, brutalista, soft, redesign, stitch, image-to-code, imagegen…), biblioteca **DESIGN.md** com 74 marcas, **Web Interface Guidelines** da Vercel (+ revisão automática depois de editar arquivos de interface), **Playwright MCP** (navegador para prints) e **graphify** (mapa do código) |
| **ponytail** | modo "dev sênior preguiçoso": a solução mais simples que funciona |
| **agent-skills** | processo de engenharia do Addy Osmani: `/spec`, `/plan`, `/build`, `/test`, `/review`, `/webperf`, `/ship` + 4 agentes |

> O **OmniRoute** ficou de fora de propósito: ele desvia seu código para provedores de terceiros e pode violar os termos de uso da sua conta.

---

## 1. Antes de começar (uma vez só)

Instale, se ainda não tiver:

1. **Claude Code** — https://code.claude.com
2. **Git** — Windows: https://git-scm.com · Mac: já vem (ou `xcode-select --install`)
3. **Node.js** (LTS) — https://nodejs.org — necessário para o Playwright MCP
4. **Python 3.10+** (opcional) — https://python.org — usado pelo graphify. Se não tiver, só o graphify fica de fora.
5. **Login no GitHub** — este repositório é privado, então o seu PC precisa ter acesso a ele.
   O jeito mais fácil: instale o GitHub CLI (https://cli.github.com) e rode `gh auth login`.

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

## Problemas comuns

| Mensagem | Solução |
|---|---|
| "Não consegui acessar github.com/…" | Falta login no GitHub: `gh auth login` e rode de novo. |
| Playwright não abre o navegador | Instale o Node.js e rode o script de novo. |
| `/graphify` reclama de Python | Instale o Python 3.10+; a skill instala o resto sozinha. |
| Windows bloqueou o script | Use exatamente `powershell -ExecutionPolicy Bypass -File …`. |
