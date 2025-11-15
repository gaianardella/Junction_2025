import 'package:flutter/material.dart';

class MonthlyChallengePage extends StatefulWidget {
  @override
  State<MonthlyChallengePage> createState() => _MonthlyChallengePageState();
}

class _MonthlyChallengePageState extends State<MonthlyChallengePage> {
  final Color backgroundBlue = const Color(0xFF0D1B2A);
  final Color accent = const Color(0xFF3A9C9F);
  int step = 0;
  double cash = 1200; // starting cash
  double debt = 0; // starting debt
  String outcome = '';
  int points = 0;

  final List<_StoryStep> steps = [
    _StoryStep(
      text:
          'You are Maya, 24, a junior UX designer who just moved to Helsinki for a new job near Ruoholahti. '
          'You rent a small studio in Kallio. Your first palkka (paycheck) just arrived after paying the deposit last month. '
          'The studio still needs basics (table, lamp, storage). How do you start the month?',
      choices: [
        _Choice(label: 'Set aside €300 for an emergency fund', deltaCash: 300, deltaDebt: 0),
        _Choice(label: 'Furnish studio with “osamaksu” (pay later) plan', deltaCash: 0, deltaDebt: 250),
        _Choice(label: 'Take a weekend train to Turku to unwind (€180)', deltaCash: -180, deltaDebt: 0),
      ],
    ),
    _StoryStep(
      text:
          'Daily commute decision. From Kallio to Ruoholahti you need to cross AB zones twice a day. '
          'Your team meets in the office 3 days a week and you visit friends in Pasila or Vallila after work.',
      choices: [
        _Choice(label: 'Buy HSL AB monthly pass (€70) now', deltaCash: -70, deltaDebt: 0),
        _Choice(label: 'Use e-scooters & rideshares (budget €120)', deltaCash: -120, deltaDebt: 0),
        _Choice(label: 'Buy a used Jopo bike once (€160)', deltaCash: -160, deltaDebt: 0),
      ],
    ),
    _StoryStep(
      text:
          'Moving costs left a lingering credit card balance at 19.9% interest. '
          'Nordea calls and offers options; at the same time you are curious about starting to invest.',
      choices: [
        _Choice(label: 'Pay €200 now to cut expensive interest', deltaCash: -200, deltaDebt: -200),
        _Choice(label: 'Pay minimum (€40) and invest €160 in a broad ETF', deltaCash: 160, deltaDebt: 40),
        _Choice(label: 'Ignore this month (no payment)', deltaCash: 0, deltaDebt: 0),
      ],
    ),
    _StoryStep(
      text:
          'It’s Wednesday 12:25. You have sprint review at 13:00 and your HSL card is low. '
          'You are starving in Sörnäinen metro hall and you still need a quick top‑up before the train.',
      choices: [
        _Choice(label: 'R‑kioski: korvapuusti + energy drink (€8)', deltaCash: -8, deltaDebt: 0),
        _Choice(label: 'K‑Market: ready salad + water (€7)', deltaCash: -7, deltaDebt: 0),
        _Choice(label: 'S‑market: ingredients for 3 lunches (€12)', deltaCash: -12, deltaDebt: 0),
      ],
    ),
    _StoryStep(
      text:
          'Weekend: friend’s tupaantuliaiset (housewarming) in Lauttasaari. '
          'Autumn rain starts and your light jacket isn’t enough. You also need to bring something.',
      choices: [
        _Choice(label: 'Alko: Finnish craft beers (€24)', deltaCash: -24, deltaDebt: 0),
        _Choice(label: 'Make homemade lemonade (bring a bottle, €0)', deltaCash: 0, deltaDebt: 0),
        _Choice(label: 'Find a used winter jacket on Tori.fi (€60)', deltaCash: -60, deltaDebt: 0),
      ],
    ),
  ];

  void _choose(_Choice choice) {
    setState(() {
      cash += choice.deltaCash;
      debt += choice.deltaDebt;
      if (step < steps.length - 1) {
        step++;
      } else {
        final netWorth = cash - debt;
        outcome = _classifyOutcome(netWorth);
        points = _pointsForNetWorth(netWorth);
      }
    });
  }

  String _classifyOutcome(double netWorth) {
    if (netWorth >= 2000) return 'Rich: strong surplus and low liabilities. Great job!';
    if (netWorth >= 1000) return 'Comfortable: solid buffer for rainy days.';
    if (netWorth >= 0) return 'Balanced: you made it through the month, keep pushing!';
    if (netWorth >= -300) return 'Strained: some debt pressure. Revisit spending.';
    return 'Poor: heavy liabilities. Build an emergency fund and cut costs.';
  }

  int _pointsForNetWorth(double netWorth) {
    if (netWorth >= 2000) return 120;
    if (netWorth >= 1000) return 80;
    if (netWorth >= 0) return 50;
    if (netWorth >= -300) return 20;
    return 5;
  }

  @override
  Widget build(BuildContext context) {
    final bool finished = step >= steps.length - 1 && outcome.isNotEmpty;
    return Scaffold(
      backgroundColor: backgroundBlue,
      appBar: AppBar(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        title: Text('Monthly Challenge'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: finished ? _buildResult() : _buildStory(),
      ),
    );
  }

  Widget _buildStory() {
    final current = steps[step];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(
          value: (step + 1) / steps.length,
          backgroundColor: Colors.white24,
          valueColor: AlwaysStoppedAnimation<Color>(accent),
          minHeight: 8,
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white12),
          ),
          child: Text(
            current.text,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: 16),
        // Avatar centered with money/debt sides
        _buildAvatarWithStats(),
        SizedBox(height: 16),
        ...current.choices.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.08),
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white24),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _choose(c),
            child: Align(alignment: Alignment.centerLeft, child: Text(c.label)),
          ),
        )),
      ],
    );
  }

  Widget _buildAvatarWithStats() {
    return Row(
      children: [
        // Money (left)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildStatChip(
                label: 'Cash',
                value: '€${cash.toStringAsFixed(0)}',
                color: Colors.greenAccent.withOpacity(0.7),
                icon: Icons.savings_outlined,
                alignRight: true,
              ),
              SizedBox(height: 8),
              _buildStatChip(
                label: 'Net worth',
                value: '€${(cash - debt).toStringAsFixed(0)}',
                color: accent.withOpacity(0.7),
                icon: Icons.trending_up,
                alignRight: true,
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        // Avatar center
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.08),
            border: Border.all(color: Colors.white24),
          ),
          child: ClipOval(
            child: Image.asset('assets/avatar_profile.png', fit: BoxFit.cover),
          ),
        ),
        SizedBox(width: 16),
        // Debt (right)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatChip(
                label: 'Debt',
                value: '€${debt.toStringAsFixed(0)}',
                color: Colors.redAccent.withOpacity(0.7),
                icon: Icons.credit_card,
              ),
              SizedBox(height: 8),
              Builder(
                builder: (_) {
                  final _EmotionStatus em = _emotionForCash(cash);
                  return _buildStatChip(
                    label: 'Emotion',
                    value: em.label,
                    color: em.color,
                    icon: em.icon,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
    bool alignRight = false,
  }) {
    return Align(
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.6)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: Colors.white),
              SizedBox(width: 6),
              Text(label, style: TextStyle(color: Colors.white70, fontSize: 11)),
              SizedBox(width: 8),
              Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResult() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon((cash - debt) >= 1000 ? Icons.emoji_events : Icons.lightbulb, color: accent, size: 56),
            SizedBox(height: 12),
            Text('Outcome', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            Text(outcome, style: TextStyle(color: Colors.white70), textAlign: TextAlign.center),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.stars, color: accent),
                SizedBox(width: 8),
                Text(
                  'Points: $points',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildStatChip(label: 'Cash', value: '€${cash.toStringAsFixed(0)}', color: Colors.greenAccent.withOpacity(0.7), icon: Icons.savings_outlined),
                _buildStatChip(label: 'Debt', value: '€${debt.toStringAsFixed(0)}', color: Colors.redAccent.withOpacity(0.7), icon: Icons.credit_card),
              ],
            ),
            SizedBox(height: 10),
            Text('Net worth: €${(cash - debt).toStringAsFixed(0)}', style: TextStyle(color: Colors.white)),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Back to Scoreboard'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryStep {
  final String text;
  final List<_Choice> choices;
  const _StoryStep({required this.text, required this.choices});
}

class _Choice {
  final String label;
  final double deltaCash;
  final double deltaDebt;
  const _Choice({required this.label, required this.deltaCash, required this.deltaDebt});
}

class _EmotionStatus {
  final String label;
  final Color color;
  final IconData icon;
  const _EmotionStatus(this.label, this.color, this.icon);
}

_EmotionStatus _emotionForNetWorth(double netWorth) {
  if (netWorth >= 2000) {
    return _EmotionStatus('Ecstatic', Colors.green, Icons.sentiment_very_satisfied);
  } else if (netWorth >= 1000) {
    return _EmotionStatus('Happy', Colors.lightGreen, Icons.sentiment_satisfied_alt);
  } else if (netWorth >= 0) {
    return _EmotionStatus('Calm', Colors.tealAccent.shade700, Icons.sentiment_satisfied);
  } else if (netWorth >= -300) {
    return _EmotionStatus('Anxious', Colors.amber, Icons.sentiment_neutral);
  } else {
    return _EmotionStatus('Stressed', Colors.redAccent, Icons.sentiment_very_dissatisfied);
  }
}

_EmotionStatus _emotionForCash(double cash) {
  if (cash >= 2000) {
    return _EmotionStatus('Ecstatic', Colors.green, Icons.sentiment_very_satisfied);
  } else if (cash >= 1200) {
    return _EmotionStatus('Happy', Colors.lightGreen, Icons.sentiment_satisfied_alt);
  } else if (cash >= 600) {
    return _EmotionStatus('Calm', Colors.tealAccent.shade700, Icons.sentiment_satisfied);
  } else if (cash >= 0) {
    return _EmotionStatus('Anxious', Colors.amber, Icons.sentiment_neutral);
  } else {
    return _EmotionStatus('Stressed', Colors.redAccent, Icons.sentiment_very_dissatisfied);
  }
}


