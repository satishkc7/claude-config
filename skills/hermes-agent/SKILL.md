---
name: hermes-agent
description: "Use when building, configuring, or deploying self-improving AI agents. Covers Hermes Agent setup, multi-platform gateway (Telegram/Discord/Slack/WhatsApp/20+), skill creation, cron scheduling, memory systems, subagent delegation, and 200+ model switching."
---

# Hermes Agent - Self-Improving AI Agent Framework

By Nous Research. The only agent with a built-in learning loop - creates skills from experience, improves them over time, searches past conversations, builds user models, and runs across 20+ messaging platforms.

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
source ~/.bashrc
hermes
```

## Core Commands

```bash
hermes                    # Interactive chat (TUI)
hermes setup              # Interactive configuration wizard
hermes model              # Change model/provider
hermes tools              # Configure tools per platform
hermes config set KEY VAL # Set individual config values
hermes gateway start      # Start messaging gateway
hermes gateway stop       # Stop gateway
hermes cron list          # List scheduled jobs
hermes doctor             # Diagnostics and health check
hermes update             # Self-update
hermes debug share        # Upload debug logs (redacted)
```

## Architecture

```
Provider Resolution -> Prompt Construction -> API Call -> Tool Execution Loop -> Session Persistence
```

**Prompt Construction layers:**
1. Agent identity (SOUL.md - customizable)
2. User memories (local MEMORY.md or Honcho AI)
3. Loaded skills (progressive disclosure index)
4. Context files (.hermes.md, AGENTS.md)
5. Platform hints and ephemeral context

**API Modes:**
- `chat_completions` - OpenAI-wire compatible (OpenRouter, Nous Portal, most aggregators)
- `codex_responses` - OpenAI Codex/ChatGPT OAuth format
- `anthropic_messages` - Native Anthropic Claude API

## Model Support (200+)

Switch models with zero code changes:
- OpenRouter (aggregator - access to most models)
- Anthropic Claude (Opus, Sonnet, Haiku)
- OpenAI (GPT-4o, o1, o3)
- Google Gemini
- Nous Portal
- NVIDIA NIM
- Hugging Face
- Xiaomi MiMo
- Any OpenAI-compatible endpoint

```bash
hermes model  # Interactive model picker
```

## 61 Built-in Tools

| Category | Tools |
|----------|-------|
| Terminal | Execute shell, manage processes, 7 backends (local/Docker/SSH/Daytona/Modal/Singularity/Vercel) |
| File Ops | Read, write, patch, search files |
| Browser | Navigate, interact, screenshot, take notes (CDP support) |
| Code Exec | Sandboxed Python/bash execution |
| Web | Search (Exa, Google), extract (Firecrawl) |
| Vision | Image analysis (Claude, GPT-4V, Gemini) |
| Skills | List, view, create, manage, hub integration |
| Memory | Load memories, search sessions (FTS5) |
| Messaging | Send cross-platform messages |
| Media | TTS, STT, image generation, video analysis |
| Database | Kanban tasks, cron jobs |
| Integration | MCP client, delegate subagents |
| Security | Approval system for dangerous commands |

## Multi-Platform Gateway (20+)

Single gateway serves all platforms simultaneously:

| Platform | Features |
|----------|----------|
| Telegram | Rich media, threads, reactions, stickers |
| Discord | Threads, reactions, embeds, slash commands |
| Slack | Threads, reactions, blocks |
| WhatsApp | Media, groups |
| Signal | Secure messaging |
| Email | IMAP/SMTP |
| Matrix/Element | E2E encryption, rooms |
| Mattermost | Threads, channels |
| Feishu/Lark | Cards, groups |
| DingTalk | Groups, cards |
| WeChat Work | Enterprise messaging |
| WeChat | Public accounts |
| SMS | Twilio integration |
| REST API | Custom integrations |
| Webhook | Generic HTTP |

```bash
hermes gateway start              # Start all configured platforms
hermes gateway start --telegram   # Start specific platform
hermes gateway stop               # Stop gateway
```

## Self-Improvement Loop (Curator System)

The curator automatically manages the skill lifecycle:

1. **Auto-Creation** - After complex multi-step tasks, extracts reusable procedures into skills
2. **Self-Improvement** - During use, refines skill content via `skill_manage` tool
3. **Lifecycle Management:**
   - Active -> Stale (default 30 days inactive) -> Archived (default 90 days)
   - Users can **pin** skills to bypass auto-archiving
   - Archived skills are recoverable

```bash
hermes config set curator.enabled true
hermes config set curator.interval_hours 168  # Weekly review
```

## Skill System

**Directory Structure:**
```
~/.hermes/skills/
  category/
    skill-name/
      SKILL.md        # Main instructions (YAML frontmatter + markdown)
      references/     # Supporting docs (loaded on-demand)
      templates/      # Output templates
```

**SKILL.md Format:**
```yaml
---
name: skill-name
description: Brief description
version: 1.0.0
platforms: [macos, linux]
prerequisites:
  env_vars: [API_KEY]
  commands: [curl, jq]
metadata:
  hermes:
    tags: [llm, fine-tuning]
    related_skills: [lora, peft]
---

# Skill Instructions

Step-by-step procedures...
```

**Progressive Disclosure:**
- Tier 1: Metadata only (name, description) - listed in skills index
- Tier 2: Full SKILL.md instructions - loaded when skill invoked
- Tier 3: Reference files - loaded on-demand within skill

**27 Bundled Categories:** apple, autonomous-ai-agents, creative, data-science, devops, github, productivity, research, software-development, and 18+ more

## Memory System

### Local Memory (Default)
- `MEMORY.md` - agent-curated notes and preferences
- `USER.md` - user profile data
- Session search via SQLite FTS5 + LLM summarization

### Honcho AI (Optional)
- Dialectic user modeling - running conversation between user and AI peer
- Cross-session continuity with periodic nudges
- Deep user understanding that improves over time

```bash
hermes config set memory.provider honcho
hermes config set memory.honcho.app_id YOUR_APP_ID
```

## Cron Scheduling

Schedule recurring tasks with natural language + platform delivery:

```bash
hermes cron add "daily-standup" "0 9 * * *" "Generate daily standup report" --platform telegram --chat-id 12345
hermes cron list
hermes cron enable daily-standup
hermes cron disable daily-standup
hermes cron remove daily-standup
```

**Features:**
- Standard 5-field cron expressions
- Platform delivery (any gateway platform)
- Per-job tool/skill configuration
- Failure tracking and retry
- File-based locking (no concurrent execution)

## Subagent Delegation

Spawn child agents with isolated context for parallel work:

```
Main Agent
  ├── Subagent 1 (research task)
  ├── Subagent 2 (code review)
  └── Subagent 3 (testing)
```

- Fresh context per subagent (no pollution)
- RPC tool calls between agents
- Configurable model per subagent
- Results aggregated back to parent

## Context Compression

When history exceeds token budget:
1. Keep recent messages verbatim (50% of context window)
2. Compress older messages with auxiliary model (summarize, preserve key facts)
3. Inject compressed summary as context pseudo-message
4. Repeat if still over budget

## Security & Approval

Dangerous commands require user approval:
- `rm -rf`, `sudo`, `curl | bash`, `eval` - CRITICAL
- `/etc/passwd`, `~/.ssh` access - HIGH
- Configurable patterns and thresholds
- Per-tool approval rules

## Configuration

```bash
hermes setup                          # Full interactive wizard
hermes config set model.provider openrouter
hermes config set model.name anthropic/claude-sonnet-4-6
hermes config set terminal.backend docker
hermes config set gateway.telegram.token BOT_TOKEN
```

**Config files:**
- `~/.hermes/config.yaml` - all settings
- `~/.hermes/.env` - API keys and secrets
- `~/.hermes/active_profile` - current profile (multi-profile support)

## MCP Integration

Hermes can act as both MCP client and server:

**As client** - connect to any MCP server for extended tools
**As server** - expose Hermes tools to other MCP clients

```bash
hermes mcp add server-name          # Add MCP server
hermes mcp list                     # List configured servers
hermes mcp serve                    # Start as MCP server
```

## Terminal Backends

| Backend | Use Case |
|---------|----------|
| Local | Default - direct subprocess |
| Docker | Sandboxed container execution |
| SSH | Remote machine access |
| Daytona | Serverless persistent workspace |
| Modal | Serverless ephemeral functions |
| Singularity | HPC/scientific computing |
| Vercel | Serverless edge |

```bash
hermes config set terminal.backend docker
hermes config set terminal.docker.image python:3.11
```

## Key Integrations

- **Skills Hub** - community skill marketplace
- **OpenClaw** - migration from predecessor
- **Atropos** - RL training environments
- **Kanban** - built-in task management
- **Browser** - full CDP automation with screenshots
