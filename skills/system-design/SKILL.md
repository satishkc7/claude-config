---
name: system-design
description: Use this skill when the user asks to "design a system", "system design interview", "design an architecture", "design a scalable service", "how would you design X", or any request involving architecting distributed systems, APIs, databases, or large-scale services.
version: 1.0.0
---

# System Design

This skill guides structured system design sessions across five phases: problem definition, high-level design, deep dive, scaling analysis, and review.

## Phase 1: Define the Problem Space

Before designing anything, establish clear boundaries.

- **Understand the problem**: What does the system need to do? Who are the users?
- **Functional requirements**: Core features the system must support (e.g., upload, search, notify).
- **Non-functional requirements**: Latency, throughput, availability, consistency, durability, security.
- **Scale estimates**: DAU, QPS (read vs write), data volume, storage growth rate.
- **State assumptions explicitly**: Call out what you are assuming (e.g., "Assume 10M DAU, 100:1 read/write ratio").
- **Out of scope**: Explicitly list what is NOT being designed to keep scope controlled.

## Phase 2: Design the System at a High Level

Sketch the overall architecture before diving into details.

- **API design**: Define the key endpoints or interfaces. Specify:
  - Method (GET/POST/RPC)
  - Request parameters and response schema
  - Client-server vs event-driven communication
- **Core components**: Identify the major building blocks (client, API gateway, services, DB, cache, queue, CDN).
- **Data model**: Define primary entities and relationships. Choose SQL vs NoSQL with justification.
- **High-level diagram**: Describe or sketch the architecture showing data flow between components.
- **Happy path walkthrough**: Trace a key user request end-to-end through the system.

## Phase 3: Deep Dive into the Design

Examine critical components in detail.

- **Component internals**: How does each service work? What are its responsibilities?
- **Data storage design**: Schema, indexing strategy, sharding key (if applicable), query patterns.
- **Communication patterns**: Synchronous REST/gRPC vs asynchronous messaging (Kafka, SQS). Justify the choice.
- **Consistency model**: Strong vs eventual consistency. Where are trade-offs acceptable?
- **Design options with trade-offs**: Present 2-3 alternatives for key decisions with pros/cons.
- **Non-functional impact**: How do NFRs (latency, availability) shape specific design choices?

## Phase 4: Identify Bottlenecks and Scaling Opportunities

Stress-test the design against real-world conditions.

- **Single points of failure**: Identify components with no redundancy. Propose mitigations (replication, failover).
- **Hot spots**: Which components face the most load?
- **Horizontal scaling**: Which services can scale out? Stateless vs stateful components.
- **Data scaling**: Sharding strategy, read replicas, archival/data tiering.
- **Caching**: Where to cache (client, CDN, application, DB). Cache invalidation strategy.
- **Rate limiting**: Token bucket, leaky bucket, or fixed window. Where to enforce.
- **Global distribution**: Multi-region architecture, geo-routing, data residency considerations.
- **CDN**: Static asset delivery, edge caching for dynamic content.

## Phase 5: Review and Wrap Up

Tie the design together with a clear summary.

- **Decisions summary**: Recap the 3-5 most important architectural decisions and their justifications.
- **Trade-offs acknowledged**: Be explicit about what the design sacrifices (e.g., consistency for availability).
- **Requirements check**: Verify the design satisfies each functional and non-functional requirement stated in Phase 1.
- **Further improvements**: Identify 2-3 areas for future enhancement.
- **Open questions**: Flag any unresolved decisions that would need more context to finalize.

## Conventions

- Always quantify: use numbers from the scale estimates to justify choices.
- Prefer breadth first, then depth: cover all phases before going deep, unless the user asks to focus.
- State trade-offs explicitly: never present one option as universally correct.
- Use precise terminology: distinguish between availability, durability, consistency, and partition tolerance.
