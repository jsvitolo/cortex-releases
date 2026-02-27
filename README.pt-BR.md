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

### 1. Configure sua chave da OpenAI

O Cortex usa embeddings da OpenAI para busca semântica na memória:

```bash
export OPENAI_API_KEY=sk-...
# Adicione ao ~/.zshrc ou ~/.bashrc para persistir
```

> Sem a chave, o Cortex funciona normalmente para gerenciamento de tarefas, automação git e TUI — apenas a busca semântica precisa dela.

### 2. Inicialize no seu projeto

```bash
cd seu-projeto
cx init
```

Isso cria o `.cortex/` (dados locais), registra o servidor MCP no Claude Code e instala o plugin do Claude Code (skills + hooks).

### 3. Instale o plugin do Claude Code

O plugin adiciona hooks de automação e atalhos de skills (`/implement`, `/brainstorm`, `/merge`, `/pr`) a todas as sessões do Claude Code nesse projeto.

```bash
# Instalar pelo marketplace do Claude Code
claude plugin install cortex

# Ou registrar manualmente o servidor MCP
claude mcp add cortex -- cx mcp serve
```

> O `cx init` já cuida do registro do MCP. O plugin adiciona a experiência completa de skills e hooks por cima.

### 4. Abra o dashboard

```bash
cx ui
```

Agora abra o Claude Code no seu projeto e comece a trabalhar — o Cortex rastreia tarefas e memórias automaticamente.

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

| Skill | O que faz |
|-------|-----------|
| `/implement CX-N` | Executa o workflow de 3 agentes (pesquisa → implementação → verificação) |
| `/brainstorm "ideia"` | Inicia uma sessão interativa de brainstorm |
| `/plan "título"` | Cria ou edita um plano de alto nível |
| `/start CX-N` | Cria branch, entra no worktree, move tarefa para progress |
| `/pr` | Faz push do branch, cria PR, move tarefa para review |
| `/merge` | Squash merge do PR, deleta branch, move tarefa para done |

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
