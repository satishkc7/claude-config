---
name: rapid-prototyper
description: Use this skill when building fast proofs-of-concept, MVPs, or prototypes. Triggers include: "build a quick prototype", "MVP for this idea", "validate this concept", "fastest way to build X", "proof of concept", or any request to create a working demo quickly. Prioritizes speed, validation, and iteration over polish and perfection.
---

# Rapid Prototyper Skill

Build working software fast. Validate ideas before over-engineering them. Ship in days, not weeks.

## Core Philosophy

- **Validate first, polish later** — build only what's needed to test the core hypothesis
- **Working > perfect** — a deployed prototype beats a polished local one
- **Measurable** — every prototype ships with analytics and a success metric
- **Evolvable** — architecture should survive becoming production, not require a rewrite

---

## Before Writing Any Code

Define these three things or refuse to start:

1. **Core hypothesis** — what assumption are we testing? ("Users will pay for X", "Flow Y reduces churn")
2. **Success metric** — how will we know it worked? (conversion rate, task completion, time-on-page)
3. **Minimum feature set** — what is the absolute minimum to test the hypothesis? Cut everything else.

If any of these are unclear, ask before proceeding.

---

## Default Stack (fastest path to deployed)

### Web App
```
Next.js 14 (App Router)  +  Tailwind CSS  +  shadcn/ui
Auth: Clerk (5-min setup, free tier)
DB: Supabase (Postgres + real-time + storage, free tier)
Deploy: Vercel (push-to-deploy, free tier)
Forms: react-hook-form + zod
State: zustand (only when needed)
```

### Backend API only
```
Node/Express or Hono  +  Prisma  +  Supabase/PlanetScale
Deploy: Railway or Render (free tier, no config)
```

### AI-powered prototype
```
Next.js  +  Vercel AI SDK  +  Anthropic/OpenAI
Vector store: Supabase pgvector (already in stack)
```

### No-code / low-code (when appropriate)
- Forms + workflows: n8n or Make
- Internal tools: Retool or Supabase Studio
- Landing page: Framer or Webflow
- Automation: Zapier for < 5 steps

---

## Speed Rules

**DO:**
- Use pre-built component libraries (shadcn/ui, Radix) — never custom components for prototypes
- Use BaaS (Supabase, Firebase) — never set up your own Postgres, auth, or storage
- Use managed deploy (Vercel, Railway) — never configure servers
- Copy-paste patterns from the codebase — DRY applies to production, not prototypes
- Hardcode config values — env vars and config systems come in v2
- Use seeded test data — don't build admin panels, seed via SQL

**DON'T:**
- Build features not needed to test the hypothesis
- Optimize for performance — that's a production concern
- Write tests — validate the idea first, then test
- Abstract or generalize — the prototype will probably be rewritten anyway
- Add error handling beyond what affects the demo flow

---

## Prototype Phases

### Phase 1: Core Flow (Day 1)
Get the primary user flow working end-to-end, even if ugly:
- One happy path only
- No edge case handling
- Hardcoded data is fine
- Deployed to a real URL (not localhost)

### Phase 2: Testable (Day 2)
Make it usable enough for real feedback:
- Basic error states (form validation, failed API calls)
- Mobile-responsive layout
- Analytics in place (see below)
- Feedback mechanism (Typeform embed or simple form)

### Phase 3: Iterable (Day 3+)
Respond to feedback:
- A/B test variants on the hypothesis
- Fix the top 3 friction points from user feedback
- Document what you learned, not just what you built

---

## Analytics (ship with Phase 1)

Add from day one — every prototype needs measurement.

```bash
npm install posthog-js   # free, self-hostable, GDPR-friendly
# or: npm install @vercel/analytics  # zero-config if on Vercel
```

Track at minimum:
- Page views
- Primary CTA click
- Core flow completion (funnel)
- Drop-off point

```typescript
// posthog setup (app/layout.tsx)
import posthog from 'posthog-js'
posthog.init('YOUR_KEY', { api_host: 'https://app.posthog.com' })

// track key events
posthog.capture('cta_clicked', { variant: 'A', location: 'hero' })
posthog.capture('flow_completed', { steps: 3, time_ms: elapsed })
```

---

## Feedback Collection

Embed feedback from Phase 1:

```tsx
// Simple in-app feedback button (no library needed)
<button onClick={() => window.open('https://forms.typeform.com/YOUR_FORM', '_blank')}>
  Give feedback
</button>
```

Or use a floating widget:
```bash
npm install @sentry/react   # error tracking = passive feedback
```

---

## Prototype-to-Production Checklist

When the prototype validates the hypothesis and you're ready to productionize:

- [ ] Replace hardcoded values with env vars
- [ ] Add input validation and error handling
- [ ] Replace seeded data with real data model
- [ ] Add auth if not already in place
- [ ] Write tests for core business logic
- [ ] Set up CI/CD pipeline
- [ ] Add structured logging
- [ ] Performance audit (Lighthouse)
- [ ] Security review (see code-reviewer skill)
- [ ] Remove all `console.log` and debug code

---

## Common Prototype Patterns

### Auth in 5 minutes (Clerk)
```tsx
// app/layout.tsx
import { ClerkProvider } from '@clerk/nextjs'
export default function RootLayout({ children }) {
  return <ClerkProvider>{children}</ClerkProvider>
}

// Protect a page
import { auth } from '@clerk/nextjs/server'
export default async function ProtectedPage() {
  const { userId } = await auth()
  if (!userId) redirect('/sign-in')
  return <div>Protected content</div>
}
```

### DB in 5 minutes (Supabase)
```typescript
import { createClient } from '@supabase/supabase-js'
const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!)

// query
const { data, error } = await supabase.from('items').select('*').eq('user_id', userId)

// insert
const { error } = await supabase.from('items').insert({ user_id: userId, name: 'item' })
```

### AI call in 5 minutes (Vercel AI SDK)
```typescript
import { generateText } from 'ai'
import { anthropic } from '@ai-sdk/anthropic'

const { text } = await generateText({
  model: anthropic('claude-sonnet-4-6'),
  prompt: userInput,
  system: 'Your system prompt here'
})
```

### File upload in 5 minutes (Supabase Storage)
```typescript
const { data, error } = await supabase.storage
  .from('uploads')
  .upload(`${userId}/${file.name}`, file)

const { data: { publicUrl } } = supabase.storage.from('uploads').getPublicUrl(path)
```

---

## Output Format

When asked to build a prototype, always respond with:

1. **Hypothesis being tested** (confirm understanding)
2. **Success metric** (how we'll know it worked)
3. **Feature cut list** (what's IN vs what's OUT of v1)
4. **Stack choice** (with brief reason)
5. **Phase 1 scope** (exactly what ships on day 1)
6. **Then the code**

Never start building without confirming the hypothesis and success metric.
