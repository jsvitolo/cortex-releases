<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="assets/logo.svg">
    <img alt="Cortex" src="assets/logo.svg" width="500">
  </picture>
  <br />
  <p align="center">
    <strong>Your AI-powered development cockpit.</strong>
    <br />
    Task management, semantic memory, agent orchestration, and git automation — all from your terminal.
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

## What is Cortex?

Cortex (`cx`) is a terminal-first development platform that brings together everything you need to stay in flow:

- **Task Management** — Kanban board, priorities, dependencies, and full lifecycle tracking
- **Semantic Memory** — Remember decisions, patterns, and context across sessions using hybrid search (FTS5 + HNSW vectors)
- **Agent Orchestration** — Multi-agent workflows (research → implement → verify) powered by Claude Code
- **Git Automation** — Branches, PRs, and merges tied to tasks — zero context switching
- **TUI Dashboard** — Beautiful terminal UI with Kanban, memory browser, agent monitor, and more
- **MCP Integration** — [102 tools](docs/mcp.md) for Claude Code, making AI-assisted development seamless

## Quick Start

### Install

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

### Setup

```bash
# Initialize Cortex in your project
cx init

# Create your first task
cx add "Setup authentication" --type feature

# Open the TUI
cx ui
```

### Dependencies

Cortex requires a few tools to unlock its full potential:

**macOS:**

```bash
# Required: Git (usually pre-installed)
xcode-select --install

# Required: OpenAI API key (for semantic memory)
export OPENAI_API_KEY=sk-...       # Add to your ~/.zshrc or ~/.bashrc

# Optional: Claude Code (for agent orchestration)
npm install -g @anthropic-ai/claude-code

# Optional: GitHub CLI (for PR/merge automation)
brew install gh
gh auth login
```

**Linux (Debian/Ubuntu):**

```bash
# Required: Git
sudo apt-get install -y git

# Required: OpenAI API key (for semantic memory)
export OPENAI_API_KEY=sk-...       # Add to your ~/.bashrc

# Optional: Claude Code (for agent orchestration)
npm install -g @anthropic-ai/claude-code

# Optional: GitHub CLI (for PR/merge automation)
sudo apt-get install -y gh
gh auth login
```

**Linux (Fedora/RHEL):**

```bash
# Required: Git
sudo dnf install -y git

# Required: OpenAI API key (for semantic memory)
export OPENAI_API_KEY=sk-...       # Add to your ~/.bashrc

# Optional: Claude Code (for agent orchestration)
npm install -g @anthropic-ai/claude-code

# Optional: GitHub CLI (for PR/merge automation)
sudo dnf install -y gh
gh auth login
```

> **Note:** Without the OpenAI API key, Cortex works fully for task management, git automation, and TUI — only semantic memory search requires embeddings.

## Features

### Task Management

Track your work with a full-featured task system inspired by [beads](https://github.com/steveyegge/beads).

```bash
cx add "Implement user auth" --type feature    # Create task → CX-1
cx start CX-1                                   # Move to in progress + create branch
cx done CX-1                                    # Complete + cleanup
```

Tasks have status (`backlog` → `progress` → `review` → `done`), types, priorities, design docs, acceptance criteria, and dependencies.

### Terminal UI

A beautiful, keyboard-driven interface built with [Bubble Tea](https://github.com/charmbracelet/bubbletea).

```
┌─ Cortex ──────────────────────────────────────────────────────────────┐
│                                                                       │
│  Backlog        In Progress     Review          Done                  │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐          │
│  │ CX-3      │  │ CX-1      │  │ CX-4      │  │ CX-2      │          │
│  │ Add API   │  │ Auth      │  │ Tests     │  │ Setup DB  │          │
│  │ feature   │  │ feature   │  │ chore     │  │ chore     │          │
│  └───────────┘  └───────────┘  └───────────┘  └───────────┘          │
│  ┌───────────┐                                ┌───────────┐          │
│  │ CX-5      │                                │ CX-6      │          │
│  │ Dark mode │                                │ CI/CD     │          │
│  │ feature   │                                │ chore     │          │
│  └───────────┘                                └───────────┘          │
│                                                                       │
├───────────────────────────────────────────────────────────────────────┤
│  a: add  e: edit  ↑↓: navigate  ←→: move  /: search  q: quit        │
└───────────────────────────────────────────────────────────────────────┘
```

Views: **Kanban Board** · **Task Detail** · **Memory Browser** · **Agent Dashboard** · **Agent Monitor**

### Semantic Memory

Never lose context again. Cortex stores decisions, session diaries, best practices, and learnings with semantic search.

```bash
cx memory diary "Implemented OAuth2 with PKCE flow"     # Save context
cx memory search "authentication approach"               # Semantic search
cx memory reflect                                        # Analyze patterns
cx memory rules                                          # Generate rules from patterns
```

**How it works:**
- Texts are embedded using OpenAI `text-embedding-3-small`
- Stored locally in SQLite with HNSW vector index (O(log n) search)
- Hybrid search combines FTS5 keyword matching (40%) + HNSW vector similarity (60%)
- Everything stays local — your data never leaves your machine

### Agent Orchestration

Cortex orchestrates multi-agent workflows for coding tasks. Each task goes through three phases:

```
┌──────────┐     ┌───────────┐     ┌────────┐
│ Research  │ ──▶ │ Implement │ ──▶ │ Verify │ ──▶ done
└──────────┘     └───────────┘     └────────┘
     │                │                 │
     ▼                ▼                 ▼
  Understand       Write code       Run tests
  codebase         following        lint, review
  + plan           the plan         + report
```

**Parallel execution** with DAG workflows:

```
research-explore ──┐                              verify-test   ──┐
research-memory  ──┼──▶ synth ──▶ implement ──▶   verify-lint  ──┼──▶ report
research-impact  ──┘                              verify-review ──┘
```

11 specialized agents, configurable approval rules, real-time TUI monitoring.

### Git Automation

Cortex ties your git workflow directly to tasks:

```bash
cx start CX-1      # Creates branch feat/cx-1-description
                    # Creates git worktree in .worktrees/cx-1/

# ... work on the task ...

cx pr CX-1          # Push + create PR + move task to "review"
cx merge CX-1       # Squash merge + delete branch + move task to "done"
```

**Git worktrees** let you work on multiple tasks simultaneously, each in its own directory with its own branch.

### Claude Code Integration (MCP)

Cortex exposes **102 tools** via [MCP (Model Context Protocol)](https://modelcontextprotocol.io/) for deep integration with Claude Code:

```bash
# Register Cortex as an MCP server
claude mcp add cortex -- cx mcp serve
```

| Category | Examples | Count |
|----------|----------|-------|
| Task Management | `task_create`, `task_list`, `task_update` | 4 |
| Memory | `memory_save`, `memory_list`, `memory_link` | 3 |
| Git Automation | `git_branch`, `git_pr`, `git_merge` | 3 |
| Agent Orchestration | `agent_spawn`, `task_orchestrate`, `agent_report` | 9 |
| LSP Code Intelligence | `lsp_symbols`, `lsp_definition`, `lsp_references` | 12 |
| Planning & Brainstorm | `plan_create`, `brainstorm_create`, `brainstorm_to_plan` | 14 |
| Business Rules | `business_rule_extract`, `rules_extract` | 8 |
| Database (PostgreSQL) | `db_query`, `db_schema`, `db_sample` | 5 |
| Epics & Workflows | `epic_orchestrate`, `workflow_status` | 8 |
| Verification & Learnings | `verify_task`, `learnings_relevant` | 5 |
| And more... | Phases, DoD, Controller, Thinking tools | 31 |

> **[View full MCP documentation (102 tools) →](docs/mcp.md)**
>
> **[Getting started with Claude Code + Cortex →](docs/claude-code.md)**

### Learnings System

Cortex learns from your work and improves over time:

```
Task completed → Verification → Pattern extraction → Stored as learning
                                                           ↓
Next similar task ← Agents apply learned patterns ← Retrieved by relevance
```

Types: `success_pattern` · `failure_pattern` · `domain_knowledge` · `user_feedback`

## Architecture

```
Go 1.24+
├── SQLite + HNSW + FTS5 (local storage + search)
├── Bubble Tea + Lip Gloss (terminal UI)
├── MCP Server (Claude Code integration)
├── OpenAI Embeddings (text-embedding-3-small)
└── Git Worktrees (parallel task isolation)
```

Everything runs locally. No cloud services required (except OpenAI for embeddings).

## CLI Reference

```
cx init                  Initialize Cortex in current directory
cx status                Project overview

cx add "title"           Create a task
cx ls                    List tasks
cx show CX-1             Show task details
cx start CX-1            Start working (branch + worktree)
cx done CX-1             Complete task

cx memory search "q"     Semantic memory search
cx memory diary "..."    Save session context
cx memory reflect        Analyze patterns

cx agent ps              List running agents
cx agent logs <id> -f    Follow agent logs

cx ui                    Open terminal UI
cx mcp serve             Start MCP server
```

## License

MIT

---

<p align="center">
  Built with <a href="https://go.dev">Go</a>, <a href="https://github.com/charmbracelet/bubbletea">Bubble Tea</a>, and <a href="https://www.anthropic.com/claude">Claude</a>.
</p>
