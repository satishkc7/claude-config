---
name: trace-analyzer
description: Use this skill when debugging or analyzing LLM traces, chain outputs, or agent execution logs. Triggers include: "debug my LLM chain", "why is my agent failing", "analyze this trace", "find the bottleneck", "why is latency high", or any request to investigate AI pipeline execution.
---

# Trace Analyzer Skill

## Analysis Order

### Step 1: Failure Detection
- Any exception or error in the trace?
- Any step returning empty or null output?
- Any step that timed out?
- Any LLM refusal?
- Any tool call that failed silently?

### Step 2: Latency Breakdown
Build this table from the trace:
| Step | Duration (ms) | % of Total | Input Tokens | Output Tokens |
|---|---|---|---|---|
Flags: any step > 60% of total = bottleneck; LLM call > 5s = consider streaming

### Step 3: Token Audit
- Input tokens: [count] ([% of context window])
- Output tokens: [count]
- Estimated cost: $[calculated]
- Wasted tokens check: repeated instructions? oversized chunks? uncompressed history?

### Step 4: Output Quality
- Output match expected format?
- Any parsing failures downstream?
- Model follow all instructions?
- Signs of hallucination (confident unsupported claims)?
- Response truncated (hit max_tokens)?

### Step 5: Agent-Specific
- Same tool called repeatedly (loop)?
- Chain-of-thought steps coherent?
- Agent knew when to stop?

## Common Failure Patterns
| Symptom | Likely Cause | Fix |
|---|---|---|
| Empty output | max_tokens too low | Increase max_tokens |
| JSON parse error | Model ignored format | Add format example + retry logic |
| High latency | Large input context | Trim history, compress chunks |
| Repeated tool calls | Agent stuck in loop | Add step limit + loop detection |
| Low retrieval relevance | Bad chunking or wrong embedding | Review chunk size and embedding model |
| Refusal | Prompt triggers safety filter | Rephrase, check content policy |
| Truncated output | max_tokens hit | Increase limit or split into multiple calls |

## Report Format
## Summary (1-2 sentence diagnosis)
## Failures | ## Bottlenecks | ## Token Waste | ## Quality Issues
## Root Cause (single most important fix)
## Recommended Actions (priority ordered)
