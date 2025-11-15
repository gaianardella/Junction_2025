## Papers in this folder

- **Gamification & argumentation**
  - [Gamification Strategies – A Characterization Using Formal Argumentation Theory](Gamification Strategies  A Characterization Using Formal Argumentation Theory.md)
- **Digital financial literacy**
  - [Financial literacy in the digital age—A research agenda](Financial literacy in the digital age.md)
- **Impulse buying in digital environments**
  - [Online antecedents for young consumers' impulse buying behavior](Online antecedents for young consumers impulse buying behavior.md)
- **Game-based financial education**
  - [The effects of game-based financial education – New survey evidence from lower-secondary school students in Finland](The effects of game-based financial education New survey evidence from lower-secondary school students in Finland.md)

## Product context (for interpreting the papers)

- **Core product idea**: Mobile “savings coach” app that reads transaction data from bank accounts (one-way only, no payments), analyzes spending, and helps young people:
  - Set and track savings goals (emergency buffer, moving out, major purchase).
  - See and understand their digital spending patterns (cards, mobile payments, BNPL, subscriptions).
  - Predict how different behaviors affect future financial security.
  - Build self-control and resistance to digital nudging and impulse buying.
- **Target users**: Finnish youth and young adults (school age to early independence), including a **neurodivergent-first design** that should still work well for neurotypical users.
- **Stakeholders**: Banks (fewer overdrafts, better long-term customer relationships) and schools (plug-in digital financial literacy module aligned with current research in Finland).

## Real vs virtual money: modes and safety

- **Technical baseline**:
  - When connected to real bank accounts (via PSD2/open banking), the app uses **read-only access** to balances and transactions.
  - The app **cannot initiate or execute payments**, so users cannot spend real money from within the app.
- **Cognitive and ethical risk**:
  - Even without payment capability, users could **confuse simulation results with real finances**, or think simulated actions changed their real account.
  - To avoid this, the app must make mode (real vs virtual) **unambiguous at all times**.

### Two clearly separated modes

- **Virtual money / simulation mode**:
  
  - Purpose: safe **resource-management-style game** using **virtual money** to practice decisions (e.g. “You earn 3 000€; allocate it across rent, food, wants, savings and see what happens.”).
  - Visual/UX:
    - Distinct theme (e.g. warm color scheme) and a persistent label such as **“SIMULATION – NOT REAL MONEY”**.
    - Optionally, mark amounts with a small “virtual” indicator (e.g. icon or “Sim €”) to reinforce the distinction.
  - Language:
    - Use verbs like **“allocate”, “simulate”, “practice”, “in this game”**.
    - Avoid language that implies real payments (“pay now”, “buy this”).
  - Flow:
    - Before starting a quest with money, show a short confirmation that this is **virtual-only** and does **not** affect the real account.

- **Real account (read-only) mode**:
  
  - Purpose: show and analyze **actual bank data** (if user connects an account) to build the Smart Spending Profile, 3-category budget, and nudges.
  - Visual/UX:
    - Different, more neutral/serious theme (e.g. blue/grey) and a clear banner like **“REAL ACCOUNT DATA (read-only)”**.
    - Show the bank name/logo near balances to anchor that this is real data.
  - Language:
    - Use verbs that refer to **past facts** only: “you spent”, “you received”, “your balance was”.
    - Avoid implying that the app can move money; when suggesting actions, phrase them as **plans** (“set a rule”, “decide”, “ask your bank app to…”).
  - Explicit safety messaging:
    - At connection time, state clearly that the app **cannot move or spend money**; it only reads data and suggests actions.

### Why this split matters (research and trust)

- Aligns with **Koskelainen et al.**:
  - They highlight ethical concerns around digital nudging, profiling, and algorithmic influence; clear mode separation and messaging increases transparency and user autonomy.
- Aligns with **Rahko & Kalmi** and **Nyrhinen et al.**:
  - Game-based and impulse-related experiments in the literature are typically run in **safe, non-monetary environments**; our simulation mode provides that.
  - Real mode still respects user control and avoids any hidden manipulation of real funds, supporting long-term trust.

## Gamification Strategies – A Characterization Using Formal Argumentation Theory

Source: [Gamification Strategies – A Characterization Using Formal Argumentation Theory](Gamification Strategies  A Characterization Using Formal Argumentation Theory.md)

### Key points from the paper

- **Two core taxonomies**:
  - **Content taxonomy (Taxonomy 1)** ([Content Typology](Gamification Strategies  A Characterization Using Formal Argumentation Theory.md#content-typology)): types of information the system can present:
    - Measuring/monitoring content (quantitative tracking, monitoring, calendars).
    - Information-based content (facts, questions, goal- / value- / emotion-targeted advice).
    - Social content (cooperative and competitive goal/value/emotion information).
  - **Strategy taxonomy (Taxonomy 2)** ([Persuasive Strategies Typology](Gamification Strategies  A Characterization Using Formal Argumentation Theory.md#persuasive-strategies-typology)): types of gamification strategies and their “agency”:
    - **Social**: avatars, simulations, stories.
    - **Proactive**: challenges, nudges.
    - **Reactive**: praise, progress, levels, leaderboards, rewards.
- **Agent perspective** ([Agent Design Background](Gamification Strategies  A Characterization Using Formal Argumentation Theory.md#agent-design-background) and [Formal Framework for Content and Strategy Selection](Gamification Strategies  A Characterization Using Formal Argumentation Theory.md#formal-framework-for-content-and-strategy-selection)):
  - Models a **persuader agent** with mental states \(G, V, E\): goals, values, emotions of the user.
  - Introduces **Algorithm 1**: given observations and a model of \(G, V, E\), generate and select hypotheses about the user’s state and choose suitable content + strategy.
  - Shows how content and strategies can be formalized as **argument-based dialogues** between persuader and persuadee.
- **Examples relevant to us**:
  - **STAR-C** ([Gamified Cards as Dialogues, the STAR-C Platform](Gamification Strategies  A Characterization Using Formal Argumentation Theory.md#gamified-cards-as-dialogues-the-star-c-platform)): mobile coaching app using cards; Algorithm 1 chooses which card/content to show.
  - **TalousTandem** ([Gamified Stories as Dialogues, Talous Tandem](Gamification Strategies  A Characterization Using Formal Argumentation Theory.md#gamified-stories-as-dialogues-talous-tandem)): financial literacy game where student life is represented as card-based stories with decision paths and multiple outcomes (finance, social, happiness, academics).

### How we use it in the app

- **User model \((G,V,E)\) (simplified)**:
  
  - We capture a lightweight version of goals, values, and emotions via onboarding and periodic questions:
    - **Goals (G)**: e.g. “build 500€ buffer”, “avoid credit card debt”, “save for moving out”.
    - **Values (V)**: e.g. “security”, “freedom”, “fun/experiences”.
    - **Emotions (E)**: e.g. “overwhelmed”, “curious”, “confident” about money.
  - We do **not** implement full formal argumentation, but we follow the same design idea:
    - Different \(G,V,E\) combinations trigger different **strategies** and **content types**.

- **Explicit use of content taxonomy**:
  
  - **Measuring content**:
    - Spending per category, time-based spending graphs, “days until money runs out at current pace”.
    - Visualizations of how much is going to subscriptions, micro-transactions, BNPL, etc.
  - **Information content**:
    - Micro-facts about digital payments, overdrafts, BNPL, robo-advisors, scams, and digital nudging.
    - Goal-targeted advice: “If your goal is to move out in 12 months, here is what this spending pattern does to that plan.”
  - **Social content** (non-competitive, low-pressure):
    - Anonymous comparative ranges: “Many people your age spend X–Y% of their income on food; you’re at Z%.”
    - Social norms framed carefully (no shaming, no public rankings).

- **Explicit use of strategy taxonomy**:
  
  - **Nudges (proactive)**:
    - Default settings like “auto-save 5–10% of income into your buffer goal” (user can always change them).
    - Highlighted “recommended” options in simulations (with transparent explanations that this is a nudge).
  - **Challenges (proactive)**:
    - Weekly challenges: “Can you keep food spending under X€ and still reserve Y€ for fun?”
    - “Impulse-free hours” or “sleep-on-it” challenges for certain categories or time windows.
  - **Progress and levels (reactive)**:
    - Progress bars for each goal; labels like “Getting started”, “Building resilience”, “Resilient”.
    - Calm achievements when users reach milestones (e.g. “first 100€ buffer”, “no overdrafts for 3 months”).
  - **Stories and simulations (social / proactive)**:
    - Short story-like scenarios (inspired by TalousTandem) tied to real spending categories:
      - Example: “You see a BNPL offer while low on cash; what do you do?” → different outcomes on cash now, future security, stress, and freedom.
    - Simple “what-if” simulations where users adjust sliders (subscriptions, food, fun) and see impact on **time-to-goal** and “safety buffer”.

- **Dialogue pattern from STAR-C and TalousTandem**:
  
  - Each “interaction” is a mini dialogue:
    - Coach presents a situation (card) → user chooses → coach responds with feedback and possibly a follow-up suggestion.
  - This aligns with the paper’s view of gamified stories as **argument-based dialogues**.

- **Research story to explain this**:
  
  - “We use Guerrero et al.’s content and strategy taxonomies and the \((G,V,E)\) user model to decide when to show measuring vs informational vs social content and when to use nudges, challenges, stories, progress, or simulations. The app behaves like a lightweight ‘persuader agent’ that adapts its coaching to the user’s goals, values, and emotional state.”

## Financial literacy in the digital age—A research agenda

Source: [Financial literacy in the digital age—A research agenda](Financial literacy in the digital age.md)

### Key points from the paper

- **Three main themes at the intersection of finance and digitalization** ([Section 5: Financial literacy on the light of the digital ecosystem](Financial literacy in the digital age.md#5--financial-literacy-on-the-light-of-the-digital-ecosystem)):
  - **Fintech** ([5.1 Fintech](Financial literacy in the digital age.md#51--fintech)):
    - Digital innovations in payments, banking, investing (e.g. mobile payments, robo-advisors, digital money, BNPL).
    - New opportunities but also new risks (fraud, misuse, data profiling, complex products).
  - **Financial behavior in digital environments** ([5.2 Financial behavior in digital environments](Financial literacy in the digital age.md#52--financial-behavior-in-digital-environments)):
    - Loss of tangibility (cards and mobile payments compared to cash) → people less aware of spending.
    - Ubiquitous digital financial management services, multi-banking, and subscriptions complicate understanding of one’s overall situation.
  - **Behavioral interventions / digital nudging** ([5.3 Behavioral interventions](Financial literacy in the digital age.md#53-behavioral-interventions)):
    - Nudging via UI and algorithms (e.g. defaults, order of options, reminders) can strongly influence financial behavior.
    - Digital nudges can help or hurt consumers; ethical concerns include transparency, profiling, and alignment with user interests.
- **Digital financial literacy needs updating** ([Section 3: Towards digital financial literacy](Financial literacy in the digital age.md#3-towards-digital-financial-literacy) and [Section 6: Discussion and conclusions](Financial literacy in the digital age.md#6--discussion-and-conclusions)):
  - Must integrate **digital literacy** (ICT, data, security) with **financial literacy**.
  - Measurement should lean toward **knowledge and problem-solving tasks**, not just self-reported behaviors.
  - Need to avoid a new digital divide between those who understand digital nudging/profiling and those who do not.
- **Emphasis on collaboration**:
  - Public sector, regulators, and private sector (banks, Fintech) should co-create tools that improve digital financial literacy and protect consumers.

### How we use it in the app

- **Three content pillars directly aligned with the three themes**:
  
  - **Fintech pillar**:
    - For each relevant product in the user’s data (card, overdraft facility, BNPL, savings account, investment account), generate:
      - Plain-language explanations of how it works and when it becomes risky.
      - Visual risk indicators (e.g. overdraft usage frequency, BNPL volume, credit card utilisation).
  - **Digital behavior pillar**:
    - Make digital spending **tangible** again:
      - Break down spending by payment type (cash, card, mobile, BNPL).
      - Highlight “invisible” or low-salience items (subscriptions, app store purchases, micro-transactions).
      - Translate digital payments into intuitive equivalents (“this week’s mobile payments would be a stack of X € coins”).
    - Show patterns where algorithms may be influencing choices (time-of-day, repeated purchases after marketing notifications, etc., as far as we can infer).
  - **Behavioral interventions pillar**:
    - Use **ethical digital nudges** (default rules, reminders, optional friction) to encourage safer behaviors.
    - Always explain that these are nudges and why they are used, addressing the ethical concerns raised in the paper.

- **Measurement approach inspired by their recommendations**:
  
  - Attach **short scenario-based questions** to key missions:
    - Before and after a mission on, for example, mobile payments, ask the user to choose between options in a realistic scenario (knowledge/problem-solving).
  - Separate **knowledge gains** (scenario answers) from **behavior changes** (actual spending and saving patterns over time).

- **Curriculum and stakeholder fit**:
  
  - For **schools**:
    - Missions can be grouped into “Fintech”, “Digital behavior”, and “Behavioral interventions” modules that mirror the research agenda and can plug into digital literacy or financial literacy courses.
  - For **banks and regulators**:
    - The app addresses concrete risks identified in the paper (over-indebtedness, fraud, profiling, digital nudging) and provides a channel to support customers’ digital financial literacy without promoting specific products.

- **Research story to explain this**:
  
  - “Following Koskelainen et al., our content is organized around three themes: Fintech, financial behavior in digital environments, and behavioral interventions. We explicitly teach about digital risks (loss of tangibility, profiling, nudging) and use problem-based tasks instead of only multiple-choice trivia to reflect digital financial literacy, while keeping behavior change grounded in the user’s real bank data.”

## Online antecedents for young consumers' impulse buying behavior

Source: [Online antecedents for young consumers' impulse buying behavior](Online antecedents for young consumers impulse buying behavior.md)

### Key points from the paper

- **Conceptual focus**:
  - Impulse buying = acting on sudden urges to purchase without prior planning and without considering long-term consequences.
  - Digital environments (online shops, social media, mobile apps) make impulse buying easier, faster, and more tempting.
- **Core mechanism studied** ([Section 2: Theoretical background and hypotheses](Online antecedents for young consumers impulse buying behavior.md#2-theoretical-background-and-hypotheses)):
  - Based on the **Theory of Planned Behavior** (TPB), but adapted to impulsive, often non-planned behaviors.
  - Key constructs:
    - **Low self-control** (behavioral control).
    - **Attitude toward targeted advertising**.
    - **Impulsiveness of social networks** (how strongly peers’ posts/recommendations push one toward buying).
    - **Impulse buying behavior**.
  - Empirical findings (young Finnish adults, 18–29):
    - Low self-control → directly increases impulse buying.
    - Low self-control → increases positive attitude toward targeted ads.
    - Low self-control → increases impulsiveness of social networks.
    - Positive attitude toward targeted ads → increases impulsiveness of social networks.
    - Both positive attitude toward targeted ads and impulsiveness of social networks → increase impulse buying.
- **Practical recommendations** ([5.2 Implications for practitioners](Online antecedents for young consumers impulse buying behavior.md#52-implications-for-practitioners)):
  - Strengthen **self-control** skills and **online media literacy** to resist persuasion.
  - Make youth aware of tracking, targeted ads, social influence, and how these relate to debt and financial strain.

### How we use it in the app

- **Risk profile based on their constructs**:
  
  - Short onboarding/periodic questions derived from their scales (or simplified versions):
    - Self-control items (e.g. difficulty in resisting impulses, acting without thinking of alternatives).
    - Attitude toward targeted advertising (e.g. finding personalized ads helpful and relevant).
    - Impulsiveness of social networks (e.g. often buying what is seen on social media).
  - From this we estimate:
    - A **self-control level**.
    - **Susceptibility to targeted ads**.
    - **Susceptibility to social network impulsiveness**.
  - This profile can be used to:
    - Determine when to show more **self-control tools** (cooling-off rules, reminders).
    - Decide how strongly to emphasize **media literacy** explanations.

- **Impulse pattern detection in spending data**:
  
  - Using the bank data, we look for patterns that likely reflect impulse buying, guided by the study’s findings:
    - Clusters of small, discretionary purchases within short time windows.
    - Late-night purchases in certain categories.
    - High frequency of purchases from obvious “impulse-prone” merchants (e.g. fast fashion, in-app purchases), individualized over time.
  - We translate these patterns into a simple “impulse radar”:
    - “In the past 30 days, approximately X% of your spending looks impulse-like; that’s about Y€ that did not go into your savings goal Z.”

- **Self-control and media-literacy tools**:
  
  - **Cooling-off rules**:
    - The user can choose time-based or category-based “cool-downs” (e.g. 24h wait before non-essential purchases).
    - The app tracks these and reflects how much money was redirected to goals due to delayed purchases.
  - **Impulse reflection cards**:
    - After detecting an apparent impulse episode, the app can (optionally) show a short reflection:
      - “Was this purchase planned?”
      - “Was it triggered by an ad or a post?”
      - “Would Future-You have preferred to put this money into your goal?”
  - **Media literacy micro-lessons**:
    - Short explanations on:
      - How behavioral targeting works and why ads feel relevant.
      - How peers’ posts and influencer content shape subjective norms and purchases.
    - These directly address the pathways identified in the paper.

- **Research story to explain this**:
  
  - “We use Nyrhinen et al.’s model of low self-control, attitudes to targeted ads, and impulsive social networks as a blueprint for our ‘impulse radar’. We estimate susceptibility using short questions and bank data, then offer concrete tools — cooling-off rules, impulse pattern feedback, and targeted media literacy lessons — that intervene on exactly the pathways their study identifies.”

### Detecting emerging impulse buying patterns over time

- **Why**:
  - Nyrhinen et al. show that impulse buying is linked to low self-control, positive attitudes toward targeted ads, and the impulsiveness of social networks.
  - Awareness is a prerequisite for change: users often do not recognize when they have slipped into a more impulsive pattern.
- **How (high-level)**:
  - Use a **rolling time window** (e.g. last 30–90 days) to compute simple indicators, such as:
    - Frequency and clustering of small discretionary transactions.
    - Late-night or “emotionally charged” category spending (e.g. food delivery, fast fashion, in-app purchases).
    - Deviation from the user’s own historical baseline (spending spikes).
  - Combine these indicators with the self-control / attitude profile to flag periods that likely reflect **heightened impulse buying** rather than isolated purchases.
  - When a threshold is crossed, trigger:
    - A **gentle, informational warning** (“Your recent spending pattern looks more impulsive than usual; want to review it together?”).
    - Adaptive content in quests and lessons (prioritizing self-control and media literacy modules).
- **Ethical considerations**:
  - The app cannot and will not block or reverse transactions; it only **analyzes and informs**.
  - Messaging should:
    - Avoid blame or alarmism.
    - Emphasize user agency and options (“here are some tools you can choose to use”) rather than directive commands.
  - This aligns with the paper’s emphasis on strengthening self-control and online media literacy, without overstepping the app’s actual powers over the user’s finances.

## The effects of game-based financial education – New survey evidence from lower-secondary school students in Finland

Source: [The effects of game-based financial education – New survey evidence from lower-secondary school students in Finland](The effects of game-based financial education New survey evidence from lower-secondary school students in Finland.md)

### Key points from the paper

- **Study design** ([Abstract](The effects of game-based financial education New survey evidence from lower-secondary school students in Finland.md#abstract) and methods sections):
  - Sample: 640 lower-secondary students from 42 schools in Finland.
  - Compared **three game-based interventions** (different games / delivery modes) to traditional teaching.
  - Measured pre- and post-intervention **knowledge** and **self-reported financial behaviors**.
- **Findings** ([Results](The effects of game-based financial education New survey evidence from lower-secondary school students in Finland.md#results)):
  - Game-based approaches produced **robust improvements in financial knowledge** compared to traditional teaching.
  - Effects on **self-reported behaviors** were weak.
  - Likely explanation: lower-secondary students have limited control over real financial decisions, so behavior changes are constrained even when knowledge improves.
- **Contextual notes**:
  - Fits into broader literature: financial education tends to have stronger effects on knowledge than on behavior.
  - Game-based / active learning methods show promise for engagement and knowledge, but behavior change requires more than classroom games alone.

### How we use it in the app

- **Realistic expectations from gamification**:
  
  - We treat **game-like elements primarily as knowledge and awareness tools**, not as magic behavior-change levers.
  - We design short missions and simulations to:
    - Explain trade-offs (e.g. spending vs saving, BNPL vs waiting).
    - Build mental models of money flows.

- **Critical twist: connecting missions to real actions**:
  
  - Unlike school-based interventions, the app sees **real transactions** and can propose immediate, concrete actions after each mission:
    - After a mission on emergency funds: suggest starting or adjusting a real savings rule in the connected bank.
    - After a mission on subscriptions: list actual low-use subscriptions and help the user plan which to cancel.
  - This aims to bridge the **knowledge → behavior** gap highlighted in the paper:
    - Knowledge is boosted by the mission.
    - Opportunity and support for action come from the integration with real bank data and nudges.

- **Designing for school integration**:
  
  - For school use, the app’s missions can be chosen as:
    - Short, classroom-friendly tasks that demonstrate key concepts.
    - Followed by homework-style actions where students plan, simulate, or track real behavior (within constraints appropriate for their age).
  - The research provides local (Finnish) evidence that **game-based formats are credible** for schools, as long as expectations around behavior change are realistic.

- **Research story to explain this**:
  
  - “Rahko and Kalmi show that game-based financial education in Finnish lower-secondary schools reliably improves financial knowledge but has limited short-term impact on behavior. Our design respects this: we use missions and simulations to build understanding, then tie them directly to real transaction data and concrete follow-up actions, so that increased knowledge has an immediate channel for behavior change.”

## PISA 2022 context and implications for design

### Relevant PISA 2022 findings (as summarized)

- **Mathematical literacy**:
  - Finnish average declined from 548 (2006) to 484 (2022) but remains above the OECD average (472).
  - More low performers, fewer top performers; about one in four students below Level 2 in math.
- **Reading and scientific literacy**:
  - Both declined but remain above OECD averages.
- **Creative thinking (new domain)**:
  - Finnish 15-year-olds scored high, clearly above OECD average.
  - Nearly half of girls excelled; boys close to OECD average.

### How we reflect this in the app

- **Low dependence on strong math skills**:
  
  - Avoid heavy numeric tasks and complex formulas in the UI.
  - Prefer:
    - Simple visualizations (bars, timelines, “time-to-goal” rather than compound-interest math).
    - Intuitive comparisons (e.g. “two extra weeks of safety” instead of “+3.7% return”).

- **High leverage of creative thinking ability**:
  
  - Treat missions as **creative planning and scenario design**, not calculation drills:
    - “Design a monthly plan that lets you buy X and still save Y for your buffer.”
    - “Re-balance this budget so Future-You is safer without removing all fun.”
  - Let users **co-design their own nudges**:
    - Writing their own reminder messages.
    - Choosing how strict or gentle the nudges should be.

- **Gender- and inclusion-aware framing**:
  
  - For many girls (who score high in creative thinking but may be less confident in finance), emphasize:
    - Self-efficacy, narrative explanations, and ownership over plans.
  - For many boys (where risk awareness is a concern), emphasize:
    - Risk simulations and clear consequences of high-risk behaviors (e.g. overuse of BNPL or credit).
  - For neurodivergent youth, emphasize:
    - Predictable flows, low sensory load, and user control over pacing and interface complexity.

## Neurodivergent-first design (cross-cutting)

- **Low cognitive load**:
  - One main decision per screen; consistent layout (situation → options → impacts → explanation).
  - Ability to hide non-essential details in “focus mode”.
- **Multiple representation modes**:
  - Explanations available in:
    - Bullet-point summaries.
    - Short stories.
    - Step-by-step instructions.
- **Sensory-friendly options**:
  - “Low stimulation mode”: calm colors, minimal animations, no sound by default.
- **User control and pacing**:
  - User chooses mission order, pace, and depth of explanations.
  - Nudges are opt-in/adjustable and always explained transparently.

These principles are consistent with the impulse-buying and digital-nudging research (reducing overload and high-pressure cues) while making the app more inclusive and robust for the whole population.
