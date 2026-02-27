<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="assets/logo.svg">
    <img alt="Cortex" src="assets/logo.svg" width="500">
  </picture>
  <br />
  <p align="center">
    <strong>Your development brain — powered by Claude Code.</strong>
    <br />
    Task management, semantic memory, agent workflows, and git automation — all from your terminal.
  </p>
  <p align="center">
    <a href="https://github.com/jsvitolo/cortex-releases/releases/latest"><img src="https://img.shields.io/github/v/release/jsvitolo/cortex-releases?style=flat-square&color=blue" alt="Latest Release"></a>
    <a href="https://github.com/jsvitolo/cortex-releases/releases/latest"><img src="https://img.shields.io/github/downloads/jsvitolo/cortex-releases/total?style=flat-square&color=green" alt="Downloads"></a>
    <a href="#install"><img src="https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey?style=flat-square" alt="Platform"></a>
  </p>
  <p align="center">
    English · <a href="README.pt-BR.md">Português (Brasil)</a>
  </p>
</p>

---

## How It Works

Cortex is designed to work **alongside Claude Code**, not as a standalone CLI you type into.

Once initialized, **Claude Code becomes your interface** — it uses Cortex's 65+ MCP tools to manage tasks, search memory, run agent workflows, and navigate code. You rarely need to type `cx` commands yourself.

```
You → Claude Code → Cortex MCP → Tasks, Memory, Agents, LSP
                              ↓
                           cx ui  (to visualize everything)
```

**The only `cx` commands you'll use directly:**
- `cx init` — set up Cortex in your project (once)
- `cx ui` — open the visual dashboard (whenever you want to see what's going on)

Everything else happens automatically through Claude Code.

---

## Install

**macOS / Linux (Homebrew):**

```bash
brew tap jsvitolo/tap
brew install cx
```

**macOS / Linux (script):**

```bash
curl -sSL https://raw.githubusercontent.com/jsvitolo/cortex-releases/main/install.sh | bash
```

**Manual download:**

Download the latest binary from the [Releases](https://github.com/jsvitolo/cortex-releases/releases/latest) page.

---

## Setup

### 1. Set your OpenAI API key

Cortex uses OpenAI embeddings for semantic memory search:

```bash
export OPENAI_API_KEY=sk-...
# Add to your ~/.zshrc or ~/.bashrc to persist
```

> Without the key, Cortex works fully for task management, git automation, and TUI — only semantic memory requires it.

### 2. Initialize in your project

```bash
cd your-project
cx init
```

This sets up `.cortex/` (local data), registers the MCP server with Claude Code, and installs the Claude Code plugin (skills + hooks).

### 3. Install the Claude Code plugin

The plugin adds workflow automation hooks and skill shortcuts (`/implement`, `/brainstorm`, `/merge`, `/pr`) to every Claude Code session in this project.

```bash
# Install from the Claude Code marketplace
claude plugin install cortex

# Or manually register the MCP server
claude mcp add cortex -- cx mcp serve
```

> `cx init` already handles MCP registration. The plugin install adds the full skills and hooks experience on top.

### 4. Open the dashboard

```bash
cx ui
```

Now open Claude Code in your project and start working — Cortex tracks tasks and memories automatically.

---

## What Claude Code Can Do With Cortex

Once set up, just talk to Claude Code naturally:

| You say... | Claude Code does... |
|------------|---------------------|
| "Let's implement the auth feature" | Creates a task, runs 3-agent workflow |
| "I'm not sure how to approach this" | Starts a brainstorm session |
| "What did we decide about the DB schema?" | Searches semantic memory |
| "Open a PR for this" | Pushes, creates PR, moves task to review |
| "Merge and release" | Squash merges, tags, triggers CI release |

### Skills (slash commands in Claude Code)

| Skill | What it does |
|-------|--------------|
| `/implement CX-N` | Runs the 3-agent workflow (research → implement → verify) |
| `/brainstorm "idea"` | Starts an interactive brainstorm session |
| `/plan "title"` | Creates or edits a high-level plan |
| `/start CX-N` | Creates branch, enters worktree, moves task to progress |
| `/pr` | Pushes branch, creates PR, moves task to review |
| `/merge` | Squash merges PR, deletes branch, moves task to done |

---

## Visual Dashboard (`cx ui`)

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
│  a: add  e: edit  ↑↓: navigate  ←→: move  /: search  q: quit          │
└───────────────────────────────────────────────────────────────────────┘
```

| View | Key | Description |
|------|-----|-------------|
| Dashboard | (home) | Overview: stats, recent tasks, shortcuts |
| Kanban | `k` | Task board with columns |
| Table | `t` | Sortable task list |
| Plans | `p` | High-level plans with inline comments |
| Brainstorm | `b` | Idea sessions with voting |
| Memory | `m` | Browse semantic memories |
| Worktrees | `w` | Active git worktrees |
| Agents | `g` | Agent session monitoring |
| Settings | `s` | Sound notifications + agent model selection |

---

## Features

- **Task Management** — Epics and tasks with full lifecycle tracking
- **Brainstorm Mode** — Explore ideas with voting, pros/cons, and decisions before committing
- **Plans** — High-level planning with markdown editing and inline comments
- **Semantic Memory** — Capture learnings with hybrid search (FTS5 + HNSW vectors)
- **Agent Workflow** — 3-agent autonomous workflow (research → implement → verify)
- **Agent Model Selection** — Choose which Claude model to use per agent (default, research, implement, verify) from the Settings TUI
- **Sound Notifications** — Warcraft peon voice pack plays on task/agent events, configurable per event type and volume
- **65+ MCP Tools** — Deep Claude Code integration
- **LSP Integration** — Code analysis with Go, Rust, TypeScript support
- **Git-Backed Sync** — All data syncs via git for collaboration and backup

---

## Requirements

- **Claude Code** — the primary interface
- **OpenAI API key** — for semantic memory (`OPENAI_API_KEY`)
- **GitHub CLI** (optional) — for PR/merge automation (`gh auth login`)

---

## Tech Stack

- **TUI**: [Charm](https://charm.sh/) (Bubble Tea, Lip Gloss, Glamour)
- **Storage**: SQLite + FTS5 + HNSW (vector search)
- **Embeddings**: OpenAI `text-embedding-3-small`
- **Integration**: MCP Server for Claude Code

---

## License

MIT

---

<p align="center">
  Built with <a href="https://go.dev">Go</a>, <a href="https://github.com/charmbracelet/bubbletea">Bubble Tea</a>, and <a href="https://www.anthropic.com/claude">Claude</a>.
</p>
