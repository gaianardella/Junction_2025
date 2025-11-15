## Transaction Categorisation Strategy

This document describes how we categorise user transactions **on device** and how those categories are then used to build higher-level indicators (e.g. “Smart Spending Profile”) without sending raw transactions to Gemini or our backend.

We deliberately avoid per-transaction “needs vs wants” labels and focus on **objective categories** plus **behavioural patterns**.

---

## 1. Objectives

- Provide enough structure to:
  - Build a simple 3-bucket overview (`Essentials`, `Wants`, `Savings`).
  - Detect patterns like **impulse / accidental spending**.
  - Support research-informed feedback and quests.
- Keep categorisation:
  - **Objective** at the transaction level (based on merchant type, MCC, recurrence, etc.).
  - Computed **locally on the phone**, not in the cloud.
  - A basis for **aggregate “needs vs wants”** estimates, not a per-transaction moral judgement.

---

## 2. Objective category set (per transaction)

Each transaction is assigned to one **objective category** using MCC codes (if available), bank-provided codes, deterministic rules, and optional user input:

- **Fixed essentials**
  - Rent, electricity, water, basic internet/phone, compulsory insurance.
- **Basic groceries & household**
  - Supermarkets, everyday hygiene and cleaning products.
- **Transport**
  - Public transport, fuel, basic commuting costs.
- **Financial commitments**
  - Loan repayments, credit card minimum payments, taxes and similar.
- **Subscriptions & recurring services**
  - Streaming, gym, gaming subscriptions, cloud storage, etc.
- **Eating out & cafés**
  - Restaurants, fast food, cafés.
- **Shopping & lifestyle**
  - Clothes, electronics, hobbies, entertainment tickets, gifts, etc.
- **Unexpected / irregular**
  - Repairs, health care events, one-off large purchases, fines, etc.
- **Uncategorised**
  - Transactions that do not match any rules and have not been labelled by the user.

The precise mapping logic is implemented on device and is adjustable over time.

---

## 3. Categorisation pipeline (on device)

### 3.1. Use bank and scheme metadata where available

- Read:
  - Merchant / counterparty name.
  - MCC (Merchant Category Code) for card transactions.
  - Bank-provided transaction type codes (if available).
- Apply a **mapping table** from MCC / bank codes to our objective categories.

### 3.2. Apply deterministic rules

For transactions without reliable codes, apply simple rules:

- **Keyword / regex rules** on merchant names:
  - e.g. Finnish grocery chains → `Basic groceries & household`.
  - Common streaming brands → `Subscriptions & recurring services`.
  - Known transport providers → `Transport`.
- **Recurrence detection**:
  - Similar amount + same merchant on a regular schedule → likely `Subscription & recurring services` or `Financial commitments`.

### 3.3. User-in-the-loop for “big unknowns”

- Keep an `Uncategorised` bucket.
- If an uncategorised merchant accumulates **significant spend** (e.g. > X €/month):
  - Ask the user with a simple prompt:
    - “We often see payments to ‘FOO OY’. Is this more like groceries, transport, subscriptions, shopping, or something else?”
  - Offer a small set of options plus “Other” / “I don’t know”.
- Remember the user’s choice **locally** for future transactions from the same merchant.

### 3.4. Optional future step: small on-device classifier

In a post-hackathon phase, we can add a small text+MCC classifier that:

- Runs entirely **on the device** (e.g. TensorFlow Lite).
- Uses merchant name, MCC, amount patterns, and recurrence features.
- Predicts one of the objective categories above.

This improves accuracy without sending any raw transaction data off the device.

---

## 4. From objective categories to higher-level views

### 4.1. Aggregated category summaries

For each analysis period (e.g. last 30 days, 90 days), we compute:

- Total amount and percentage per objective category:
  - `Fixed essentials`, `Basic groceries & household`, `Transport`, etc.
- Additional derived indicators, for example:
  - Number and volume of **new subscriptions**.
  - Size and frequency of **unexpected / irregular** expenses.

These aggregated numbers are used in:

- The Profile/Insights screen.
- Smart Spending Profile indicators.
- Pattern detection (e.g. spikes in certain categories).

### 4.2. Aggregate “needs vs wants” (not per transaction)

We avoid labelling each transaction as “need” or “want”. Instead, at the aggregated level we:

- Define contributions from objective categories, for example:
  - **Needs baseline**: fixed essentials, minimum financial commitments, portion of basic groceries & transport.
  - **Wants**: eating out & cafés, shopping & lifestyle, subscriptions above a basic threshold.
- Compute **rough ratios**:
  - e.g. “Approximately 55–65% of your spending looks like needs, 25–35% like wants.”

These estimates are used only for:

- High-level insights on the Home and Profile screens.
- Educational explanations (e.g. teaching budgeting concepts).

They are **not** used to moralise individual purchases.

### 4.3. Impulse / accidental spending as a pattern overlay

We treat “impulsive” or “accidental” spending as a **behavioural pattern**, not a separate category:

- On device, we detect:
  - Clusters of small discretionary transactions in time.
  - Late-night or emotionally charged category mixes (e.g. fast food + small shopping).
  - Deviations from the user’s historical baseline.
- We compute an **impulse_radar** score and category-level flags (e.g. “impulsive spikes mostly in Eating out & cafés and Shopping & lifestyle”).
- At no point do we create a separate “Accidental” category; the transactions remain in their objective categories with an additional pattern label.

These pattern indicators are then:

- Shown to the user in the Insights screen.
- Summarised and sent (in aggregate form) to Gemini for explanations and quest recommendations.

---

## 5. What leaves the device

- **Stays on device**:
  - Raw transaction lists (amounts, timestamps, merchant names, IBANs, etc.).
  - Per-transaction category assignments.
  - Per-transaction impulse pattern labels.
- **May be used in prompts to Gemini (summarised)**:
  - Percentage/amount per objective category.
  - Rough “needs vs wants” ratios for a period.
  - Impulse_radar score and a few bullet-point summaries (e.g. “impulsive spikes mostly in Eating out & cafés”; “subscriptions increased by 2 this month”).

This ensures that:

- Gemini never sees item-level transaction history.
- All privacy-sensitive work happens on the phone.
- We still have rich enough signals to personalise explanations, warnings, and learning content in a research-aligned way.
