---
name: hallucination-checker
description: Use this skill when reviewing AI outputs for factual accuracy or grounding failures. Triggers include: "check this for hallucinations", "is this output grounded", "verify this AI response", "fact-check the model output", "does this match the source", or any request to audit LLM outputs for fabricated or unsupported claims.
---

# Hallucination Checker Skill

## Hallucination Types
1. Factual Fabrication - states something simply false
2. Citation Fabrication - invents papers, URLs, quotes, statistics
3. Conflation - merges two real things into one incorrect thing
4. Intrinsic Inconsistency - contradicts itself within one response
5. Grounding Failure (RAG) - claims not supported by retrieved context
6. Confident Uncertainty - states unknown things with false confidence

## Check Workflow

### Step 1: Claim Extraction
Break the output into atomic claims:
Output: "Claude 3 Opus was released in March 2024 and has a 200K context window."
Claims:
1. Claude 3 Opus was released in March 2024
2. Claude 3 Opus has a 200K context window

### Step 2: Classify Each Claim
- SUPPORTED - directly stated in source/context
- INFERRED - logically follows from source (flag for review)
- UNSUPPORTED - not in source, not verifiable
- CONTRADICTED - conflicts with source or known facts

### Step 3: Risk Score Each Issue
Critical - factually wrong + stated confidently + consequential
Medium - unsupported but plausible, or wrong but inconsequential
Low - minor inference, hedged language used

### Step 4: Grounding Score (RAG outputs)
Grounding Score = Grounded Claims / Total Claims * 100%
>90% = Acceptable | 70-90% = Review recommended | <70% = Reject / regenerate

## Hallucination-Resistant Prompt Additions
- "Always cite the specific source passage supporting your claim."
- "If the answer is not in the provided context, say: I don't have that information."
- "Do not invent statistics, citations, URLs, or quotes."
- Use hedging: "Based on the provided context..." / "The document suggests..."

## Report Format
## Overall Assessment
Total claims: [N] | Grounded: [N] ([%]) | Unsupported: [N] ([%]) | Score: [%] PASS/FAIL

## Critical Issues
| Claim | Type | Evidence |
|---|---|---|

## Recommendations
- [ ] Add citation requirement to system prompt
- [ ] Add "I don't know" escape hatch
- [ ] Reduce chunk size to improve retrieval precision
- [ ] Add output validation before returning to user
