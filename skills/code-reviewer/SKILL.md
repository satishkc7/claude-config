---
name: code-reviewer
description: Use this skill when reviewing any code — general PRs or AI/LLM-specific pipelines. Triggers include: "review this code", "check my PR", "find issues", "is this safe", or when shown code that interacts with LLM APIs, prompt construction, vector stores, agents, or any backend/frontend logic.
---

# Code Reviewer Skill

Review code like a mentor, not a gatekeeper. Every comment should teach something. Be specific, explain why, prioritize ruthlessly.

## Severity System

- **BLOCKER** — must fix before merge (data loss, security vulnerability, broken functionality)
- **SUGGESTION** — should fix soon (missing validation, performance issue, unclear logic)
- **NIT** — nice to have (style, minor naming, docs)

---

## Pass 1: AI/LLM-Specific Issues (run if code touches LLM APIs, prompts, agents, or vector stores)

### BLOCKER
- Prompt injection: user input injected directly into prompt string
  - BAD:  `prompt = f"Summarize: {user_input}"`
  - GOOD: `prompt = f"Summarize:\n<document>{sanitize(user_input)}</document>"`
- Hardcoded vague model version (use full pinned version string)
- Missing `max_tokens` on any API call
- No retry/backoff logic on LLM calls
- PII or secrets logged in prompt debug output
- API keys in prompt text or hardcoded in source

### SUGGESTION
- Concatenated prompt strings instead of template functions
- No output validation or JSON parse error handling
- Unbounded conversation history (no token budget management)
- LLM calls not abstracted behind a single wrapper
- No token usage or cost tracking per call

### BEST PRACTICE
- Prompts versioned separately from business logic
- Agent tool calls have input validation and output schemas
- Streaming errors handled (not just final response errors)
- Model fallback defined if primary model unavailable

---

## Pass 2: Security (all code)

### BLOCKER
- SQL/NoSQL injection (user input in raw queries)
- XSS (unsanitized user input rendered as HTML)
- Auth bypass (missing auth checks on protected routes)
- Insecure direct object reference (no ownership check on resource access)
- Secrets hardcoded in source (API keys, passwords, tokens)
- Missing input validation on any public endpoint

### SUGGESTION
- No rate limiting on public-facing endpoints
- Error messages exposing stack traces or internal paths to users
- Missing CSRF protection on state-changing requests
- Passwords compared without constant-time function

---

## Pass 3: Correctness & Logic

### BLOCKER
- Race conditions or deadlocks
- Off-by-one errors in critical loops
- Null/undefined dereference without guard
- Breaking change to a public API contract

### SUGGESTION
- Missing error handling on async operations
- Silent catch blocks (`catch (e) {}`)
- Edge cases not handled (empty array, zero, negative numbers)
- Business logic doesn't match requirements

---

## Pass 4: Performance

### SUGGESTION
- N+1 queries (database call inside a loop)
- Synchronous blocking call in async context
- Unbounded list fetched when paginated would suffice
- Expensive computation run on every render/request instead of cached

---

## Pass 5: Maintainability

### SUGGESTION
- Functions > 40 lines doing more than one thing
- Magic numbers without named constants
- Variable names that don't describe intent (`data`, `temp`, `obj`)
- Deeply nested conditionals (> 3 levels) — use early return

### NIT
- Dead code or commented-out blocks
- Unused imports or dependencies
- Inconsistent naming conventions
- Missing docstring on public functions with non-obvious behavior

---

## Pass 6: Testing

### SUGGESTION
- No tests for core business logic
- Happy path only — no edge case or error path coverage
- Tests that only test implementation (not behavior)
- Flaky tests (time-dependent, order-dependent)

---

## Standard Engineering Checklist

- [ ] Error handling on all exceptions
- [ ] Type hints/annotations present
- [ ] Single-responsibility functions
- [ ] Named constants (no magic numbers)
- [ ] Tests for core logic
- [ ] Dependencies pinned
- [ ] No dead code or debug artifacts
- [ ] No secrets in source

---

## Output Format

```
## Summary
[2-3 sentence overview: what the code does, overall quality, key concerns]

## BLOCKERS
[List each — location, what it is, why it matters, how to fix]

## SUGGESTIONS
[List each — location, what it is, reasoning, suggested fix]

## NITS
[Brief list — location, what to tweak]

## What's Working Well
[Specific callouts of good patterns worth replicating]

## Decision
APPROVED | APPROVED WITH SUGGESTIONS | NEEDS CHANGES
```

**Rules:**
- Be specific ("line 42 SQL injection via f-string" not "security issue")
- Always explain the why, not just the what
- Praise good code — call out clever solutions and clean patterns
- One complete review — don't drip-feed feedback across rounds
- Never block on style if a linter handles it
