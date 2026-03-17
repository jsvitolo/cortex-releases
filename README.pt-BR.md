<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="assets/logo.svg">
    <img alt="Cortex" src="assets/logo.svg" width="500">
  </picture>
  <br />
  <p align="center">
    <strong>Seu cérebro de desenvolvimento — com Claude Code.</strong>
    <br />
    Gerenciamento de tarefas, memória semântica, workflows de agentes e automação git — tudo pelo terminal.
  </p>
  <p align="center">
    <a href="https://github.com/jsvitolo/cortex-releases/releases/latest"><img src="https://img.shields.io/github/v/release/jsvitolo/cortex-releases?style=flat-square&color=blue" alt="Último Release"></a>
    <a href="https://github.com/jsvitolo/cortex-releases/releases/latest"><img src="https://img.shields.io/github/downloads/jsvitolo/cortex-releases/total?style=flat-square&color=green" alt="Downloads"></a>
    <a href="#instalar"><img src="https://img.shields.io/badge/plataforma-macOS%20%7C%20Linux-lightgrey?style=flat-square" alt="Plataforma"></a>
  </p>
  <p align="center">
    <a href="README.md">English</a> · Português (Brasil)
  </p>
</p>

---

## Como Funciona

O Cortex foi feito para funcionar **junto com o Claude Code**, não como uma CLI que você fica digitando comandos.

Depois de inicializado, **o Claude Code vira sua interface** — ele usa as 65+ ferramentas MCP do Cortex para gerenciar tarefas, buscar memórias, executar workflows de agentes e navegar pelo código. Você raramente precisa digitar comandos `cx` diretamente.

```
Você → Claude Code → Cortex MCP → Tarefas, Memória, Agentes, LSP
                              ↓
                           cx ui  (para visualizar tudo)
```

**Os únicos comandos `cx` que você vai usar diretamente:**
- `cx init` — configura o Cortex no seu projeto (uma vez)
- `cx ui` — abre o dashboard visual (quando quiser ver o que está acontecendo)

Todo o resto acontece automaticamente pelo Claude Code.

---

## Instalar

**macOS / Linux (Homebrew):**

```bash
brew tap jsvitolo/tap
brew install cx
```

**macOS / Linux (script):**

```bash
curl -sSL https://raw.githubusercontent.com/jsvitolo/cortex-releases/main/install.sh | bash
```

**Download manual:**

Baixe o binário mais recente na página de [Releases](https://github.com/jsvitolo/cortex-releases/releases/latest).

---

## Configuração

### 1. Configure sua chave da OpenAI (opcional)

```bash
export OPENAI_API_KEY=sk-...
# Adicione ao ~/.zshrc ou ~/.bashrc para persistir
```

A chave desbloqueia a **memória semântica** — embeddings que permitem buscar memórias por significado, não só por palavras-chave. Sem ela, o Cortex continua totalmente funcional:

| Funcionalidade | Sem chave | Com chave |
|----------------|-----------|-----------|
| Tarefas, git, TUI, agentes | ✅ | ✅ |
| Busca de memória | ✅ por palavras (FTS5) | ✅ semântica (vetores HNSW) |
| Salvar memória | ✅ | ✅ + indexada automaticamente |
| `cx kb index --summarize` | ❌ | ✅ |
| Extração de learnings | ❌ | ✅ |

### 2. Inicialize no seu projeto

```bash
cd seu-projeto
cx init
```

Isso cria o `.cortex/` (dados locais), registra o servidor MCP no Claude Code e instala o plugin do Claude Code (skills + hooks).

### 3. Instale o plugin do Claude Code

O plugin adiciona hooks de automação e atalhos de skills (`/implement`, `/brainstorm`, `/merge`, `/pr`) a todas as sessões do Claude Code nesse projeto.

**Dentro de uma sessão do Claude Code**, execute:

```
/plugin marketplace add jsvitolo/cortex-plugins
/plugin install cortex@cortex-plugins
```

**Alternativa** — edite `~/.claude/settings.json` diretamente (sem precisar de uma sessão Claude Code):

```json
{
  "extraKnownMarketplaces": {
    "cortex-plugins": {
      "source": { "source": "github", "repo": "jsvitolo/cortex-plugins" }
    }
  },
  "enabledPlugins": {
    "cortex@cortex-plugins": true
  }
}
```

> O `cx init` já cuida do registro do MCP. O plugin adiciona a experiência completa de skills e hooks por cima.

### 4. Abra o dashboard

```bash
cx ui
```

Agora abra o Claude Code no seu projeto e comece a trabalhar — o Cortex rastreia tarefas e memórias automaticamente.

---

## Integração com CLAUDE.md

Ao rodar `cx init`, o Cortex adiciona automaticamente a seguinte seção de regras no `CLAUDE.md` do seu projeto. É isso que faz o Claude Code usar as ferramentas do Cortex de forma correta e consistente.

Você também pode adicionar manualmente copiando o bloco abaixo:

<details>
<summary><strong>Ver seção de regras do CLAUDE.md</strong></summary>

```markdown
---

## ⚠️ REGRAS OBRIGATÓRIAS - Cortex (DEVE SEGUIR)

Estas regras são **absolutas** e devem ser seguidas em TODAS as interações.

---

### 0. 🔴 PRIORIDADE MÁXIMA: SEMPRE usar as ferramentas MCP do Cortex

**Esta é a regra mais importante.** SEMPRE prefira `mcp__cortex__*` ao invés de CLI ou Bash:

| Operação | Ferramenta MCP ✅ | Não usar ❌ |
|----------|-----------------|------------|
| Criar tarefa | `mcp__cortex__task(action="create")` | ~~cx add~~ |
| Ver tarefa | `mcp__cortex__task(action="get")` | ~~cx show~~ |
| Listar tarefas | `mcp__cortex__task(action="list")` | ~~cx ls~~ |
| Atualizar tarefa | `mcp__cortex__task(action="update")` | ~~cx mv~~ |
| Status do projeto | `mcp__cortex__status()` | ~~cx status~~ |
| Salvar memória | `mcp__cortex__memory(action="save")` | ~~cx memory diary~~ |
| Buscar memória | `mcp__cortex__memory(action="list")` | ~~cx memory search~~ |
| Criar branch | `mcp__cortex__git(action="branch")` | ~~git checkout -b~~ |
| Criar PR | `mcp__cortex__git(action="pr")` | ~~gh pr create~~ |
| Fazer merge | `mcp__cortex__git(action="merge")` | ~~gh pr merge~~ |
| Símbolos no código | `mcp__cortex__lsp(action="symbols")` | ~~Glob/Grep~~ |
| Ir para definição | `mcp__cortex__lsp(action="definition")` | ~~Grep~~ |
| Encontrar referências | `mcp__cortex__lsp(action="references")` | ~~Grep~~ |
| Planos | `mcp__cortex__highlevel_plan()` | ~~nada~~ |
| Brainstorm | `mcp__cortex__brainstorm()` | ~~nada~~ |

**Exceções legítimas (use as ferramentas nativas do Claude Code):**
- `Read` → ler conteúdo de arquivos
- `Edit`/`Write` → editar/criar arquivos
- `Glob` → busca de arquivos por padrão
- `Bash` → comandos do sistema (make, go install, etc.)

---

### 1. 🚀 No Início de QUALQUER Sessão de Trabalho

**OBRIGATÓRIO** — verifique o estado atual antes de qualquer coisa:

```
# 1. Visão geral do projeto
mcp__cortex__status()

# 2. Planos rascunho aguardando aprovação?
mcp__cortex__highlevel_plan(action="list")

# 3. Tarefas travadas em progresso (sem atividade)?
mcp__cortex__task(action="list", status="progress")

# 4. Tarefas em revisão aguardando merge?
mcp__cortex__task(action="list", status="review")
```

Se houver planos **rascunho** → pergunte ao usuário se quer revisá-los antes de criar novas tarefas.
Se houver tarefas **em progresso** → pergunte se quer continuar ou se foram abandonadas.
Se houver tarefas **em revisão** → pergunte se quer fazer merge antes de começar novo trabalho.

---

### 2. 📋 Gerenciamento de Tarefas — SEMPRE via MCP

```
# CRIAR tarefa antes de qualquer trabalho
mcp__cortex__task(action="create", title="Título", type="feature|bug|chore")

# INICIAR tarefa antes de implementar
mcp__cortex__task(action="update", id="CX-N", status="progress")

# FINALIZAR tarefa quando concluída
mcp__cortex__task(action="update", id="CX-N", status="done")
```

**NUNCA** trabalhe sem uma tarefa Cortex associada.

---

### 3. 🧠 Workflow de Desenvolvimento — Escolha o modo certo

Antes de implementar, avalie e escolha:

```
A solução está clara?
├── Não → /brainstorm "título"   (explore ideias, vote, decida)
│              ↓
│         /plan "título"          (documente o design)
│              ↓
│         crie tarefa + /implement
│
└── Sim → É complexo?
          ├── Sim → /plan "título"  (documente a abordagem)
          │              ↓
          │         crie tarefa + /implement
          │
          └── Não → crie tarefa + /implement  (direto)
```

#### Quando usar `/brainstorm`:
- Nova feature **sem design claro**
- **Múltiplas abordagens** possíveis
- Precisa **explorar trade-offs** antes de decidir

#### Quando usar `/plan`:
- Design **já definido**, precisa de documentação
- **Feature complexa** que precisa de spec antes do código

#### Quando ir direto para tarefa + `/implement`:
- Bug fix com **causa conhecida**
- **Feature pequena** com escopo claro
- Seguindo um **plano já aprovado**

---

### 4. 🤖 Workflow de Agentes — USE `/implement` para código

**REGRA:** Para QUALQUER implementação de código, use o skill `/implement`:

```bash
/implement CX-N              # Executa workflow para tarefa existente
/implement "Adicionar feature" # Cria tarefa e executa workflow
```

O workflow de 3 agentes (research → implement → verify) é **OBRIGATÓRIO** para:
- Novas features / bug fixes / refatorações / adição de testes

**NÃO USE** para: pequenas correções, atualizações de docs, perguntas sobre código.

---

### 5. 🔀 Workflow Git — SEMPRE via MCP

```
# Criar branch para a tarefa
mcp__cortex__git(action="branch", task_id="CX-N")

# Push + criar PR + mover tarefa para review
mcp__cortex__git(action="pr")
# ou: /pr

# Squash merge + deletar branch + mover tarefa para done
mcp__cortex__git(action="merge")
# ou: /merge
```

Conventional Commits — formato obrigatório:
`feat(scope): descrição (CX-N)` | `fix` | `chore` | `refactor` | `docs`

---

### 6. 💾 Memória — Busque ANTES de perguntar

```
# SEMPRE busque contexto antes de fazer perguntas ao usuário
mcp__cortex__memory(action="list", search="termo relevante")

# Ao final de uma sessão significativa
mcp__cortex__memory(action="save", type="diary", title="Sessão ...", content="...")
```

---

### 7. 🔍 LSP — Análise de código via Cortex MCP

```
mcp__cortex__lsp(action="symbols", file="caminho/para/arquivo.go")
mcp__cortex__lsp(action="definition", file="...", line=10, column=5)
mcp__cortex__lsp(action="references", file="...", line=10, column=5)
mcp__cortex__lsp(action="hover", file="...", line=10, column=5)
```

Linguagens suportadas: Go, Rust, TypeScript, Python, Elixir

---

## Referência Rápida do Cortex

### Ferramentas MCP

| Ferramenta | Ação |
|-----------|------|
| `mcp__cortex__status()` | Visão geral do projeto |
| `mcp__cortex__task(action="create", title="...")` | Criar tarefa |
| `mcp__cortex__task(action="list")` | Listar tarefas |
| `mcp__cortex__task(action="update", id="CX-N", status="progress")` | Atualizar status |
| `mcp__cortex__memory(action="list", search="q")` | Buscar memórias |
| `mcp__cortex__memory(action="save", type="diary", ...)` | Salvar memória |
| `mcp__cortex__git(action="pr")` | Criar PR |
| `mcp__cortex__git(action="merge")` | Fazer merge do PR |
| `mcp__cortex__highlevel_plan(action="list")` | Listar planos |

### Skills (Claude Code)

| Skill | Finalidade |
|-------|-----------|
| `/cortex:implement CX-N` | Executar workflow de 3 agentes (pesquisa → implementação → verificação) |
| `/cortex:brainstorm "título"` | Explorar ideias antes de commitar |
| `/cortex:plan "título"` | Documentar abordagem/design |
| `/cortex:start CX-N` | Criar branch, entrar no worktree, mover para progress |
| `/cortex:pr` | Criar PR + mover tarefa para review |
| `/cortex:merge` | Fazer merge + mover tarefa para done |
| `/cortex:review` | Code review educativo com quiz |
| `/cortex:session-end` | Salvar contexto e aprendizados antes de encerrar |
| `/cortex:onboard` | Analisar projeto, salvar contexto como memórias |
| `/cortex:bootstrap` | Indexar arquivos fonte na Knowledge Base |
| `/cortex:memory-system` | Salvar aprendizados, buscar contexto, gerar regras |
| `/cortex:rules` | Extrair regras de negócio do código-fonte |
| `/cortex:sync` | Sincronizar progresso da tarefa com Issue do GitHub |
```

</details>

> `cx init` adiciona isso automaticamente. Só copie manualmente se estiver adicionando o Cortex a um projeto já inicializado.

---

## O que o Claude Code faz com o Cortex

Depois de configurado, é só conversar com o Claude Code normalmente:

| Você fala... | Claude Code faz... |
|--------------|---------------------|
| "Vamos implementar a feature de auth" | Cria uma tarefa, executa o workflow de 3 agentes |
| "Não tenho certeza de como abordar isso" | Inicia uma sessão de brainstorm |
| "O que decidimos sobre o schema do banco?" | Busca na memória semântica |
| "Abre um PR pra isso" | Faz push, cria PR, move tarefa para review |
| "Faz o merge e a release" | Squash merge, cria tag, dispara release no CI |

### Skills (slash commands no Claude Code)

Skills disponíveis como `/cortex:<nome>` quando instaladas via plugin, ou `/<nome>` localmente.

| Skill | O que faz |
|-------|-----------|
| `/cortex:implement CX-N` | Executa o workflow de 3 agentes (pesquisa → implementação → verificação) |
| `/cortex:brainstorm "ideia"` | Inicia uma sessão interativa de brainstorm para explorar ideias antes de commitar |
| `/cortex:plan "título"` | Cria ou edita um plano de alto nível para documentar abordagem e design |
| `/cortex:start CX-N` | Cria branch, entra no worktree, move tarefa para progress |
| `/cortex:pr` | Faz push do branch, cria PR, move tarefa para review |
| `/cortex:merge` | Squash merge do PR, deleta branch, move tarefa para done |
| `/cortex:review` | Code review educativo — explica as mudanças e faz perguntas para garantir entendimento |
| `/cortex:session-end` | Captura aprendizados da sessão como memórias antes de encerrar |
| `/cortex:onboard` | Analisa o projeto e salva contexto abrangente como memórias |
| `/cortex:bootstrap` | Indexa profundamente todos os arquivos fonte na Knowledge Base |
| `/cortex:memory-system` | Salva aprendizados, busca contexto passado, gera regras |
| `/cortex:rules` | Wizard interativo para extrair regras de negócio do código-fonte |
| `/cortex:sync` | Sincroniza progresso da tarefa com a Issue do GitHub vinculada |

### Exemplo: Da ideia ao shipped

Sem saber como abordar algo? Comece pelo `/brainstorm`:

```
Você:          /brainstorm "Adicionar notificações em tempo real"

Claude Code:   → Cria sessão de brainstorm BS-1
               → Você adiciona ideias: WebSockets, SSE, polling
               → Vota na melhor abordagem
               → Decide: SSE (mais simples, sem deps extras)
               → /plan → documenta o design
               → Cria tarefa CX-42

Você:          /implement CX-42

Claude Code:   → agente research: lê o código, consulta memória
               → agente implement: escreve seguindo o plano
               → agente verify: roda testes, revisa mudanças
               → Tarefa vai para review automaticamente

Você:          /pr    →  /merge    →  pronto ✓
```

---

## Dashboard Visual (`cx ui`)

```
┌─ Cortex ──────────────────────────────────────────────────────────────┐
│                                                                       │
│  Backlog        In Progress     Review          Done                  │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐           │
│  │ CX-3      │  │ CX-1      │  │ CX-4      │  │ CX-2      │           │
│  │ Add API   │  │ Auth      │  │ Tests     │  │ Setup DB  │           │
│  │ feature   │  │ feature   │  │ chore     │  │ chore     │           │
│  └───────────┘  └───────────┘  └───────────┘  └───────────┘           │
│  ┌───────────┐                                ┌───────────┐           │
│  │ CX-5      │                                │ CX-6      │           │
│  │ Dark mode │                                │ CI/CD     │           │
│  │ feature   │                                │ chore     │           │
│  └───────────┘                                └───────────┘           │
│                                                                       │
├───────────────────────────────────────────────────────────────────────┤
│  a: add  e: edit  ↑↓: navegar  ←→: mover  /: buscar  q: sair          │
└───────────────────────────────────────────────────────────────────────┘
```

| Visão | Tecla | Descrição |
|-------|-------|-----------|
| Dashboard | (início) | Visão geral: stats, tarefas recentes, atalhos |
| Kanban | `k` | Board de tarefas com colunas |
| Tabela | `t` | Lista ordenável de tarefas |
| Planos | `p` | Planos de alto nível com comentários inline |
| Brainstorm | `b` | Sessões de ideias com votação |
| Memória | `m` | Browser de memórias semânticas |
| Worktrees | `w` | Git worktrees ativos |
| Agentes | `g` | Monitoramento de sessões de agentes |
| Configurações | `s` | Notificações sonoras + seleção de modelo por agente |

---

## Funcionalidades

- **Gerenciamento de Tarefas** — Epics e tarefas com rastreamento completo do ciclo de vida
- **Brainstorm** — Explore ideias com votação, prós/contras e decisões antes de implementar
- **Planos** — Planejamento de alto nível com markdown e comentários inline
- **Memória Semântica** — Capture aprendizados com busca híbrida (FTS5 + vetores HNSW)
- **Workflow de Agentes** — Workflow autônomo de 3 agentes (pesquisa → implementação → verificação)
- **65+ Ferramentas MCP** — Integração profunda com Claude Code
- **Integração LSP** — Análise de código com suporte a Go, Rust, TypeScript
- **Sync via Git** — Todos os dados sincronizam via git para colaboração e backup

---

## Requisitos

- **Claude Code** — a interface principal
- **Chave OpenAI** — para memória semântica (`OPENAI_API_KEY`)
- **GitHub CLI** (opcional) — para automação de PR/merge (`gh auth login`)

---

## Stack

- **TUI**: [Charm](https://charm.sh/) (Bubble Tea, Lip Gloss, Glamour)
- **Armazenamento**: SQLite + FTS5 + HNSW (busca vetorial)
- **Embeddings**: OpenAI `text-embedding-3-small`
- **Integração**: Servidor MCP para Claude Code

---

## Licença

MIT

---

<p align="center">
  Feito com <a href="https://go.dev">Go</a>, <a href="https://github.com/charmbracelet/bubbletea">Bubble Tea</a> e <a href="https://www.anthropic.com/claude">Claude</a>.
</p>
