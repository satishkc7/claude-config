---
name: adr-writer
description: Use this skill when writing Architecture Decision Records (ADRs) for AI/ML systems. Triggers include: "write an ADR", "document this decision", "record why we chose X", "architecture decision for model selection", or any request to formally capture a technical design choice in an AI project.
---

# ADR Writer Skill

## Template

# ADR-[NUMBER]: [Short Decision Title]
Date: YYYY-MM-DD
Status: Proposed | Accepted | Deprecated | Superseded by ADR-XXX
Deciders: [names or teams]

## Context
[What problem are we solving? Constraints and forces at play. Facts only - no opinions yet.]

## Decision
We will use [X] for [purpose] because [key reason].

## Options Considered

### Option A: [Name] - CHOSEN
| Pros | Cons |
|---|---|
| | |
Why chosen: [brief rationale]

### Option B: [Name]
| Pros | Cons |
|---|---|
| | |
Why not chosen: [brief rationale]

## Consequences
Positive: [list]
Accepted Trade-offs: [list - and why we accept each]
Risks: [Risk] - Mitigation: [how we address it]

## Review Trigger
Revisit this decision if:
- [e.g., latency exceeds 2s P95]
- [e.g., cost exceeds $X/month]
- [e.g., a better model becomes available]

## Common AI ADR Topics
- Model selection (Claude vs GPT-4 vs Llama)
- Embedding model choice
- Vector store selection
- Chunking strategy
- Prompt versioning approach
- Fine-tuning vs prompt engineering
- Eval framework choice
- Caching strategy

## Writing Rules
- Context is everything - future readers won't remember why this seemed obvious
- Always capture rejected options - future you will thank present you
- Be honest about cons - ADRs with only pros are propaganda
- Define the review trigger - decisions rot without one
- Keep it to 1-2 pages max, link to longer docs
