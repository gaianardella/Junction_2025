import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Color primaryBlue = const Color(0xFF1E88E5);
  final Color accentOrange = const Color(0xFFFF6D00);

  final List<_Question> _questions = const [
    _Question(
      text: 'What is the first step to a good budget?',
      options: [
        'Invest everything immediately',
        'Track income and expenses',
        'Use only cash',
      ],
      correctIndex: 1,
    ),
    _Question(
      text: 'Which is a common saving rule?',
      options: [
        '80/10/10',
        '50/30/20',
        '10/10/80',
      ],
      correctIndex: 1,
    ),
    _Question(
      text: 'What is an emergency fund?',
      options: [
        'A quick loan',
        'Savings for unexpected expenses',
        'A vacation account',
      ],
      correctIndex: 1,
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
        backgroundColor: accentOrange,
        title: const Text('Budgeting 101 - Quiz'),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Color(0xFF123B7A),
      body: SafeArea(
        child: _finished
            ? _buildResult()
            : Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: _buildQuestion(),
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
                valueColor: AlwaysStoppedAnimation<Color>(accentOrange),
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
                side: BorderSide(color: Colors.white24),
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
          color: accentOrange,
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
              ? 'Perfect! Great budgeting mastery.'
              : (_score == 2 ? 'Well done! You are on the right track.' : 'No worries, try again!'),
          style: const TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentOrange,
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


