---
name: model-card-writer
description: Use this skill when creating model cards for any ML model or LLM deployment. Triggers include: "write a model card", "document this model", "create model documentation", "model card for deployment", or any request to document an AI model's intended use, limitations, or performance.
---

# Model Card Writer Skill

## Template
---
Model Name:
Model Type: (LLM / classifier / embedding / fine-tuned)
Base Model:
Version:
Developed By:
Last Updated:
---

## Intended Use
Primary use cases: [list]
Out-of-scope: [list - what this model must NOT be used for]

## Training
| Field | Details |
|---|---|
| Training Data | |
| Fine-Tuning Method | (LoRA / RLHF / prompt tuning / none) |
| Hardware | |
| Training Duration | |

## Performance
| Dataset | Task | Metric | Score |
|---|---|---|---|

## Latency & Cost (Production)
| Metric | Value |
|---|---|
| P50 Latency | |
| P95 Latency | |
| Cost per 1K requests | |
| Avg input tokens | |
| Avg output tokens | |

## Limitations
- Known failure modes: [list specific cases]
- Demographic/geographic gaps: [list]
- Knowledge cutoff: [date]

## Risks & Mitigation
| Risk | Likelihood | Severity | Mitigation |
|---|---|---|---|
| Hallucination | Medium | High | Grounding + citations required |

## How to Use
- Platform: | Region: | Endpoint:
- Recommended temperature: 0.0-0.3
- Recommended max_tokens: 1024

## Versioning
| Version | Date | Changes |
|---|---|---|
| v1.0 | | Initial release |

## Writing Rules
- Be honest about limitations - hiding weaknesses is a liability
- Quantify everything - no vague claims like "good performance"
- Include failure examples - show what bad outputs look like
- Update on every major version - stale model cards are dangerous
- Link to eval reports - reference the evidence, don't just summarize
