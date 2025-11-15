import 'package:flutter/material.dart';

class BudgetQuizPage extends StatefulWidget {
  @override
  State<BudgetQuizPage> createState() => _BudgetQuizPageState();
}

class _BudgetQuizPageState extends State<BudgetQuizPage> {
  final Color backgroundBlue = const Color(0xFF0D1B2A);
  final Color accent = const Color(0xFF3A9C9F);

  final List<_Question> _questions = const [
    _Question(
      text: 'In the 50/30/20 rule, which category should be 20%?',
      options: ['Wants', 'Savings/Debt', 'Needs'],
      correctIndex: 1,
    ),
    _Question(
      text: 'A good first emergency fund target is:',
      options: ['€50', '1 month of expenses', '12 months of rent'],
      correctIndex: 1,
    ),
    _Question(
      text: 'Which is a “variable cost” you can trim first?',
      options: ['Rent', 'Phone plan', 'Eating out'],
      correctIndex: 2,
    ),
  ];

  int _current = 0;
  int _score = 0;
  bool _finished = false;

  void _selectAnswer(int idx) {
    if (_finished) return;
    final isCorrect = idx == _questions[_current].correctIndex;
    if (isCorrect) _score++;
    if (_current == _questions.length - 1) {
      setState(() => _finished = true);
    } else {
      setState(() => _current++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: accent,
        title: const Text('Budgeting 101 - Quiz'),
        foregroundColor: Colors.white,
      ),
      backgroundColor: backgroundBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: _finished ? _buildResult() : _buildQuestion(),
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    final q = _questions[_current];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: (_current + 1) / _questions.length,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(accent),
                minHeight: 8,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${_current + 1}/${_questions.length}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          q.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(q.options.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white24),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _selectAnswer(i),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(q.options[i]),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildResult() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              _score >= 2 ? Icons.emoji_events : Icons.insights,
              size: 64,
              color: accent,
            ),
            const SizedBox(height: 16),
            Text(
              'Score: $_score / ${_questions.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _score == 3
                  ? 'Perfect understanding!'
                  : (_score == 2 ? 'Good job! Revisit the notes to perfect it.' : 'Review the course and try again.'),
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.check),
              label: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Question {
  final String text;
  final List<String> options;
  final int correctIndex;
  const _Question({
    required this.text,
    required this.options,
    required this.correctIndex,
  });
}


