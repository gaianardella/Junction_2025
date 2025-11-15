import 'package:flutter/material.dart';

class MonthlyChallengePage extends StatefulWidget {
  @override
  State<MonthlyChallengePage> createState() => _MonthlyChallengePageState();
}

class _MonthlyChallengePageState extends State<MonthlyChallengePage> {
  final Color backgroundBlue = const Color(0xFF0D1B2A);
  final Color accent = const Color(0xFF3A9C9F);
  int step = 0;
  int score = 0;
  String outcome = '';

  final List<_StoryStep> steps = [
    _StoryStep(
      text: 'You see a flash sale for headphones you don’t really need. Do you buy?',
      choices: [
        _Choice(label: 'Buy now - 40% off!', delta: -1),
        _Choice(label: 'Skip - stick to budget', delta: 1),
      ],
    ),
    _StoryStep(
      text: 'Your friend invites you to an expensive dinner. What do you do?',
      choices: [
        _Choice(label: 'Join, I’ll pay with credit', delta: -1),
        _Choice(label: 'Suggest a cheaper alternative', delta: 1),
      ],
    ),
    _StoryStep(
      text: 'You received a bonus. Where does it go?',
      choices: [
        _Choice(label: 'New gadget', delta: -1),
        _Choice(label: 'Emergency fund', delta: 1),
      ],
    ),
  ];

  void _choose(_Choice choice) {
    setState(() {
      score += choice.delta;
      if (step < steps.length - 1) {
        step++;
      } else {
        if (score >= 2) {
          outcome = 'Great choices! You stayed disciplined and improved your finances.';
        } else if (score == 1) {
          outcome = 'Not bad! A couple of good choices — keep building good habits.';
        } else {
          outcome = 'Tough month. Reflect and plan to avoid impulse spending next time.';
        }
      }
    });
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
            Icon(score >= 2 ? Icons.emoji_events : Icons.lightbulb, color: accent, size: 56),
            SizedBox(height: 12),
            Text('Outcome', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            Text(outcome, style: TextStyle(color: Colors.white70), textAlign: TextAlign.center),
            SizedBox(height: 16),
            Text('Score: $score / ${steps.length}', style: TextStyle(color: Colors.white)),
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
  final int delta;
  const _Choice({required this.label, required this.delta});
}


