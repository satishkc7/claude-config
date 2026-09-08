---
name: pre-deployment-checklist
description: Use this skill when the user asks to "run pre-deployment checklist", "check before production", "pre-deploy review", "is this ready for production", "production readiness check", or any request to audit a project before going live. Reviews authorization, input validation, CORS, rate limiting, security, error handling, database, logging, alerts, and rollback readiness.
version: 1.0.0
---

# Pre-Deployment Checklist

A production readiness audit across 10 critical areas. Work through each item systematically, report findings, and flag any blockers before the user ships.

## How to Run This Skill

When invoked, ask the user which project/stack they are deploying if not already clear. Then audit each section below by reading relevant source files. For each item, report:
- **PASS** - requirement met
- **WARN** - partially met or needs improvement
- **FAIL** - not implemented, blocks deployment
- **N/A** - not applicable to this project

Present a final summary table and list any FAIL or WARN items the user must address before going live.

---

## 1. Authorization

**Goal:** Users can only access data and actions they are permitted to.

Check for:
- Every API route that returns or mutates user-specific data enforces an ownership check (e.g. `WHERE id = req.user.id`, not just auth middleware)
- No route relies solely on a user-supplied ID without verifying it belongs to the authenticated user
- Admin routes are protected by role checks, not just login status
- Object-level authorization is enforced server-side - changing an ID in a URL or request body should not expose another user's data (IDOR vulnerability)

Questions to answer from code:
- Can a logged-in user fetch or modify another user's records by guessing their ID?
- Is authorization logic in the controller/handler, not just at the router middleware level?

---

## 2. Input Validation and Sanitization

**Goal:** Bad input cannot cause broken logic, database errors, or security vulnerabilities.

Check for:
- All user-facing inputs are validated for type, format, length, and required fields before use
- Validation happens server-side, not just client-side
- No raw user input is interpolated into SQL queries (use parameterized queries / ORM)
- No raw user input is inserted into HTML without escaping (XSS prevention)
- File uploads (if any) validate type, size, and are not served from a path user can control
- Error messages from validation failures do not leak internal schema or stack traces

---

## 3. CORS

**Goal:** Only the correct origins can make cross-origin requests to the backend.

Check for:
- CORS is explicitly configured, not left at framework defaults
- `Access-Control-Allow-Origin` is not set to `*` unless this is a fully public read-only API
- Allowed origins are an explicit list of known frontend domains (e.g. production URL, staging URL)
- Credentials (`withCredentials`) are only allowed for trusted origins
- Preflight (`OPTIONS`) requests are handled correctly

---

## 4. Rate Limiting

**Goal:** The API is protected from spam, abuse, and accidental overuse.

Check for:
- Rate limiting middleware is applied to public-facing endpoints (especially auth, signup, password reset, contact forms)
- Limits are per-IP or per-user, not just global
- Rate limit headers are returned so clients can self-throttle
- Auth endpoints (login, register, password reset) have stricter limits than general API endpoints
- Repeated failed auth attempts trigger lockout or throttle (brute-force protection)

---

## 5. Password Reset Expiration

**Goal:** Reset links expire quickly and cannot be reused.

Check for (only if the app has password reset):
- Reset tokens expire in 30 minutes or less
- Tokens are single-use - marked as used after the first valid redemption
- Expired/used tokens are rejected with a clear error
- Tokens are stored as hashed values in the database, not plaintext
- Old reset tokens are invalidated when a new one is requested

---

## 6. Frontend Error Handling

**Goal:** Users never see raw crashes, stack traces, or broken blank pages.

Check for:
- API error responses are caught and displayed as user-friendly messages
- Network failures (offline, timeout) show a helpful state rather than an unhandled exception
- Loading states are shown during async operations
- Form submissions handle both success and error paths visually
- No `console.error` output contains sensitive data (tokens, PII)
- 404 and 500 routes/pages exist and render something useful

---

## 7. Database Indexes

**Goal:** High-frequency queries are indexed for production load.

Check for:
- Foreign keys used in JOIN conditions are indexed
- Columns used in WHERE, ORDER BY, or GROUP BY on large tables are indexed
- Unique constraints are in place for fields that must be unique (email, username, token)
- No N+1 query patterns in common code paths
- Migration files reflect indexes alongside table definitions

---

## 8. Logging

**Goal:** When something breaks in production, logs provide enough context to diagnose the issue.

Check for:
- Errors are logged with context: endpoint, user ID (not PII), error message, stack trace
- Critical flows (auth, payment, data mutation) log success and failure events
- Logs do not contain passwords, tokens, credit card numbers, or other sensitive data
- Log level is appropriate: `error` for exceptions, `warn` for degraded states, `info` for key events
- Logging is not excessive - avoid logging every request body in full (cost + privacy risk)

---

## 9. Alerts

**Goal:** The team knows when something goes wrong before users start complaining.

Check for:
- An alerting system is configured (e.g. Sentry, Datadog, PagerDuty, CloudWatch Alarms, UptimeRobot)
- Alerts fire on: elevated error rate, p95 latency spike, failed health checks, critical job failures
- Alerts reach the right people (email, Slack, PagerDuty) with enough context to act
- Runbooks or on-call procedures exist for common alert types
- Alert thresholds are set - not just "any error" but meaningful signal vs. noise

---

## 10. Rollback Plan

**Goal:** If a deploy goes bad, there is a tested path to restore a known good state quickly.

Check for:
- Previous container image / build artifact is retained and can be redeployed with one command
- Database migrations are backwards-compatible OR a rollback migration exists for each forward migration
- Feature flags or environment variables can disable new features without a full redeploy
- Deployment process has a documented rollback procedure (not just "we'll figure it out")
- Team knows who has the access and authority to execute a rollback

---

## Output Format

After auditing all 10 sections, present results as:

```
PRE-DEPLOYMENT CHECKLIST RESULTS
=================================

| # | Area                        | Status | Notes                          |
|---|-----------------------------|--------|--------------------------------|
| 1 | Authorization               | PASS   |                                |
| 2 | Input Validation            | WARN   | No server-side length limits   |
| 3 | CORS                        | FAIL   | Wildcard origin in production  |
| 4 | Rate Limiting               | PASS   |                                |
| 5 | Password Reset Expiration   | N/A    | No password reset feature      |
| 6 | Frontend Error Handling     | WARN   | Missing network failure state  |
| 7 | Database Indexes            | PASS   |                                |
| 8 | Logging                     | PASS   |                                |
| 9 | Alerts                      | FAIL   | No alerting configured         |
|10 | Rollback Plan               | WARN   | No rollback migration scripts  |

BLOCKERS (must fix before deploy):
- #3 CORS: Set explicit allowed origins, remove wildcard
- #9 Alerts: Configure at minimum error-rate alerting via Sentry or similar

WARNINGS (fix soon after deploy):
- #2 Input Validation: Add max length constraints on all text inputs
- #6 Frontend: Add offline/network error UI state
- #10 Rollback: Write rollback migrations for recent schema changes
```

Be specific. Reference file names and line numbers when flagging issues. Do not just say "PASS" without having verified the code.
