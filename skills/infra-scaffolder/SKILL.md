---
name: infra-scaffolder
description: Use this skill when scaffolding infrastructure for AI model serving, deployment, or MLOps pipelines. Triggers include: "deploy my model", "create a Docker setup for my AI app", "SageMaker endpoint config", "auto-scaling for LLM", "observability for AI", or any request to create infra configs for AI workloads.
---

# Infra Scaffolder Skill (AI/ML)

## FastAPI App (app/main.py)
```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import boto3, json, time

app = FastAPI(title="LLM API", version="1.0.0")
bedrock = boto3.client("bedrock-runtime", region_name="us-east-1")

class InferenceRequest(BaseModel):
    prompt: str
    max_tokens: int = 1024
    system: str = ""

@app.post("/invoke")
async def invoke(req: InferenceRequest):
    start = time.time()
    try:
        body = {"anthropic_version": "bedrock-2023-05-31",
                "max_tokens": req.max_tokens,
                "messages": [{"role": "user", "content": req.prompt}]}
        if req.system:
            body["system"] = req.system
        resp = bedrock.invoke_model(
            modelId="anthropic.claude-3-5-sonnet-20241022-v2:0",
            body=json.dumps(body))
        result = json.loads(resp["body"].read())
        return {"output": result["content"][0]["text"],
                "input_tokens": result["usage"]["input_tokens"],
                "output_tokens": result["usage"]["output_tokens"],
                "latency_ms": (time.time() - start) * 1000}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
def health(): return {"status": "ok"}
```

## Dockerfile
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app/ ./app/
EXPOSE 8080
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080", "--workers", "4"]
```

## Structured Logging
```python
import json, logging
logger = logging.getLogger()
def log_call(request_id, input_tokens, output_tokens, latency_ms, error=None):
    logger.info(json.dumps({
        "event": "llm_inference", "request_id": request_id,
        "input_tokens": input_tokens, "output_tokens": output_tokens,
        "latency_ms": latency_ms, "error": error}))
```

## CloudWatch Metrics to Track
- LLM Invocation Count (per minute)
- P50 / P95 / P99 Latency
- Error Rate (4xx, 5xx)
- Input + Output Token Cost ($/hr)
- Throttle Events

## Infra Checklist
- [ ] Health check endpoint implemented
- [ ] Structured JSON logging enabled
- [ ] Auto-scaling min >= 2 for high availability
- [ ] IAM role scoped to Bedrock only (least privilege)
- [ ] Secrets in AWS Secrets Manager (not env vars)
- [ ] CloudWatch alarms on error rate + latency
- [ ] Cost budget alert on Bedrock usage
- [ ] VPC endpoints for Bedrock (no public internet)
- [ ] Docker image scanned for vulnerabilities
