---
name: api-integrator
description: Use this skill when writing, reviewing, or scaffolding code that calls LLM APIs (Anthropic, AWS Bedrock, OpenAI, Cohere). Triggers include: "call the Claude API", "integrate with Bedrock", "wrap an LLM call", "add retry logic", "handle streaming", "count tokens", or any task involving production-grade LLM API client code.
---

# API Integrator Skill

## Bedrock Basic Invocation
```python
import boto3, json

client = boto3.client("bedrock-runtime", region_name="us-east-1")

def invoke_claude(prompt: str, system: str = "", max_tokens: int = 1024) -> str:
    body = {
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": max_tokens,
        "messages": [{"role": "user", "content": prompt}],
    }
    if system:
        body["system"] = system
    response = client.invoke_model(
        modelId="anthropic.claude-3-5-sonnet-20241022-v2:0",
        body=json.dumps(body),
    )
    return json.loads(response["body"].read())["content"][0]["text"]
```

## Retry + Backoff (Always Use in Production)
```python
import time, random
from botocore.exceptions import ClientError

def invoke_with_retry(prompt: str, max_retries: int = 3) -> str:
    for attempt in range(max_retries):
        try:
            return invoke_claude(prompt)
        except ClientError as e:
            if e.response["Error"]["Code"] == "ThrottlingException":
                time.sleep((2 ** attempt) + random.uniform(0, 1))
            elif e.response["Error"]["Code"] == "ModelErrorException":
                raise
            else:
                raise
    raise RuntimeError(f"Failed after {max_retries} retries")
```

## Streaming
```python
def invoke_stream(prompt: str) -> str:
    body = {"anthropic_version": "bedrock-2023-05-31", "max_tokens": 1024,
            "messages": [{"role": "user", "content": prompt}]}
    response = client.invoke_model_with_response_stream(
        modelId="anthropic.claude-3-5-sonnet-20241022-v2:0",
        body=json.dumps(body))
    full_text = ""
    for event in response["body"]:
        chunk = json.loads(event["chunk"]["bytes"])
        if chunk["type"] == "content_block_delta":
            full_text += chunk["delta"].get("text", "")
    return full_text
```

## Production Checklist
- [ ] Retry with exponential backoff on ThrottlingException
- [ ] Timeout set on all API calls
- [ ] Token counts logged per call
- [ ] Cost tracked per call
- [ ] Model ID pinned to specific version (never "latest")
- [ ] Max tokens set explicitly on every call
- [ ] System prompt versioned alongside code
- [ ] Fallback behavior defined if API is unavailable
- [ ] PII scrubbed before logging prompts
