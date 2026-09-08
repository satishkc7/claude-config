---
name: graphify
description: "Use when exploring, mapping, or understanding a codebase structure. Turns any folder of code, docs, PDFs, images, or videos into a queryable knowledge graph with interactive visualization, community detection, and relationship analysis."
---

# Graphify - Codebase Knowledge Graph Builder

Turn any project folder into a queryable knowledge graph. Maps code, docs, PDFs, images, and videos into an interactive visualization with clusters, god nodes, and semantic relationships.

## Installation

```bash
uv tool install graphifyy && graphify install
# or: pipx install graphifyy && graphify install
# or: pip install graphifyy && graphify install
```

Platform-specific:
```bash
graphify install                    # Claude Code (Linux/Mac)
graphify install --platform windows # Claude Code (Windows)
graphify install --platform codex   # Codex
graphify install --platform copilot # GitHub Copilot CLI
graphify install --platform opencode # OpenCode
```

## Core Commands

```bash
/graphify .                          # Build full graph from current directory
/graphify . --update                 # Re-extract only changed files
/graphify . --cluster-only           # Rerun clustering without re-extraction
/graphify . --no-viz                 # Skip HTML, just report + JSON
/graphify . --wiki                   # Build a markdown wiki (Obsidian vault)
/graphify query "what connects auth to database?"  # Semantic query
/graphify path "UserService" "DatabasePool"        # Shortest path between nodes
/graphify explain "RateLimiter"                    # Explain a specific node
/graphify add <paper-url>            # Fetch and index external papers/URLs
```

## Three-Pass Pipeline

```
detect() -> extract() -> build_graph() -> cluster() -> analyze() -> report() -> export()
```

### Pass 1: Code Structure (Free, Local)
- Tree-sitter AST parsing on **25 languages** (Python, TypeScript, Go, Rust, Java, C++, Ruby, Swift, Kotlin, Scala, PHP, Lua, Zig, PowerShell, Elixir, Objective-C, Julia, SQL, R, Dart, and more)
- Extracts: classes, functions, imports, call graphs, inline comments
- No API calls, deterministic, runs locally
- Confidence: `EXTRACTED` (1.0)

### Pass 2: Video & Audio (Local, No API)
- `faster-whisper` transcribes locally
- Seeded with top "god nodes" from Pass 1 to focus on your domain
- Cached - re-runs skip already-processed files

### Pass 3: Docs, Papers, Images (Claude API, Costs Tokens)
- Parallel Claude subagents extract semantic relationships
- Each subagent outputs JSON: nodes, edges, group relationships
- Fragments merged into final graph

## Outputs

| File | Purpose |
|------|---------|
| `graphify-out/graph.html` | Interactive D3.js visualization - click nodes, filter by community/type, search |
| `graphify-out/GRAPH_REPORT.md` | God nodes, surprising connections, knowledge gaps, suggested questions |
| `graphify-out/graph.json` | Full graph in NetworkX node-link format for programmatic queries |

## Graph Report Sections

1. **Corpus check** - files, words, whether graph adds value
2. **Summary** - nodes, edges, communities, confidence breakdown
3. **God nodes** - top 10 most-connected entities (excludes file-level hubs)
4. **Surprising connections** - cross-community or cross-language edges ranked by unexpectedness
5. **Hyperedges** - group relationships (3+ nodes)
6. **Community hubs** - navigation links to community detail files
7. **Ambiguous edges** - flagged for manual review
8. **Knowledge gaps** - isolated nodes, thin communities, high ambiguity
9. **Suggested questions** - 4-5 questions the graph can answer

## Confidence Tagging

Every edge is tagged:
- **EXTRACTED** - explicit in source (import, call, citation) - confidence 1.0
- **INFERRED** - reasonable deduction (co-occurrence, naming) - 0.55-0.95
- **AMBIGUOUS** - uncertain, flagged for manual review

## Community Detection

- Uses **Leiden algorithm** (graspologic) if installed, falls back to Louvain
- Oversized communities (>25% of graph, min 10 nodes) auto-split
- Two-pass cohesion re-clustering for low-cohesion communities

## Key Features

- **SHA256 caching** - only reprocesses changed files
- **Git hooks** - auto-rebuild on commit (AST only, no API cost): `graphify claude install`
- **`.graphifyignore`** - gitignore-style file exclusion with `!` negation support
- **MCP server** - exposes `query_graph`, `get_node`, `get_neighbors`, `shortest_path` tools
- **Obsidian vault export** - `--wiki` flag generates community markdown files with wiki linking
- **Parallel extraction** - ProcessPoolExecutor for code; parallel Claude subagents for docs
- **Privacy-first** - code processed locally via tree-sitter; only docs/PDFs use Claude API
- **Sensitivity detection** - auto-skips `.env`, `.pem`, credentials, secrets

## Graph JSON Schema

```json
{
  "nodes": [
    {
      "id": "unique_string",
      "label": "human_name",
      "file_type": "code|document|paper|image|rationale",
      "source_file": "path",
      "source_location": "L42",
      "community": 0
    }
  ],
  "edges": [
    {
      "source": "id_a",
      "target": "id_b",
      "relation": "calls|imports|uses|implements|semantically_similar_to",
      "confidence": "EXTRACTED|INFERRED|AMBIGUOUS",
      "confidence_score": 0.85,
      "source_file": "path"
    }
  ],
  "hyperedges": []
}
```

## Supported File Types

| Category | Extensions |
|----------|-----------|
| Code | .py, .ts, .js, .jsx, .tsx, .go, .rs, .java, .c, .cpp, .rb, .cs, .kt, .scala, .php, .swift, .lua, .zig, .ps1, .ex, .m, .jl, .vue, .svelte, .sql, .r, .dart, .v |
| Docs | .md, .mdx, .html, .txt, .rst, .yaml, .yml |
| Papers | .pdf |
| Images | .png, .jpg, .webp, .gif, .svg |
| Office | .docx, .xlsx (optional) |
| Video/Audio | .mp4, .mov, .mp3, .wav, YouTube URLs (optional) |

## MCP Server

Start the graph query server:
```bash
graphify serve graphify-out/graph.json
```

Tools exposed:
- `query_graph(query, budget)` - semantic search across graph
- `get_node(node_id)` - node details
- `get_neighbors(node_id)` - adjacent nodes + edge relations
- `shortest_path(source, target)` - find path between nodes

## Team Workflow

1. One person runs `/graphify .` to build the graph
2. Commit `graphify-out/` to git (exclude `manifest.json`, `cost.json`, and optionally `cache/`)
3. Everyone starts with the map - new team members can explore the codebase visually
4. `--update` flag only reprocesses changed files

## When to Use

- **Onboarding** - new to a codebase, need a map
- **Architecture review** - find god nodes, surprising connections, knowledge gaps
- **Refactoring** - understand what depends on what before changing
- **Documentation** - generate Obsidian wiki from code structure
- **Code review** - understand impact radius of changes
- **Large monorepos** - navigate complex multi-language projects
