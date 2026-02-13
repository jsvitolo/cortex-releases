# Using Cortex with Claude Code

This guide shows how to use Cortex + Claude Code together for a complete AI-assisted development workflow — from brainstorming ideas to shipping code.

## Setup

```bash
# 1. Install Cortex
brew tap jsvitolo/tap && brew install cx

# 2. Install Claude Code
npm install -g @anthropic-ai/claude-code

# 3. Initialize Cortex in your project
cd your-project
cx init

# 4. Register Cortex as MCP server
claude mcp add cortex -- cx mcp serve

# 5. Start Claude Code
claude
```

That's it. Claude Code now has access to all 102 Cortex tools.

---

## The Development Workflow

Cortex provides a structured workflow that adapts to the complexity of your task:

```
┌──────────────────────────────────────────────────────────┐
│                   Is the solution clear?                  │
└───────────────────────┬──────────────────────────────────┘
                   Yes  │  No
                   ┌────┘  └────┐
                   ▼            ▼
            ┌───────────┐  ┌──────────────┐
            │ Is it     │  │ /brainstorm  │
            │ complex?  │  │ Explore ideas│
            └─────┬─────┘  └──────┬───────┘
             No   │   Yes         │
             ┌────┘   └────┐      ▼
             ▼             ▼   Decide approach
      ┌───────────┐  ┌─────────┐  │
      │ Just do it│  │ /plan   │  ▼
      │ cx add +  │  │ Design  │ /plan or
      │ implement │  │ first   │ brainstorm_to_plan
      └───────────┘  └────┬────┘  │
                          │       │
                          ▼       ▼
                    ┌──────────────────┐
                    │ /implement CX-N  │
                    │ 3-agent workflow  │
                    └──────────────────┘
```

---

## 1. Brainstorming

Use `/brainstorm` when you don't know the best approach yet. It's a structured way to explore ideas before committing to code.

### Starting a Brainstorm

In Claude Code, just type:

```
/brainstorm "Real-time notifications system"
```

This creates a brainstorm session and Claude will help you explore options.

### Adding Ideas

Claude will suggest ideas, but you can also ask for specific approaches:

```
You: "What about using WebSockets vs Server-Sent Events vs polling?"
```

Claude adds each as a separate idea with pros and cons:

```
Idea 1: WebSockets
  Pros: Bidirectional, low latency, wide support
  Cons: Complex server setup, connection management

Idea 2: Server-Sent Events (SSE)
  Pros: Simple, HTTP-based, auto-reconnect
  Cons: Unidirectional, limited browser connections

Idea 3: Long Polling
  Pros: Works everywhere, simple to implement
  Cons: Higher latency, more server resources
```

### Making Decisions

Tell Claude your preference:

```
You: "Let's go with SSE for simplicity. We only need server-to-client."
```

Claude records the decision with rationale and can convert the brainstorm into an actionable plan.

### Converting to Plan

```
You: "Convert this brainstorm to a plan"
```

This creates a structured plan with tasks ready for implementation.

### Brainstorm Commands Reference

| What you say | What happens |
|---|---|
| `/brainstorm "topic"` | Creates a new brainstorm session |
| "Add an idea about X" | Adds idea with optional pros/cons |
| "I prefer idea 2" | Votes and selects the idea |
| "Let's decide on X because Y" | Records decision with rationale |
| "Add this article as reference: URL" | Adds reference material |
| "Convert to plan" | Creates plan from brainstorm decisions |

---

## 2. Planning

Use `/plan` when you know the approach but need to document it before coding. Plans serve as a contract between you and the AI agents.

### Creating a Plan

```
You: /plan "Implement SSE notification system"
```

Claude will research your codebase and write a detailed plan including:
- Architecture decisions
- Files to create/modify
- Implementation steps
- Edge cases to handle

### Reviewing and Approving

Claude submits the plan for your approval. You can:

```
You: "The plan looks good, but let's also add rate limiting"
You: "Approve the plan"
```

Once approved, the plan becomes the blueprint for implementation.

---

## 3. Implementation

Use `/implement` to kick off the 3-agent workflow. This is where the magic happens.

### Starting Implementation

```
You: /implement CX-42
```

Or create a task and implement in one step:

```
You: /implement "Add SSE notification system"
```

### The 3-Agent Workflow

Cortex automatically orchestrates three specialized agents:

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  Agent 1: Research                                               │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ • Explores codebase structure with LSP tools               │  │
│  │ • Searches memories for relevant past decisions            │  │
│  │ • Analyzes impact of changes on existing code              │  │
│  │ • Creates a detailed implementation plan                   │  │
│  └────────────────────────────────────────────────────────────┘  │
│                          │                                       │
│                          ▼                                       │
│  Agent 2: Implement                                              │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ • Follows the research plan step by step                   │  │
│  │ • Writes code, creates files, modifies existing code       │  │
│  │ • Applies learnings from previous successful patterns      │  │
│  │ • Commits changes with proper task references              │  │
│  └────────────────────────────────────────────────────────────┘  │
│                          │                                       │
│                          ▼                                       │
│  Agent 3: Verify                                                 │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ • Runs build, tests, linter, vet                           │  │
│  │ • Reviews code changes against the plan                    │  │
│  │ • Generates verification report with reward score          │  │
│  │ • Extracts learnings for future tasks                      │  │
│  └────────────────────────────────────────────────────────────┘  │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

You can monitor progress in real-time through the TUI:

```bash
cx ui   # Navigate to Agent Dashboard
```

### After Implementation

Once the agents finish, you have verified, tested code. Then:

```
You: "Create a PR"       →  /pr   (pushes + creates PR + task → review)
You: "Merge it"          →  /merge (squash merge + task → done)
```

---

## 4. Git Workflow

The entire git lifecycle is automated and tied to tasks:

```
┌─────────┐   cx start    ┌──────────┐   /pr      ┌────────┐   /merge   ┌──────┐
│ Backlog │ ────────────▶  │ Progress │ ────────▶  │ Review │ ────────▶ │ Done │
└─────────┘                └──────────┘            └────────┘           └──────┘
                           Creates branch          Pushes code          Squash merges
                           + worktree              Creates PR           Deletes branch
                                                                        Cleans up
```

### Working on Multiple Tasks

Git worktrees let you work on multiple tasks simultaneously:

```
You: "Start CX-42"    →  Creates .worktrees/cx-42/ with its own branch
You: "Start CX-43"    →  Creates .worktrees/cx-43/ with its own branch
```

Each task is completely isolated — different branch, different directory.

---

## 5. Memory

Cortex remembers context across sessions so you never repeat yourself.

### Automatic Memory

The agents automatically save relevant context during workflows:
- Research findings
- Architecture decisions
- Implementation patterns
- Verification results

### Manual Memory

Save important context yourself:

```
You: "Remember that we chose JWT over sessions for auth"
You: "Save a diary of what we did today"
```

### Memory Search

Claude automatically searches memory before asking you questions:

```
You: "How did we implement auth?"
Claude: [searches memory] "Based on our previous decisions, we used JWT with..."
```

---

## Complete Example: Feature from Scratch

Here's a full example of building a feature from brainstorm to merge:

```
# 1. Brainstorm (5 min)
You: /brainstorm "User notification preferences"
You: "We could store in DB, config file, or env vars"
You: "Let's go with DB, it's per-user"

# 2. Plan (2 min)
You: "Convert to plan"
You: "Approve the plan"

# 3. Implement (autonomous)
You: /implement CX-42
# ... agents work autonomously ...
# Research → Implement → Verify

# 4. Review & Ship (1 min)
You: /pr
You: /merge

# 5. Done!
# Task tracked, code verified, PR merged, learnings saved
```

---

## Tips

### Let the agents work
After `/implement`, the agents are autonomous. You don't need to intervene unless they ask.

### Use brainstorm for uncertainty
If you find yourself debating between approaches, `/brainstorm` is faster than going back and forth.

### Trust the memory
Cortex remembers past decisions. Ask "what did we decide about X?" instead of re-explaining context.

### Monitor via TUI
`cx ui` gives you a real-time view of agent progress, task status, and memory.

### Start small
You don't need to use every feature. Start with tasks + implement, then add brainstorm and memory as you get comfortable.
