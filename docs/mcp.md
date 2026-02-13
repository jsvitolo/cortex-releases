# Cortex MCP Integration

Cortex exposes **102 tools** via [MCP (Model Context Protocol)](https://modelcontextprotocol.io/) for deep integration with Claude Code. This turns your AI assistant into a fully context-aware development partner that can manage tasks, search memories, orchestrate agents, analyze code, and more — all without leaving the conversation.

## Setup

```bash
# Register Cortex as an MCP server in Claude Code
claude mcp add cortex -- cx mcp serve
```

That's it. All 102 tools are now available in your Claude Code sessions.

## How It Works

```
Claude Code ←──JSON-RPC/stdio──→ cx mcp serve ←──→ SQLite + Git + LSP
```

The MCP server runs as a subprocess of Claude Code, communicating via JSON-RPC over stdio. It has full access to your local Cortex database, git repo, and language servers.

---

## Tool Reference

### Task Management (4 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `task_list` | List tasks with optional filters | — |
| `task_get` | Get a task by ID | `id` |
| `task_create` | Create a new task | `title` |
| `task_update` | Update a task | `id` |

**Optional params for `task_list`:** `status`, `level`, `label`, `include_archived`
**Optional params for `task_create`:** `description`, `type`, `level`, `labels`, `story_points`
**Optional params for `task_update`:** `status`, `title`, `description`, `labels`, `story_points`

**Examples:**
```
task_create(title="Add user auth", type="feature")           → CX-42
task_update(id="CX-42", status="progress")                   → Started
task_list(status="progress")                                  → Active tasks
```

---

### Memory (3 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `memory_save` | Save a memory entry | `type`, `title`, `content` |
| `memory_list` | Search/list memories | — |
| `memory_link` | Link memory to a task | `memory_id`, `task_id` |

**Memory types:** `diary`, `decision`, `best_practice`, `note`, `retrospective`

**Examples:**
```
memory_save(type="decision", title="Use JWT", content="Chose JWT over sessions for...")
memory_list(search="authentication")                         → Semantic search
memory_link(memory_id="mem-1", task_id="CX-42", phase="research")
```

---

### Git Automation (3 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `git_branch` | Create branch for a task | `task_id` |
| `git_pr` | Push + create GitHub PR | — |
| `git_merge` | Squash merge PR + cleanup | — |

These tools automate the full git lifecycle tied to task status:

```
git_branch(task_id="CX-42")    → Creates feat/cx-42-add-user-auth
git_pr()                        → Push + PR + task → "review"
git_merge()                     → Squash merge + delete branch + task → "done"
```

---

### Agent Orchestration (9 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `agent_list` | List available agents | — |
| `agent_get` | Get agent details + instructions | `name` |
| `agent_for_task` | Recommended agent for task | `task_id` |
| `agent_spawn` | Create agent session | `task_id` |
| `task_orchestrate` | Generate multi-agent DAG plan | `task_id` |
| `agent_report` | Report agent progress | `session_id` |
| `agent_sessions` | List sessions | — |
| `agent_session_logs` | Get session logs | `session_id` |
| `agent_session_stop` | Stop a session | `session_id` |

**Orchestration creates a DAG workflow:**
```
task_orchestrate(task_id="CX-42")
→ research-explore ──┐
  research-memory  ──┼──→ synth ──→ implement ──→ verify-test   ──┐
  research-impact  ──┘                            verify-lint  ──┼──→ report
                                                  verify-review ──┘
```

---

### LSP - Code Intelligence (12 tools)

#### Analysis (5 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `lsp_symbols` | Get symbols in a file | `file` |
| `lsp_definition` | Go to definition | `file`, `line`, `column` |
| `lsp_references` | Find all references | `file`, `line`, `column` |
| `lsp_hover` | Get type/doc info | `file`, `line`, `column` |
| `lsp_get_symbol_source` | Get symbol source code | `file`, `symbol_name` |

#### Editing (5 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `lsp_replace_symbol` | Replace symbol body | `file`, `symbol_name`, `new_body` |
| `lsp_insert_after_symbol` | Insert code after symbol | `file`, `symbol_name`, `code` |
| `lsp_insert_before_symbol` | Insert code before symbol | `file`, `symbol_name`, `code` |
| `lsp_delete_symbol` | Delete a symbol | `file`, `symbol_name` |
| `lsp_rename_symbol` | Rename across files | `file`, `line`, `column`, `new_name` |

#### Management (2 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `lsp_status` | Active language server status | — |
| `lsp_install` | Install a language server | `language` |

**Supported languages:** Go (gopls), Rust (rust-analyzer), TypeScript, Python, Elixir

---

### Thinking & Reflection (3 tools)

| Tool | Description |
|------|-------------|
| `think_about_collected_information` | Reflect on gathered research before acting |
| `think_about_task_adherence` | Verify changes align with the task |
| `think_about_whether_you_are_done` | Check if task is truly complete |

These tools help AI agents pause and reflect at critical moments, improving output quality.

---

### Planning & Brainstorming (14 tools)

#### Plans (5 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `plan_create` | Create/update execution plan | `task_id`, `content` |
| `plan_get` | Get plan for a task | `task_id` |
| `plan_submit` | Submit plan for approval | `task_id` |
| `plan_approve` | Approve a plan | `task_id` |
| `plan_reject` | Reject a plan with reason | `task_id`, `reason` |

#### Brainstorming (9 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `brainstorm_create` | Start brainstorm session | `title` |
| `brainstorm_get` | Get brainstorm by ID | `id` |
| `brainstorm_list` | List all brainstorms | — |
| `brainstorm_add_idea` | Add an idea | `brainstorm_id`, `content` |
| `brainstorm_vote_idea` | Vote on idea | `idea_id`, `vote` |
| `brainstorm_select_idea` | Select/deselect idea | `idea_id`, `selected` |
| `brainstorm_add_decision` | Record decision | `brainstorm_id`, `content` |
| `brainstorm_add_ref` | Add reference material | `brainstorm_id`, `title` |
| `brainstorm_to_plan` | Convert brainstorm → plan | `brainstorm_id` |
| `brainstorm_archive` | Archive brainstorm | `brainstorm_id` |

---

### High-Level Planning (5 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `highlevel_plan_list` | List all project plans | — |
| `highlevel_plan_get` | Get plan by ID | `id` |
| `highlevel_plan_create` | Create a plan | `title` |
| `highlevel_plan_update` | Update plan | `id` |
| `highlevel_plan_link_epic` | Link epic to plan | `plan_id`, `epic_id` |
| `highlevel_plan_unlink_epic` | Unlink epic from plan | `plan_id`, `epic_id` |

---

### Epics (8 tools)

#### Task Linking (3 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `epic_link_task` | Link task to epic | `epic_id`, `task_id` |
| `epic_unlink_task` | Unlink task from epic | `epic_id`, `task_id` |
| `epic_tasks` | Get all tasks in epic | `epic_id` |

#### Orchestration (5 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `epic_orchestrate` | Generate parallel plan for epic | `epic_id` |
| `epic_task_report` | Report task completion | `epic_dag_plan_id`, `task_id`, `status` |
| `epic_conflicts` | Detect file conflicts between tasks | `epic_id` |
| `workflow_status` | Get workflow status | — |
| `workflow_results` | Aggregate workflow results | `task_id` |

---

### Phases & Definition of Done (10 tools)

#### Phases (6 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `phases_list` | List phases for a task | `task_id` |
| `phase_get` | Get phase content | `task_id`, `phase` |
| `phase_update` | Update phase content | `task_id`, `phase`, `content` |
| `phase_complete` | Mark phase complete | `task_id`, `phase` |
| `phase_next` | Advance to next phase | `task_id` |
| `task_log` | Get event history | `task_id` |

#### Definition of Done (4 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `dod_list` | Get DoD items for task | `task_id` |
| `dod_add` | Add DoD item | `task_id`, `description` |
| `dod_check` | Mark DoD item complete | `item_id`, `completed` |
| `dod_init` | Initialize default DoD | `task_id` |

---

### Verification (1 tool)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `verify_task` | Run build, test, lint, vet checks | `task_id` |

Runs the full verification suite and returns a reward score (0.0 - 1.0).

---

### Learnings (4 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `learnings_list` | List learnings | — |
| `learnings_search` | Search learnings | `query` |
| `learnings_get` | Get learning by ID | `id` |
| `learnings_relevant` | Get relevant learnings for context | — |

**Learning types:** `success_pattern`, `failure_pattern`, `domain_knowledge`, `user_feedback`

---

### Database (5 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `db_list` | List configured databases | — |
| `db_schema` | Get database schema | `db` |
| `db_sample` | Sample rows from a table | `db`, `table` |
| `db_stats` | Table statistics | `db` |
| `db_query` | Execute SELECT query | `db`, `sql` |

Read-only access to external PostgreSQL databases. Configure in `.cortex/databases.yaml`.

---

### Business Rules (8 tools)

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `business_rule_extract` | Extract rules from code | `file` or `directory` |
| `business_rule_save` | Save extracted rule | `title`, `category` |
| `business_rule_list` | List rules | — |
| `business_rule_get` | Get rule by ID | `id` |
| `business_rule_search` | Search rules | `query` |
| `business_rule_relate` | Create rule relationship | `source_rule_id`, `target_rule_id`, `relation_type` |
| `business_rule_relations` | List rule relationships | `rule_id` |
| `business_rule_catalog` | Generate markdown catalog | — |
| `rules_extract` | Orchestrate full extraction | `path` |

---

### Controller (8 tools)

Advanced multi-process agent management:

| Tool | Description | Required Params |
|------|-------------|-----------------|
| `controller_init` | Initialize agent controller | — |
| `controller_spawn` | Spawn Claude agent process | `prompt` |
| `controller_send` | Send message to agent | `agent_id`, `text` |
| `controller_broadcast` | Broadcast to all agents | `text` |
| `controller_status` | Get controller status | — |
| `controller_approve` | Approve/deny tool request | `request_id`, `approved` |
| `controller_kill` | Kill agent process | `agent_id` |
| `controller_shutdown` | Gracefully shutdown | — |

---

## Recommended CLAUDE.md Configuration

Add this to your project's `CLAUDE.md` to make Claude Code always prefer Cortex tools:

```markdown
## Rules

- ALWAYS use Cortex MCP tools (`mcp__cortex__*`) over CLI or Bash for task/memory/git operations
- Create a task before starting any work: `mcp__cortex__task_create`
- Use `mcp__cortex__git_branch`, `git_pr`, `git_merge` for git workflow
- Search memory before asking questions: `mcp__cortex__memory_list`
- Use LSP tools for code analysis: `lsp_symbols`, `lsp_definition`, `lsp_references`
- Use thinking tools at critical moments: `think_about_task_adherence`, `think_about_whether_you_are_done`
```

## Troubleshooting

**Tools not appearing in Claude Code?**
```bash
# Verify MCP server is registered
claude mcp list

# Re-register if needed
claude mcp remove cortex
claude mcp add cortex -- cx mcp serve
```

**Database tools not working?**
- Ensure `.cortex/databases.yaml` exists with valid connection config
- Only SELECT queries are allowed (read-only)

**LSP tools returning errors?**
- The language server starts automatically on first use
- Check status with `lsp_status`
- Install manually with `lsp_install(language="go")`
