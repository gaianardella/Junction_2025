## Gemini Integration – What We Send and What We Expect Back

This document organizes how we plan to use **Gemini API** in the app:

- **What data we send to Gemini** (and what we explicitly do *not* send).
- **What we expect back** (per use case).
- **Types of calls / prompt categories**.
- A focused use case: **AI commentary on quests and simulated decisions**.

The goal is to keep the interaction **GDPR-aware**, **privacy-preserving**, and **aligned with our research-based logic**, not to outsource all reasoning to the model.

---

## 1. Data we send to Gemini (high-level)

We want to minimise what we send and avoid raw sensitive financial details whenever possible.

### 1.1. What we generally DO send

Always in a **summarised, structured** form:

- **User profile (high level)**:
  - Age group (e.g. 15–17, 18–24, 25–30), not exact age.
  - General life situation if known (e.g. “lives with parents”, “first own apartment”, “student job”).
  - Self-reported preferences:
    - “Prefers bullet points / stories / step-by-step”.
    - Notification tolerance (Quiet / Normal / Active).
- **Objective spending category summary** (derived on device from transactions using local rules/ML):
  - Percentages / amounts per **objective category**, e.g.:
    - `Fixed essentials` (rent, utilities, basic internet/phone).
    - `Basic groceries & household`.
    - `Transport`.
    - `Financial commitments` (loan repayments etc.).
    - `Subscriptions & recurring services`.
    - `Eating out & cafés`.
    - `Shopping & lifestyle`.
    - `Unexpected / irregular`.
    - `Uncategorised` (if any).
  - Optionally, **soft “needs vs wants” estimates** computed only at the aggregate level (never per transaction).
  - No raw merchant names or timestamps; only category totals / ratios.
- **Smart Spending Profile summary** (user-level indicators built from the categories above):
  - Overall 3-bucket ratios (`Essentials`, `Wants`, `Savings`) derived from objective categories.
  - Flags such as:
    - `impulse_risk_level` (e.g. low/medium/high), based on patterns like clustering, time-of-day, and deviation from baseline.
    - `savings_consistency` (e.g. stable / unstable).
    - 1–3 bullet-style statements like “spikes in eating out around payday” or “new subscriptions started this month”.
- **App history / engagement summary**:
  - Which **quests** or **lessons** have been completed (IDs / names).
  - Which **types** of notifications the user tends to act on (e.g. “responds to progress messages, ignores long article suggestions”).
  - How long they’ve been using the app in coarse buckets (e.g. “<1 month”, “1–3 months”).
- **Available content/structures**:
  - A list of **quest IDs + short descriptions** the app can actually offer.
  - A list of **lesson/article IDs + topics** the app has locally.
  - A list of **action templates** (e.g. “review last week’s spending”, “set a small savings rule”, “play quest X”).
  - A list of **warning templates** we’re allowed to use (texts or labels).
- **Context-specific state** (for particular calls):
  - The specific pattern we detected (“spending +30% vs baseline in Wants”, “three impulse clusters this week”, etc.), expressed in **aggregated form**.
  - For quest commentary, the **user’s choices inside that quest** and simulated outcomes (see section 4).

### 1.2. What we generally DO NOT send

- Raw transaction lists with:
  - Exact timestamps.
  - Merchant names.
  - Exact locations.
- Bank account identifiers (IBAN, account IDs, card numbers).
- Any direct personal identifiers (name, email, phone).

Where we need to refer to merchants/categories, we describe them at a **high level** (e.g. “fast food / delivery”, “fast fashion”, “streaming subscription”) and only as **aggregated counts/amount ranges**.

---

## 2. What we expect from Gemini (by use case)

We will keep each call focused. Rather than asking for “everything” at once, we define separate prompt types.

### 2.1. Prompt type A – Notifications & Next Steps

**Goal:** Turn a small state summary into 1–3 short messages + matching existing actions/quests/lessons.

- **Inputs (to Gemini)**:
  - User profile summary (age group, preferences).
  - Smart Spending Profile summary (3-category split, impulse risk flags, simple pattern statements).
  - Recent changes (e.g. “Wants up 30% vs baseline”, “impulse radar: high this week”).
  - List of available:
    - Notification templates (with IDs).
    - Next steps / actions (IDs + short descriptions).
    - Quests (IDs + short descriptions).
    - Lessons/articles (IDs + tags).
- **Outputs (from Gemini)**:
  - 1–3 **notification recommendations**, each with:
    - `notification_template_id` or a short text that we can fit into our allowed range.
    - `type`: `insight`, `warning`, or `win`.
  - 1–3 **suggested next steps**, each referencing:
    - An `action_id` or `quest_id` or `lesson_id` from the provided lists.
    - A 1-sentence explanation tailored to the profile.

We keep hard constraints and available IDs in the prompt, so the model can’t invent content that doesn’t exist.

---

### 2.2. Prompt type B – Explanation / Teaching for a Specific Pattern

**Goal:** Generate a user-friendly explanation of a particular financial pattern or risk, matching their thinking style.

- **Inputs**:
  - The specific pattern detected, expressed descriptively:
    - Example: “User has had 4 late-night impulse-like food delivery purchases this week and is close to their monthly Wants budget.”
  - User profile summary (age group, preferences).
  - Desired explanation style: `bullets`, `story`, or `step_by_step`.
- **Outputs**:
  - A short explanation (few sentences or bullet points), with:
    - Clear description of what is happening.
    - A gentle, non-judgmental framing (“what this might mean for you”).
    - 1–2 concrete, simple suggestions (e.g. “set a soft cap”, “try a weekly budget for this category”).

These explanations can be used inside:

- Profile/Insights screen (pattern explanation).
- Notification detail views.
- Reflection screens after warnings.

---

### 2.3. Prompt type C – Quest / Lesson Recommendation

**Goal:** From all available quests and lessons, pick a small set that best fits the user’s current situation and history.

- **Inputs**:
  - User profile summary (age group, life situation, preferences).
  - Key financial state metrics (high-level, e.g. “no emergency buffer yet”, “Savings < 10% for last 2 months”, “impulse_radar: high”).
  - History: which quests/lessons have been completed; which types the user tends to finish vs drop.
  - List of available quests/lessons (IDs, topics, difficulty, estimated time).
- **Outputs**:
  - 2–3 recommended quest IDs (plus a 1-sentence pitch per quest).
  - Optionally 1–2 recommended lessons/articles (IDs) with short reasons.

This can be used to populate:

- The “Recommended” section in the Quests & Simulation Hub.
- “Next steps” suggestions in Notifications & Next Steps screen.

---

## 3. Focused use case: AI commentary on quests & simulated decisions

We want Gemini to **comment on user actions inside quests**, especially in simulations with virtual money.

### 3.1. Example quest: “Save for an electric guitar”

Scenario outline (implemented in the app logic):

- Virtual income: 2 000 € / month.
- Existing average spending template (Essentials & Wants categories).
- Goal: save enough for an electric guitar (e.g. 600–800 €) in a chosen timeframe.
- The user adjusts categories (food, entertainment, shopping, savings) and the app simulates:
  - How many months until the goal is reached.
  - Buffer amount (if any).
  - Potential risk areas (e.g. “no room for unexpected bill”).

### 3.2. What we send to Gemini for commentary

For each completed run of such a quest, we can send a **compact summary**, for example:

- Quest ID and theme (e.g. `quest_guitar_savings`).
- User profile summary (age group, preferences, impulse risk level).
- Initial state:
  - Income range (e.g. “~2000 €/month”).
  - Initial allocations as percentages (Essentials/Wants/Savings).
- User’s final plan:
  - New percentage allocations per category.
  - Simulated time to reach goal.
  - Presence/absence of emergency buffer (yes/no, rough size).
- Notable events in the quest (if any):
  - Did they choose to cut risks (e.g. reduce BNPL use)? yes/no.
  - Did they choose to leave no buffer? yes/no.

We **do not** send any actual bank transactions; this is all virtual and aggregated.

### 3.3. What we want back from Gemini

We want short, structured commentary, such as:

- **Praise / reinforcement**:
  - E.g. “You balanced saving for the guitar with keeping some emergency money, which makes your plan more resilient.”
- **Suggestions**:
  - E.g. “If you move a bit more from entertainment to savings, you can shorten the time to your guitar by 1–2 months.”
- **Risk pointing (gently)**:
  - E.g. “Right now, you have almost no buffer for unexpected costs. That might feel okay now, but could be stressful if something breaks. You might want to keep a small reserve.”
- **Next learning step**:
  - Suggest another quest or lesson that logically follows, e.g. “Want to try a quest about handling unexpected bills?” (referencing an existing quest ID we provide).

In JSON terms, we might ask for:

- `tone`: `praise_first` / `neutral` / `caution_first`.
- `main_message`: short text.
- `secondary_suggestions`: list of 1–2 short suggestions.
- `recommended_next_quest_id` (optional, chosen from the list we provide).

### 3.4. Why this helps neurodivergent and neurotypical users

- For users who struggle with **time perception** or long-term planning (e.g. ADHD), we:
  - Simulate consequences instantly (months compressed into one screen).
  - Use Gemini to explain those consequences in a way that fits their preferred explanation style.
- For neurotypical users, the same commentary:
  - Provides narrative reinforcement.
  - Suggests more advanced challenges when they’re ready.

---

## 4. Prompt type D – Reflection & Feedback (per quest run)

We can generalize the quest commentary into a reusable prompt type:

- **Inputs**:
  - Quest ID and theme.
  - User profile summary (age group, preferences).
  - High-level description of the choices made and simulated outcomes (as in 3.2).
  - Optional: a flag for what we want to emphasise (knowledge, self-efficacy, risk-awareness).
- **Outputs**:
  - 1–2 short messages:
    - `reflection_message`: summarizing what the user effectively did.
    - `encouragement_or_advice`: gentle suggestion of improvement or a note of confidence.
  - Optional:
    - `suggested_next_quest_id` or `suggested_lesson_id` from provided lists.

This can be the **final screen** of a quest and can be reused across multiple scenarios.

---

## 5. Summary for the team

- We keep **all serious computation and raw transaction handling on the device**; Gemini only sees **summaries** and **quest-state descriptions**, never raw bank events.
- We define **separate, focused prompt types**:
  - A: Notifications & Next Steps.
  - B: Explanations for specific patterns.
  - C: Quest/Lesson recommendation.
  - D: Reflection & feedback on quest decisions (commentary).
- For each call we:
  - Provide Gemini with:
    - High-level user profile.
    - Derived financial/behavioral indicators.
    - Lists of content/actions we can actually offer (so it can’t invent).
  - Expect from Gemini:
    - Short messages, choices among existing quests/actions, and simple structured feedback.

This keeps Gemini as a **coach and storyteller on top of our own rule system**, not as an opaque black box making unchecked decisions. 
