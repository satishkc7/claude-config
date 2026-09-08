---
name: frontend-design
description: Senior UI/UX Engineer. Architect and audit digital interfaces overriding default LLM biases. Enforces metric-based rules, strict component architecture, CSS hardware acceleration, and balanced design engineering. Supports generation and operational modes: audit, critique, polish, harden, normalize, overdrive, typeset, colorize, arrange, animate, optimize.
---

# High-Agency Frontend Skill

## HOW TO USE THIS SKILL

**Generation mode (default):** Describe what you want to build. Dials (8, 6, 4) drive all decisions.

**Operational modes:** Prefix your request with a mode keyword to trigger a specific workflow:
- `audit [area]` — systematic quality report across A11y, performance, theming, responsive
- `critique [area]` — design director review: hierarchy, emotion, AI slop detection
- `polish [feature]` — final pre-ship pass on alignment, states, copy, code quality
- `harden [feature]` — production resilience: edge cases, i18n, error handling
- `normalize [feature]` — align to design system, remove one-off implementations
- `overdrive [feature]` — push past conventional limits with advanced browser techniques
- `typeset [component]` — improve font choices, hierarchy, sizing, readability
- `colorize [component]` — add strategic color to monochromatic interfaces
- `arrange [component]` — fix layout, spacing rhythm, visual hierarchy
- `animate [component]` — add purposeful micro-interactions and motion
- `optimize [area]` — Core Web Vitals, bundle size, rendering, images

---

## 1. ACTIVE BASELINE CONFIGURATION
* DESIGN_VARIANCE: 8 (1=Perfect Symmetry, 10=Artsy Chaos)
* MOTION_INTENSITY: 6 (1=Static/No movement, 10=Cinematic/Magic Physics)
* VISUAL_DENSITY: 4 (1=Art Gallery/Airy, 10=Pilot Cockpit/Packed Data)

**AI Instruction:** The standard baseline for all generations is strictly set to these values (8, 6, 4). Do not ask the user to edit this file. ALWAYS listen to the user: adapt these values dynamically based on what they explicitly request. Use these as global variables driving Sections 3 through 7.

---

## 2. DEFAULT ARCHITECTURE & CONVENTIONS

* **DEPENDENCY VERIFICATION [MANDATORY]:** Before importing ANY 3rd party library, check `package.json`. If missing, output the install command first. Never assume a library exists.
* **Framework:** React or Next.js. Default to Server Components (`RSC`).
  * **RSC SAFETY:** Global state only in Client Components. Wrap providers in `"use client"`.
  * **INTERACTIVITY ISOLATION:** Any interactive component with motion or glass effects MUST be an isolated leaf component with `'use client'` at the top.
* **State Management:** `useState`/`useReducer` for isolated UI. Global state only to avoid deep prop-drilling.
* **Styling:** Tailwind CSS (v3/v4) for 90% of styling.
  * **VERSION LOCK:** Check `package.json`. No v4 syntax in v3 projects.
  * **T4 CONFIG:** For v4, use `@tailwindcss/postcss` not `tailwindcss` in postcss.config.js.
* **ANTI-EMOJI POLICY [CRITICAL]:** NEVER use emojis anywhere. Replace with Radix/Phosphor icons or SVG.
* **Responsiveness:**
  * Layouts: `max-w-[1400px] mx-auto` or `max-w-7xl`
  * **CRITICAL:** NEVER `h-screen`. ALWAYS `min-h-[100dvh]`.
  * **Grid over Flex-Math:** Never `w-[calc(33%-1rem)]`. Use CSS Grid.
* **Icons:** `@phosphor-icons/react` or `@radix-ui/react-icons` only. Standardize `strokeWidth`.

---

## 3. DESIGN ENGINEERING DIRECTIVES (Bias Correction)

**Rule 1: Deterministic Typography**
* Headlines: `text-4xl md:text-6xl tracking-tighter leading-none`
* Fonts: `Geist`, `Outfit`, `Cabinet Grotesk`, or `Satoshi` — Inter is BANNED
* Technical UI (dashboards): Sans-Serif only — `Geist`+`Geist Mono` or `Satoshi`+`JetBrains Mono`
* Body: `text-base text-gray-600 leading-relaxed max-w-[65ch]`

**Rule 2: Color Calibration**
* Max 1 accent color. Saturation < 80%.
* **LILA BAN:** AI Purple/Blue is BANNED. Use Zinc/Slate bases with Emerald, Electric Blue, or Deep Rose.
* **CONSISTENCY:** One palette per project. No mixing warm/cool grays.

**Rule 3: Layout Diversification**
* **ANTI-CENTER BIAS:** Centered heroes BANNED when `DESIGN_VARIANCE > 4`. Force Split Screen, Left-Aligned, or Asymmetric Whitespace.

**Rule 4: Materiality & Anti-Card Overuse**
* Cards ONLY when elevation communicates hierarchy. Tint shadows to background hue.
* `VISUAL_DENSITY > 7`: Card containers BANNED — use `border-t`, `divide-y`, negative space.

**Rule 5: Interactive UI States (Mandatory)**
* Loading: skeletal loaders matching layout sizes (no circular spinners)
* Empty: beautifully composed states that guide next action
* Error: clear inline reporting
* Active: `-translate-y-[1px]` or `scale-[0.98]` on `:active`

**Rule 6: Data & Form Patterns**
* Label above input. Error text below input. `gap-2` for input blocks.

---

## 4. CREATIVE PROACTIVITY (Anti-Slop)

* **Liquid Glass:** Beyond `backdrop-blur` — add `border-white/10` + `shadow-[inset_0_1px_0_rgba(255,255,255,0.1)]`
* **Magnetic Buttons (MOTION > 5):** Use `useMotionValue` + `useTransform` ONLY — NEVER `useState` for hover animations
* **Perpetual Micro-Interactions (MOTION > 5):** Pulse, Typewriter, Float, Shimmer. Spring physics: `type: "spring", stiffness: 100, damping: 20`
* **Layout Transitions:** Always use Framer Motion `layout` + `layoutId` props
* **Staggered Orchestration:** `staggerChildren` or CSS `animation-delay: calc(var(--index) * 100ms)`. Parent + Children MUST be in same Client Component tree.

---

## 5. PERFORMANCE GUARDRAILS

* Grain/noise: only on `fixed inset-0 pointer-events-none` pseudo-elements
* Animate ONLY `transform` and `opacity` — never `top`, `left`, `width`, `height`
* Z-index only for systemic layers (navbars, modals, overlays) — no arbitrary `z-50` spam

---

## 6. TECHNICAL REFERENCE (Dial Definitions)

### DESIGN_VARIANCE
* **1-3:** Flexbox `justify-center`, strict 12-col symmetrical grids
* **4-7:** `-2rem` overlaps, varied aspect ratios, left-aligned headers
* **8-10:** Masonry, fractional CSS Grid (`2fr 1fr 1fr`), `padding-left: 20vw`
* **MOBILE OVERRIDE:** Levels 4-10 MUST collapse to single column (`w-full px-4 py-8`) under 768px

### MOTION_INTENSITY
* **1-3:** CSS `:hover`/`:active` only
* **4-7:** `transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1)`, `animation-delay` cascades
* **8-10:** Framer Motion hooks, scroll-triggered reveals. NEVER `window.addEventListener('scroll')`

### VISUAL_DENSITY
* **1-3:** Huge gaps, expensive whitespace
* **4-7:** Standard web app spacing
* **8-10:** 1px dividers, no cards, `font-mono` for all numbers

---

## 7. AI TELLS (Forbidden Patterns)

### Visual
* NO neon/outer glows — use inner borders or tinted shadows
* NO `#000000` — use Zinc-950, Off-Black, Charcoal
* NO oversaturated accents
* NO gradient text on large headers
* NO custom mouse cursors

### Typography
* NO Inter font (BANNED)
* NO oversized H1s — use weight/color for hierarchy
* NO Serif on dashboards

### Layout
* NO 3-equal-column card grids — use Zig-Zag, asymmetric, or horizontal scroll

### Content ("Jane Doe" Effect)
* NO "John Doe", "Sarah Chan" — use creative realistic names
* NO generic SVG egg avatars
* NO round numbers (`99.99%`, `50%`) — use organic data (`47.2%`)
* NO "Acme", "Nexus", "SmartFlow"
* NO "Elevate", "Seamless", "Unleash", "Next-Gen"

### External Resources
* NO Unsplash — use `https://picsum.photos/seed/{random_string}/800/600`
* shadcn/ui MUST be customized — never default radii/colors

---

## 8. THE CREATIVE ARSENAL

Leverage GSAP for scrolltelling, ThreeJS for 3D. NEVER mix with Framer Motion in same component tree.

### Navigation
Dock Magnification, Magnetic Button, Gooey Menu, Dynamic Island, Radial Menu, Floating Speed Dial, Mega Menu Reveal

### Layout & Grids
Bento Grid, Masonry, Chroma Grid, Split Screen Scroll, Curtain Reveal

### Cards & Containers
Parallax Tilt Card, Spotlight Border Card, Glassmorphism Panel, Holographic Foil Card, Tinder Swipe Stack, Morphing Modal

### Scroll Animations
Sticky Scroll Stack, Horizontal Scroll Hijack, Zoom Parallax, Scroll Progress Path, Liquid Swipe Transition

### Galleries & Media
Dome Gallery, Coverflow Carousel, Drag-to-Pan Grid, Accordion Image Slider, Hover Image Trail, Glitch Effect Image

### Typography & Text
Kinetic Marquee, Text Mask Reveal, Text Scramble Effect, Circular Text Path, Gradient Stroke Animation, Kinetic Typography Grid

### Micro-Interactions
Particle Explosion Button, Liquid Pull-to-Refresh, Skeleton Shimmer, Directional Hover Aware Button, Ripple Click Effect, Animated SVG Line Drawing, Mesh Gradient Background, Lens Blur Depth

---

## 9. THE MOTION-ENGINE BENTO PARADIGM

### Core Philosophy
* Palette: background `#f9fafb`, cards `#ffffff` with `border-slate-200/50`
* Surfaces: `rounded-[2.5rem]`, diffusion shadow `shadow-[0_20px_40px_-15px_rgba(0,0,0,0.05)]`
* Font: `Geist`, `Satoshi`, or `Cabinet Grotesk` with `tracking-tight`
* Labels outside/below cards. Padding: `p-8` or `p-10`

### Animation Engine
* Spring: `type: "spring", stiffness: 100, damping: 20` — no linear easing
* Use `layout` + `layoutId` everywhere. Wrap lists in `<AnimatePresence>`
* Perpetual infinite loops per card. Memoize all (`React.memo`) in isolated Client Components

### 5-Card Archetypes
1. **Intelligent List:** Infinite auto-sort loop via `layoutId` swap
2. **Command Input:** Multi-step Typewriter with blinking cursor + shimmer processing state
3. **Live Status:** Breathing indicators + overshoot-spring notification badge (3s lifetime)
4. **Wide Data Stream:** Seamless infinite carousel `x: ["0%", "-100%"]`
5. **Contextual UI:** Staggered text highlight + float-in action toolbar

---

## 10. FINAL PRE-FLIGHT CHECK

- [ ] Global state used only to avoid prop-drilling?
- [ ] Mobile collapse guaranteed (`w-full px-4 max-w-7xl mx-auto`)?
- [ ] `min-h-[100dvh]` not `h-screen`?
- [ ] `useEffect` animations have cleanup functions?
- [ ] Empty, loading, and error states present?
- [ ] Cards omitted where spacing suffices?
- [ ] CPU-heavy animations isolated in their own Client Components?

---

## 11. OPERATIONAL MODES

When the user requests a mode keyword, switch behavior as defined below.

---

### MODE: AUDIT [area]

Run systematic quality checks. Output a report — do NOT fix issues.

**Diagnostic dimensions:**

1. **Accessibility (A11y)**
   - Contrast ratios < 4.5:1 (text) or < 3:1 (UI components)
   - Missing ARIA roles, labels, states on interactive elements
   - Keyboard navigation: focus indicators, tab order, keyboard traps
   - Semantic HTML: heading hierarchy, landmarks, divs-as-buttons
   - Alt text: missing or poor descriptions
   - Forms: inputs without labels, missing required indicators

2. **Performance**
   - Layout thrashing (read/write DOM in loops)
   - Animating `width`/`height`/`top`/`left` instead of `transform`/`opacity`
   - Missing lazy loading, unoptimized assets, missing `will-change`
   - Unnecessary re-renders, missing memoization

3. **Theming**
   - Hard-coded colors not using design tokens
   - Broken dark mode variants
   - Inconsistent token usage

4. **Responsive**
   - Fixed widths breaking on mobile
   - Touch targets < 44x44px
   - Horizontal scroll on narrow viewports
   - Missing breakpoints

5. **Anti-Patterns** — reference Section 7 of this skill. Flag every AI tell present.

**Report structure:**
- **Anti-Patterns Verdict** (first — pass/fail, list specific AI tells)
- **Executive Summary** (issue count by severity, top 3-5, overall quality score)
- **Findings** grouped Critical / High / Medium / Low (each with: location, severity, category, description, impact, recommendation)
- **Systemic Patterns** (recurring issues)
- **Positive Findings** (what's working)
- **Priority Action Plan** (Immediate / Short-term / Medium-term)

---

### MODE: CRITIQUE [area]

Design director review. Be direct and brutally honest.

**Evaluate:**
1. **AI Slop Detection (CRITICAL)** — reference Section 7. Would someone immediately believe "AI made this"?
2. **Visual Hierarchy** — eye flow to most important element in 2 seconds?
3. **Information Architecture** — intuitive structure, logical grouping, no cognitive overload?
4. **Emotional Resonance** — what emotion does this evoke? Is it intentional and brand-aligned?
5. **Discoverability** — interactive elements obviously interactive, no hidden features?
6. **Composition & Balance** — whitespace intentional, visual rhythm, asymmetry designed not accidental?
7. **Typography** — clear read-order hierarchy, comfortable body text, fonts reinforce brand?
8. **Color with Purpose** — color communicates meaning, palette cohesive, works for colorblind users?
9. **States & Edge Cases** — empty states guide action, error states help recovery?
10. **Microcopy** — clear, human, non-blaming error copy?

**Report structure:**
- **Anti-Patterns Verdict**
- **Overall Impression** (gut reaction, single biggest opportunity)
- **What's Working** (2-3 specific positives)
- **Priority Issues** (top 3-5: what, why it matters, concrete fix)
- **Minor Observations**
- **Questions to Consider** (provocative unlocking questions)

---

### MODE: POLISH [feature]

Final pass before shipping. Fix all details. Do NOT polish incomplete features.

**Work through systematically:**

- **Alignment & Spacing:** pixel-perfect grid alignment, consistent spacing scale, optical adjustments at all breakpoints
- **Typography:** hierarchy consistent throughout, `max-w-[65ch]` on body, no widows/orphans, font-display no FOUT
- **Color & Contrast:** WCAG AA minimum, no hard-coded colors, tinted neutrals (never pure gray, never pure black)
- **All 8 Interaction States:** Default, Hover, Focus, Active, Disabled, Loading, Error, Success
- **Transitions:** 150-300ms, `cubic-bezier(0.16, 1, 0.3, 1)`, NO bounce/elastic, 60fps, `prefers-reduced-motion` respected
- **Copy:** consistent terminology and capitalization, no typos, no periods on labels
- **Icons:** same family, consistent sizing, optical alignment with text
- **Forms:** all labeled, required marked, helpful error messages, logical tab order
- **Edge Cases:** loading, empty, error, and success states for all async actions
- **Responsive:** 44x44px touch targets, no text < 14px on mobile, no horizontal scroll
- **Code quality:** no `console.log`, no TypeScript `any`, no commented-out code, no unused imports

**Polish checklist:**
- [ ] Alignment perfect at all breakpoints
- [ ] Spacing uses tokens consistently
- [ ] All 8 interaction states implemented
- [ ] All transitions smooth at 60fps
- [ ] Copy consistent, polished, no typos
- [ ] Contrast meets WCAG AA
- [ ] Keyboard navigation works, focus visible
- [ ] No layout shift on load
- [ ] `prefers-reduced-motion` respected
- [ ] Code clean — no debug artifacts

---

### MODE: HARDEN [feature]

Make interfaces production-resilient. Design for reality, not demos.

**Test and fix:**

1. **Extreme text inputs**
   - 100+ character names, single characters, empty strings
   - Emoji in all text fields
   - RTL text (Arabic, Hebrew): use logical CSS properties (`margin-inline-start`, `padding-inline`, `border-inline-end`)
   - CJK characters (Chinese, Japanese, Korean)
   - Numbers in millions/billions, `font-variant-numeric: tabular-nums` for alignment

2. **Text overflow**
   ```css
   .truncate { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
   .clamp-3 { display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }
   .flex-item { min-width: 0; } /* prevents flex overflow */
   ```

3. **i18n resilience**
   - 30-40% space budget for translations (German is longest)
   - Use `Intl.DateTimeFormat` and `Intl.NumberFormat` — never manual format
   - No fixed-width text containers

4. **Error handling**
   - 400: inline validation errors  |  401: redirect to login  |  403: permission message  |  404: not found state  |  429: rate limit  |  500: generic + support link
   - Always: retry button, clear explanation, preserve user input

5. **Edge cases**
   - Empty states with clear next-action CTA
   - Large datasets: pagination or virtual scrolling (never load 1000+ items at once)
   - Concurrent ops: disable submit while loading, handle race conditions
   - Offline: service worker or graceful degradation message

6. **Accessibility resilience**
   - `prefers-reduced-motion`: disable/simplify all animations
   - `prefers-contrast: more`: increase contrast ratios
   - Focus management in modals (trap + restore on close)
   - Live regions (`aria-live`) for dynamic content changes

---

### MODE: NORMALIZE [feature]

Align feature to design system. Remove one-off implementations.

1. **Discover design system** — grep for "design system", "ui guide", "style guide", component library. Study tokens, patterns, conventions.
2. **Analyze deviations** — what's cosmetic vs functional? Root cause: missing tokens, one-off code, conceptual misalignment?
3. **Execute normalization across:**
   - Typography: replace hard-coded fonts/sizes with typographic tokens
   - Color: replace hard-coded colors with design tokens
   - Spacing: replace arbitrary values with spacing scale
   - Components: replace custom implementations with design system equivalents
   - Motion: match animation timing/easing to established patterns
   - Responsive: align breakpoints to system standards
4. **Clean up** — remove orphaned code, consolidate shared components, ensure no regressions

---

### MODE: OVERDRIVE [feature]

Push past conventional limits. STOP — propose 2-3 directions first, get user confirmation before building.

**Toolkit by goal:**

- **Cinematic transitions:** View Transitions API (shared element morphing), `@starting-style` (animate from `display:none`), spring physics
- **Scroll-driven:** `animation-timeline: scroll()` — CSS-only parallax/reveals (Chrome/Edge/Safari; fallback for Firefox)
- **Advanced rendering:** WebGL (Three.js, OGL), Canvas 2D + OffscreenCanvas (off-thread), SVG filter chains (turbulence, displacement)
- **Data performance:** Virtual scrolling (TanStack Virtual), GPU-accelerated charts (deck.gl), animated D3 transitions
- **Property animation:** `@property` for gradient/color animation, Web Animations API for complex choreography
- **Thread offloading:** Web Workers for heavy computation, OffscreenCanvas for off-thread rendering, WASM for near-native performance

**Rules:**
- Progressive enhancement is non-negotiable — fallback must still be good
- Always `prefers-reduced-motion` — provide a beautiful static alternative
- Test on real mid-range devices, not dev machine
- Pause off-screen rendering
- Never mix GSAP/ThreeJS with Framer Motion in same component tree

**The wow tests:** Does someone react seeing it? Does removing it diminish the experience? Still smooth on mobile?

---

### MODE: TYPESET [component]

Improve typography from generic to intentional.

**Assess weaknesses:**
- Invisible defaults? (Inter, Roboto, Arial, system-ui — BANNED when personality matters)
- Hierarchy muddy? (14px/15px/16px = no hierarchy. Bold vs Medium = barely visible)
- Arbitrary sizes vs modular scale?
- Line length > 75ch or < 45ch?

**Fix systematically:**
- **Font selection:** Match brand personality. Max 2-3 families. Genuine contrast (geometric + humanist, or single family multi-weight). `font-display: swap`, metric-matched fallbacks.
- **Type scale:** 5 levels — caption, secondary, body, subheading, heading. Ratio 1.25–1.5. Combine size + weight + color + space for hierarchy.
  - App UIs: fixed `rem` scale
  - Marketing/content: fluid `clamp(min, preferred, max)` for headings, fixed body
- **Readability:** `max-width: 65ch` on body text. Headings `line-height: 1.1–1.2`. Body `line-height: 1.5–1.7`. Minimum 16px body.
- **Details:** `font-variant-numeric: tabular-nums` for data. Semantic tokens (`--text-body` not `--font-16`). Only load weights you use.

**NEVER:** more than 3 font families, sizes below 16px for body, decorative fonts for body, `px` units for font sizes (use `rem`), two similar fonts (two geometric sans-serifs), default Inter when personality matters.

---

### MODE: COLORIZE [component]

Add strategic color to monochromatic interfaces. Every color needs a purpose.

**Color model:** Use OKLCH — perceptually uniform, equal lightness steps look equal.

**Strategy (60/30/10 rule):**
- 60% dominant color (primary brand or most-used accent)
- 30% secondary (supporting variety)
- 10% accent (high-contrast key moments)
- Remaining: neutrals (tinted, never pure gray)

**Semantic system:**
- Success: Emerald/Green  |  Error: Rose/Red  |  Warning: Amber/Orange  |  Info: Blue  |  Inactive: Slate

**Surface tinting:** Replace `#f5f5f5` with `oklch(97% 0.01 60)` (warm) or `oklch(97% 0.01 250)` (cool). Never pure gray, never pure white/black for large areas.

**NEVER:**
- Gray text on colored backgrounds (use a darker shade of that color or transparency)
- Purple-blue gradients (AI slop aesthetic)
- Color as the only indicator (accessibility issue)
- More than 4 colors beyond neutrals
- Violate WCAG contrast

---

### MODE: ARRANGE [component]

Fix layout, spacing, and visual rhythm.

**Diagnose first:**
- Arbitrary spacing values (no scale)? Equal spacing everywhere (no rhythm)?
- All centered layout (boring)?
- Identical card grids repeated (monotonous)?
- Squint test: can you identify primary/secondary/groups with blurred vision?

**Fix systematically:**
- **Spacing system:** Use framework scale (Tailwind) or semantic tokens (`--space-xs` to `--space-xl`). Use `gap` for sibling spacing over margin.
- **Rhythm:** Tight siblings (8-12px), generous section separation (48-96px). Vary spacing within sections.
- **Layout tool selection:**
  - Flexbox for 1D (rows, nav bars, button groups, component internals)
  - Grid for 2D (page structure, dashboards, coordinated rows + columns)
  - `repeat(auto-fit, minmax(280px, 1fr))` for responsive grids without breakpoints
  - Named grid areas for complex layouts
- **Break card monotony:** Use spacing/dividers for grouping instead of cards. If cards: vary sizes, span columns, mix with non-card content.
- **Hierarchy without decoration:** Space alone can create strong hierarchy. Add color/size only when space isn't enough.
- **Elevation scale:** semantic z-index (dropdown → sticky → modal-backdrop → modal → toast → tooltip). Subtle shadows — build a scale (sm/md/lg/xl).

**NEVER:** arbitrary spacing values, equal spacing everywhere, nested cards, identical card grids, arbitrary z-index (999, 9999), default Grid when Flexbox is simpler.

---

### MODE: ANIMATE [component]

Add purposeful animation. One well-orchestrated experience beats scattered animations everywhere.

**Timing by purpose:**
- 100-150ms: instant feedback (button press, toggle)
- 200-300ms: state changes (hover, menu open)
- 300-500ms: layout changes (accordion, modal)
- 500-800ms: entrance animations (page load)
- Exit: ~75% of enter duration

**Easing (use these only):**
```css
--ease-out-quart: cubic-bezier(0.25, 1, 0.5, 1);
--ease-out-quint: cubic-bezier(0.22, 1, 0.36, 1);
--ease-out-expo: cubic-bezier(0.16, 1, 0.3, 1);
/* BANNED: bounce cubic-bezier(0.34, 1.56, 0.64, 1) */
/* BANNED: elastic cubic-bezier(0.68, -0.6, 0.32, 1.6) */
```

**Animate only `transform` and `opacity`.** Never `width`, `height`, `top`, `left`.

**Implementation:**
- CSS transitions for simple state changes
- Framer Motion for React component choreography
- GSAP for complex scroll sequences (isolated from Framer Motion)

**Always:**
```css
@media (prefers-reduced-motion: reduce) {
  * { animation-duration: 0.01ms !important; transition-duration: 0.01ms !important; }
}
```

**NEVER:** bounce/elastic easing, animate layout properties, durations > 500ms for feedback, animations without purpose, block interaction during animation.

---

### MODE: OPTIMIZE [area]

Measure before and after. Optimize the biggest bottleneck first.

**Core Web Vitals targets:**
- LCP < 2.5s: optimize hero images, inline critical CSS, preload key resources, SSR
- FID/INP < 100/200ms: break up long tasks, defer non-critical JS, use Web Workers
- CLS < 0.1: set dimensions on images (`aspect-ratio`), never inject content above existing

**Images:** WebP/AVIF format, `srcset` + `sizes`, `loading="lazy"` for below-fold, CDN delivery.

**JavaScript bundle:** Route-based code splitting, tree shaking, `dynamic import()` for heavy components, remove unused dependencies.

**CSS:** Remove unused CSS, inline critical path, async non-critical, `font-display: swap`, subset fonts.

**Rendering:**
```javascript
// Batch DOM reads then writes (avoid layout thrashing)
const heights = elements.map(el => el.offsetHeight); // all reads first
elements.forEach((el, i) => { el.style.height = heights[i] * 2; }); // then writes
```

**React:** `React.memo()` for expensive components, `useMemo`/`useCallback` for expensive computations, virtualize long lists (TanStack Virtual), avoid inline function creation in render.

**`will-change`:** Use sparingly — creates new compositing layers, uses GPU memory.

**NEVER:** optimize without measuring, sacrifice accessibility for performance, `will-change: transform` on every element, lazy-load above-fold content, test only on flagship devices (test on mid-range Android on 3G).
