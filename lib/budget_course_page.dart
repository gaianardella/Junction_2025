import 'package:flutter/material.dart';
import 'budget_quiz_page.dart';

class BudgetCoursePage extends StatelessWidget {
  final Color backgroundBlue = const Color(0xFF0D1B2A);
  final Color accent = const Color(0xFF3A9C9F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlue,
      appBar: AppBar(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        title: const Text('Budgeting 101'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title('Why a Budget Matters'),
              _para(
                  'A budget is a plan for your money. It lets you decide in advance where your euros go, '
                  'reduces stress, and helps you reach goals like an emergency fund or a trip.'),
              const SizedBox(height: 16),
              _title('50/30/20 Framework'),
              _bullet('50% Needs: rent, groceries, transport, insurance.'),
              _bullet('30% Wants: eating out, subscriptions, hobbies.'),
              _bullet('20% Savings/Debt: emergency fund, investments, debt repayments.'),
              _note('You can tweak the ratios, but keep a consistent savings share.'),
              const SizedBox(height: 16),
              _title('Track and Review Weekly'),
              _bullet('Log your expenses (app/spreadsheet).'),
              _bullet('Categorize by Needs/Wants/Savings.'),
              _bullet('Do a 10-minute weekly check: adjust next week if you overspent.'),
              const SizedBox(height: 16),
              _title('Emergency Fund'),
              _para(
                  'Aim for at least 1 month of expenses to start, then build towards 3–6 months. '
                  'Automate transfers on payday so you “pay yourself first”.'),
              const SizedBox(height: 16),
              _title('Fixed vs Variable Costs'),
              _bullet('Fixed: rent, phone plan, pass HSL.'),
              _bullet('Variable: eating out, shopping, entertainment.'),
              _note('Focus on lowering variable costs first; then renegotiate fixed costs.'),
              const SizedBox(height: 16),
              _title('Sinking Funds'),
              _para(
                  'Set aside a small amount monthly for upcoming expenses (e.g., winter jacket, gifts, travel). '
                  'This avoids last-minute debt.'),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => BudgetQuizPage()),
                    );
                  },
                  icon: const Icon(Icons.quiz),
                  label: const Text('Start quiz (3 questions)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(String text) => Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      );

  Widget _para(String text) => Text(
        text,
        style: const TextStyle(color: Colors.white70, height: 1.35),
      );

  Widget _bullet(String text) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.white70)),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white70, height: 1.35)),
          ),
        ],
      );

  Widget _note(String text) => Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white70, size: 16),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: const TextStyle(color: Colors.white70))),
          ],
        ),
      );
}


