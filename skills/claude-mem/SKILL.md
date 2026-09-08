---
name: claude-mem
description: "Persistent memory system - automatically activates every session. Captures session context, maintains continuity across conversations, tracks what was worked on, and injects relevant history into new sessions."
---

# Claude-Mem: Persistent Session Memory

Automatically maintain continuity across Claude Code sessions. Every session start: read prior context. Every session end: save what was done.

## Auto-Activation (Every Session)

On every session start, do these steps silently without announcing:

1. **Read last context** - check `~/.claude-mem/last-context.md` for prior session state
2. **Read recent sessions** - scan `~/.claude-mem/sessions/` for recent daily logs (last 3 days)
3. **Read memory index** - check `~/.claude/projects/-Users-satishkc/memory/MEMORY.md` for persistent memories
4. **Orient silently** - understand what the user was last working on, what's pending, what context carries forward

Do NOT announce this process. Just be aware of the context. If the user starts a conversation related to prior work, you already know the background.

## Session Context Capture

At the START of meaningful work (not casual questions), silently run:

```bash
~/.claude-mem/capture.sh
```

Then read the generated `~/.claude-mem/last-context.md` to understand current state.

## Session Summary Save

When the user explicitly ends a session or says goodbye, or when significant work is completed, run:

```bash
~/.claude-mem/summarize.sh
```

This appends to the daily session log at `~/.claude-mem/sessions/YYYY-MM-DD.md`.

## What to Track

**Always note silently:**
- Which project/directory is active
- What task was being worked on
- Key decisions made
- Blockers encountered
- Files modified
- What's left to do

**Save to memory (via memory system) when:**
- User shares new project context, preferences, or corrections
- A significant architectural decision is made
- A new workflow or tool is established
- Something surprising or non-obvious is learned

## Context Injection Rules

**DO:**
- Reference prior session context naturally when relevant
- Pick up where the user left off without asking "what were you working on?"
- Connect current work to past context silently

**DON'T:**
- Announce "I'm loading your session history"
- Dump prior context unprompted
- Reference old context that's clearly stale
- Slow down the session with memory operations

## Privacy

Content wrapped in `<private>` tags is never persisted or referenced in future sessions.

## Storage Layout

```
~/.claude-mem/
  last-context.md          # Current session context (auto-generated)
  capture.sh               # Session start script
  summarize.sh             # Session end script
  sessions/
    2026-05-03.md          # Daily session logs
    2026-05-02.md
    ...
```

## Integration with Memory System

Claude-mem handles **short-term session continuity** (what happened today/this week).
The memory system at `~/.claude/projects/-Users-satishkc/memory/` handles **long-term knowledge** (user preferences, project details, feedback).

Both work together: claude-mem provides session context, memory provides project/user context.
