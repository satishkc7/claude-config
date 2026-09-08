---
name: test-writer
description: Use this skill when writing tests for AI pipelines, LLM integrations, or ML systems. Triggers include: "write tests for my AI code", "how do I test an LLM call", "mock the API", "test my RAG pipeline", "non-deterministic output testing", or any request to add test coverage to code that calls LLMs.
---

# Test Writer Skill (AI/LLM Systems)

## Core Principle
Never assert exact LLM output. Assert structural correctness, constraints, and semantic properties.

## Pattern 1: Mock the LLM (Unit Tests)
```python
# conftest.py
import pytest, json
from unittest.mock import patch, MagicMock

@pytest.fixture
def mock_bedrock():
    with patch("boto3.client") as mock_client:
        resp = MagicMock()
        resp["body"].read.return_value = json.dumps({
            "content": [{"type": "text", "text": "Mocked response"}],
            "usage": {"input_tokens": 10, "output_tokens": 5}
        }).encode()
        mock_client.return_value.invoke_model.return_value = resp
        yield mock_client
```

## Pattern 2: Structural Assertions
```python
def test_extract_returns_valid_schema(monkeypatch):
    monkeypatch.setattr("mymodule.invoke_claude",
                        lambda _: '{"name": "John", "age": 30}')
    result = extract_person_info("John is 30 years old.")
    assert isinstance(result, dict)
    assert "name" in result and "age" in result
    assert isinstance(result["age"], int)
```

## Pattern 3: Constraint-Based Assertions
```python
def test_summary_constraints(monkeypatch):
    monkeypatch.setattr("mymodule.invoke_claude", lambda _: "A short summary.")
    summary = summarize("Long document text here...")
    assert len(summary) < 500
    assert summary.strip()
    assert "." in summary
```

## Pattern 4: Gated Integration Tests
```python
@pytest.mark.integration  # run with: pytest -m integration
def test_real_api_response():
    result = invoke_claude("What is 2 + 2?")
    assert "4" in result
    assert len(result) < 2000
```

## Pattern 5: Prompt Regression
```python
import hashlib
PROMPT_HASHES = {"summarize_v2": "abc123def456"}

def test_prompt_unchanged():
    from mymodule.prompts import SUMMARIZE_PROMPT
    actual = hashlib.md5(SUMMARIZE_PROMPT.encode()).hexdigest()
    assert actual == PROMPT_HASHES["summarize_v2"], \
        "Prompt changed! Update hash and run evals before merging."
```

## Coverage Checklist
- [ ] All LLM calls mocked in unit tests
- [ ] Output schema validated (not exact content)
- [ ] Length and format constraints asserted
- [ ] Error paths tested (throttling, timeout, malformed output)
- [ ] Retry logic tested with mock failures
- [ ] Prompt hashes tracked for regression detection
- [ ] Integration tests marked and gated
- [ ] RAG fallback ("no results") case covered
