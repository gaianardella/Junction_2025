import 'package:flutter/material.dart';
import 'widgets/avatar_widget.dart';

class SpendingSandboxPage extends StatefulWidget {
  @override
  State<SpendingSandboxPage> createState() => _SpendingSandboxPageState();
}

class _SpendingSandboxPageState extends State<SpendingSandboxPage> {
  final Color backgroundBlue = const Color(0xFF0D1B2A);
  final Color accent = const Color(0xFF3A9C9F);
  final Color success = const Color(0xFF43A047);
  final Color warning = const Color(0xFFE53935);

  final TextEditingController _salaryCtrl = TextEditingController(text: '2200');
  final TextEditingController _otherIncomeCtrl = TextEditingController(text: '0');
  final TextEditingController _rentCtrl = TextEditingController(text: '850');
  final TextEditingController _foodCtrl = TextEditingController(text: '320');
  final TextEditingController _transportCtrl = TextEditingController(text: '70');
  final TextEditingController _subscriptionsCtrl = TextEditingController(text: '85');
  final TextEditingController _otherCtrl = TextEditingController(text: '200');

  // Goal allocations (per month)
  final TextEditingController _gamingAllocCtrl = TextEditingController(text: '150');
  final TextEditingController _tripAllocCtrl = TextEditingController(text: '200');

  // Example goal targets and current progress (aligned with Home)
  final double _gamingTarget = 1500;
  final double _tripTarget = 2000;
  final double _gamingCurrent = 0.35 * 1500; // 35%
  final double _tripCurrent = 0.60 * 2000; // 60%

  bool _incomeExpanded = true;
  bool _spendingExpanded = true;
  double? _computedBalance;

  final List<_SandboxGoal> _goals = [
    _SandboxGoal(
      title: 'Gaming PC',
      target: 1500,
      current: 0.35 * 1500,
      color: const Color(0xFF6A1B9A),
    ),
    _SandboxGoal(
      title: 'Europe Trip',
      target: 2000,
      current: 0.60 * 2000,
      color: const Color(0xFF0288D1),
    ),
  ];

  num _num(TextEditingController c) {
    final v = double.tryParse(c.text.replaceAll(',', '.')) ?? 0.0;
    return v < 0 ? 0 : v;
  }

  @override
  Widget build(BuildContext context) {
    final double salary = _num(_salaryCtrl).toDouble();
    final double otherIncome = _num(_otherIncomeCtrl).toDouble();
    final double rent = _num(_rentCtrl).toDouble();
    final double food = _num(_foodCtrl).toDouble();
    final double transport = _num(_transportCtrl).toDouble();
    final double subs = _num(_subscriptionsCtrl).toDouble();
    final double other = _num(_otherCtrl).toDouble();
    final double totalExpenses = rent + food + transport + subs + other;
    final double remaining = (salary + otherIncome) - totalExpenses;

    final double allocGaming = _num(_gamingAllocCtrl).toDouble();
    final double allocTrip = _num(_tripAllocCtrl).toDouble();

    final bool allocationsFit = (allocGaming + allocTrip) <= (remaining > 0 ? remaining : 0);

    final _GoalCalc gaming = _calcGoal(
      name: 'Gaming PC',
      target: _gamingTarget,
      current: _gamingCurrent,
      monthly: allocationsFit ? allocGaming : 0,
    );
    final _GoalCalc trip = _calcGoal(
      name: 'Europe Trip',
      target: _tripTarget,
      current: _tripCurrent,
      monthly: allocationsFit ? allocTrip : 0,
    );

    return Scaffold(
      backgroundColor: backgroundBlue,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Spending Simulator',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AvatarWidget(size: 44),
                  ],
                ),
              ),
            _slideIn(index: 0, child: _buildGoalsStrip()),
            SizedBox(height: 12),
            _slideIn(index: 1, child: _buildBalanceCard()),
            SizedBox(height: 16),

            _sectionTitle('Your Monthly Income'),
            _slideIn(
              index: 2,
              child: _collapsibleTile(
                title: 'Income',
                expanded: _incomeExpanded,
                onToggle: () => setState(() => _incomeExpanded = !_incomeExpanded),
                tintColor: success,
                child: Column(
                  children: [
                    _numberField(controller: _salaryCtrl, label: 'Net salary (€)', icon: Icons.payments, iconColor: success, focusBorderColor: success),
                    _numberField(controller: _otherIncomeCtrl, label: 'Other income (€)', icon: Icons.savings, iconColor: success, focusBorderColor: success),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),

            _sectionTitle('Your Monthly Expenses'),
            _slideIn(
              index: 3,
              child: _collapsibleTile(
                title: 'Spending',
                expanded: _spendingExpanded,
                onToggle: () => setState(() => _spendingExpanded = !_spendingExpanded),
                tintColor: warning,
                child: Column(
                  children: [
                    _numberField(controller: _rentCtrl, label: 'Rent (€)', icon: Icons.home, iconColor: warning, focusBorderColor: warning),
                    _numberField(controller: _foodCtrl, label: 'Food (€)', icon: Icons.restaurant, iconColor: warning, focusBorderColor: warning),
                    _numberField(controller: _transportCtrl, label: 'Transport (€)', icon: Icons.directions_bus, iconColor: warning, focusBorderColor: warning),
                    _numberField(controller: _subscriptionsCtrl, label: 'Subscriptions (€)', icon: Icons.subscriptions, iconColor: warning, focusBorderColor: warning),
                    _numberField(controller: _otherCtrl, label: 'Other (€)', icon: Icons.category, iconColor: warning, focusBorderColor: warning),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),

            _slideIn(
              index: 4,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                      FocusScope.of(context).unfocus();
                    final double incomes = salary + otherIncome;
                    final double spend = totalExpenses;
                    setState(() {
                      _computedBalance = incomes - spend;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accent, accent.withOpacity(0.85)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.35),
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calculate, size: 20, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Calculate Balance',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalsStrip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Goals', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            Spacer(),
            TextButton.icon(
              onPressed: _openAddGoalDialog,
              icon: Icon(Icons.add, color: accent, size: 18),
              label: Text('Add goal', style: TextStyle(color: accent)),
              style: TextButton.styleFrom(foregroundColor: accent),
            ),
          ],
        ),
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _goals.length,
            separatorBuilder: (_, __) => SizedBox(width: 10),
            itemBuilder: (context, i) {
              final g = _goals[i];
              final double progress = (g.current / g.target).clamp(0, 1);
              return Container(
                width: 180,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [g.color.withOpacity(0.16), Colors.transparent],
                  ),
                  color: g.color.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: g.color.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            g.title,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text('${(progress * 100).toStringAsFixed(0)}%', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                    SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(g.color),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text('€${g.current.toStringAsFixed(0)} / €${g.target.toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openAddGoalDialog() {
    final titleCtrl = TextEditingController();
    final targetCtrl = TextEditingController();
    final currentCtrl = TextEditingController();
    Color color = accent;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundBlue,
          title: Text('Add Goal', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogField(titleCtrl, 'Title', Icons.flag),
                _dialogField(targetCtrl, 'Target (€)', Icons.attach_money, keyboard: TextInputType.number),
                _dialogField(currentCtrl, 'Current (€)', Icons.savings, keyboard: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: Colors.white70))),
            ElevatedButton(
              onPressed: () {
                final t = titleCtrl.text.trim().isEmpty ? 'New Goal' : titleCtrl.text.trim();
                final target = double.tryParse(targetCtrl.text.replaceAll(',', '.')) ?? 0;
                final current = double.tryParse(currentCtrl.text.replaceAll(',', '.')) ?? 0;
                setState(() {
                  _goals.add(_SandboxGoal(title: t, target: target, current: current, color: color));
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: Colors.white),
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _dialogField(TextEditingController c, String label, IconData icon, {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: keyboard,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.06),
          prefixIcon: Icon(icon, color: accent),
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: accent),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    final double value = _computedBalance ?? 0;
    final bool hasValue = _computedBalance != null;
    final Color color = !hasValue ? Colors.white70 : (value >= 0 ? success : warning);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet, color: color),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Final Balance', style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  hasValue ? '€${value.toStringAsFixed(0)}' : '€0',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 22),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _collapsibleTile({
    required String title,
    required bool expanded,
    required VoidCallback onToggle,
    required Widget child,
    Color? tintColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: tintColor != null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [tintColor.withOpacity(0.16), Colors.transparent],
              )
            : null,
        color: tintColor != null ? tintColor.withOpacity(0.06) : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: (tintColor ?? Colors.white).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Icon(expanded ? Icons.expand_less : Icons.expand_more, color: (tintColor ?? Colors.white70)),
                  SizedBox(width: 8),
                  Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: child,
            ),
            crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  // Final balance is calculated via the "Calculate Balance" button; no manual edit.
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _numberField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    Color? iconColor,
    Color? focusBorderColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (_) => setState(() {}),
        style: TextStyle(color: Colors.white),
        cursorColor: focusBorderColor ?? accent,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.06),
          prefixIcon: Icon(icon, color: iconColor ?? accent),
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: focusBorderColor ?? accent),
          ),
        ),
      ),
    );
  }

  Widget _metricCard({required String title, required String value, required Color color, String? subtitle}) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.18), shape: BoxShape.circle),
            child: Icon(color == warning ? Icons.error_outline : Icons.account_balance_wallet, color: color),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 4),
                Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                if (subtitle != null) ...[
                  SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.white60, fontSize: 12)),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _warningBanner(String text) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: warning.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: warning.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined, color: warning),
          SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _goalImpactCard(_GoalCalc calc, {required Color color}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.16), Colors.transparent],
        ),
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.18)),
            child: Icon(Icons.flag, color: color),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        calc.name,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Target €${calc.target.toStringAsFixed(0)}',
                          style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  calc.monthly <= 0
                      ? 'No monthly allocation set.'
                      : 'Monthly allocation: €${calc.monthly.toStringAsFixed(0)}',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Saved: €${calc.current.toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    Text('Remaining: €${(calc.target - calc.current).clamp(0, calc.target).toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (calc.current / calc.target).clamp(0, 1),
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                SizedBox(height: 8),
                Text(
                  calc.months <= 0 ? 'Already funded or no plan set.' : 'Estimated time: ${calc.months} months',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _GoalCalc _calcGoal({
    required String name,
    required double target,
    required double current,
    required double monthly,
  }) {
    if (monthly <= 0) {
      return _GoalCalc(name, target, current, monthly, 0);
    }
    final remaining = (target - current).clamp(0, target);
    final months = remaining <= 0 ? 0 : (remaining / monthly).ceil();
    return _GoalCalc(name, target, current, monthly, months);
  }
}

class _SandboxGoal {
  final String title;
  final double target;
  final double current;
  final Color color;
  _SandboxGoal({
    required this.title,
    required this.target,
    required this.current,
    required this.color,
  });
}

class _GoalCalc {
  final String name;
  final double target;
  final double current;
  final double monthly;
  final int months;
  _GoalCalc(this.name, this.target, this.current, this.monthly, this.months);
}

Widget _slideIn({required int index, required Widget child}) {
  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.0, end: 1.0),
    duration: Duration(milliseconds: 400 + (index * 100)),
    curve: Curves.easeInOut,
    builder: (context, value, c) {
      return Transform.translate(
        offset: Offset(20 * (1 - value), 0),
        child: Opacity(
          opacity: value,
          child: c,
        ),
      );
    },
    child: child,
  );
}


