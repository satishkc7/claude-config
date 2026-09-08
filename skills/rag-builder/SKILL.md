---
name: rag-builder
description: Use this skill when building, designing, or debugging Retrieval-Augmented Generation (RAG) pipelines. Triggers include: "build a RAG system", "set up document search", "connect my docs to an LLM", "improve retrieval quality", "chunking strategy", or any task involving embedding, indexing, and retrieval of documents for LLM use.
---

# RAG Builder Skill

## Pipeline Stages
Documents → Chunking → Embedding → Indexing → [Query] → Retrieval → Reranking → Generation

## Chunking Strategies
| Strategy | Best For | Chunk Size |
|---|---|---|
| Fixed-size | Uniform docs | 256-512 tokens |
| Recursive character | Mixed content (default) | 512-1024 tokens |
| Sentence-based | Prose, articles | 1-5 sentences |
| Document-structure | PDFs with headers | Per section |
Rule: always set overlap to 10-20% of chunk size.

## Embedding Models
| Model | Provider | Notes |
|---|---|---|
| text-embedding-3-large | OpenAI | Best general purpose |
| Amazon Titan Embeddings | AWS Bedrock | Native Bedrock pairing |
| BAAI/bge-large-en-v1.5 | HuggingFace | Best open source |
Critical: use the same embedding model at index time AND query time.

## Vector Stores
| Store | Best For |
|---|---|
| pgvector | Existing Postgres infra |
| OpenSearch | AWS ecosystem (pairs with Bedrock) |
| Pinecone | Managed production scale |
| Chroma | Local dev / prototyping |
| Qdrant | High performance, self-hosted |

## Retrieval Patterns
- Basic: similarity_search(query, k=5)
- Hybrid (recommended): dense vector + BM25, fused with RRF
- HyDE: generate hypothetical answer, embed it, retrieve against that
- Multi-query: rewrite query 3 ways, retrieve each, deduplicate

## Generation Prompt Template
You are a helpful assistant. Answer using ONLY the provided context.
If context is insufficient, say "I don't have enough information."
Context: {retrieved_chunks}
Question: {user_query}

## RAG Quality Checklist
- [ ] Overlap set on chunks
- [ ] Same embedding model for indexing and querying
- [ ] Hybrid search enabled (not vector-only)
- [ ] Reranker applied before generation
- [ ] Retrieved chunks logged for debugging
- [ ] Fallback for "no results found" case handled
- [ ] Eval metrics tracked: precision, recall, faithfulness, relevance
