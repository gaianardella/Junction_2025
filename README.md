# Habitize – AI Financial Coach for Finnish Youth

Habitize helps 15–25 year olds make money visible and build healthy habits using research-backed content, neurodivergent-friendly UX, and AI-powered personalization.

## What problem we solve

1. **Financial visibility** – young users often have only fragments of information across banking apps. Habitize aggregates spending into simple Essentials / Wants / Savings buckets, highlights impulse patterns, and shows progress toward their goals in a friendly dashboard.
2. **Skill building** – financial literacy content is scattered or long-form. We deliver nano lessons, full articles, and interactive quests tuned to each user’s needs so learning fits in real life.

## Key features

- **Home dashboard**
  - Current balance snapshot with goal progress bars.
  - Daily streak counter and motivational highlights (e.g., “No overdrafts in 30 days”).
  - Category breakdown for the last period plus impulse radar summary.

- **AI-guided learning**
  - Firestore hosts nano lessons, articles, and future video snippets curated from Finnish financial literacy research.
  - Gemini 2.5 Flash recommends the best next nano lesson (and later, learning paths, challenges, and articles) based on the user’s profile and behavior.
  - Push-friendly “nano learning” tips plus full-length articles and structured learning paths (planned) to support deeper mastery.

- **Gamified journeys (planned)**
  - Daily streak system and seasonal challenges.
  - Monthly competition leaderboard for classrooms or friend groups.
  - Optional TikTok-style video nuggets to keep the tone fun and relatable.

- **Sandbox simulator (design ready)**
  - Single-screen layout with collapsible blocks so users can tweak income, rent, category budgets, and savings goals on the fly.
  - Instant feedback on “time to goal,” disposable cash, and trade-offs.
  - Designed to be inclusive by default: simple sliders, always-visible summary HUD, no hidden menus.

## Architecture overview

- **Frontend**: Flutter mobile app (see UI specs in `docs/ui_screens.md`) with neurodivergent-aware patterns (predictable layout, calm visuals, optional low-stimulation mode).

- **Backend**: FastAPI (Uvicorn) deployed to Google Cloud Run.
  - `main.py` – FastAPI entrypoint (health, Gemini analyze, `/recommend/nano`).
  - `dependencies.py` – loads env vars, instantiates Gemini and Firestore clients.
  - `firestore_helpers.py` – fetches content from Firestore Native (Native mode DB in Google Cloud).
  - `gemini_helpers.py` – builds prompts and wraps Gemini calls.
  - `/recommend/nano` fetches nano lessons from Firestore, passes them plus a user profile to Gemini 2.5 Flash, and returns the best recommendation.

- **Data layer**: Cloud Firestore (Native mode) storing nano lessons (seeded via `backend/scripts/import_content.py`). Planned collections for articles, quests, actions, warnings, etc., share the same JSON structure (`docs/sample_content.json`).

- **AI strategy**: Gemini 2.5 Flash for personalization (per the docs in `docs/gemini_integration.md`). Transactions stay on device, and only aggregated category info feeds the prompts.

## Local development

```
cd backend
poetry install
cp .env.example .env   # add GEMINI_API_KEY, GCP_PROJECT_ID if needed
poetry run uvicorn main:app --reload
```

## Deployment

- Backend runs on **Google Cloud Run** using a dedicated service account with `roles/datastore.user` access to the Firestore project—no JSON key shipping required.
- Content is stored in **Cloud Firestore** (Native mode) under the same GCP account.

## Roadmap / next steps

- Implement full sandbox interactions and savings simulation.
- Add long-form articles, curated learning paths, and monthly challenges (content structure already planned).
- Integrate optional short-form video pieces.
- Extend Firestore seeding for quests/actions/lessons.
- Add transaction categorization on-device per `docs/transaction_categorization.md`.

## Research foundation

- Kalmi, P., & Rahko, J. (2022). *The effects of game-based financial education: New survey evidence from lower-secondary school students in Finland*. The Journal of Economic Education, 53(2), 109–125. https://doi.org/10.1080/00220485.2022.2038320
- Guerrero, E., & Kalmi, P. (2022). *Gamification Strategies: A Characterization Using Formal Argumentation Theory*. SN Computer Science, 3, 291. https://doi.org/10.1007/s42979-022-01164-3
- Nyrhinen, J., Sirola, A., Koskelainen, T., Munnukka, J., & Wilska, T.-A. (2024). *Online antecedents for young consumers’ impulse buying behavior*. Computers in Human Behavior, 153, 108129. https://doi.org/10.1016/j.chb.2023.108129
- Koskelainen, T., Kalmi, P., Scornavacca, E., & Vartiainen, T. (2023). *Financial literacy in the digital age—A research agenda*. Journal of Consumer Affairs. https://doi.org/10.1111/joca.12510

Habitize turns these insights into a personalized, inclusive, and fun coaching experience that schools and young adults can pilot immediately.