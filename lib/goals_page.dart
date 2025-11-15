import 'package:flutter/material.dart';
import 'widgets/avatar_widget.dart';

// --- Theme Colors ---
final Color primaryBlue = Color(0xFF00468C);
final Color accentOrange = Color(0xFF3A9C9F);
final Color lightBlue = Color(0xFFE3F2FD);
final Color softOrange = Color(0xFFFFF3E0);
final Color successGreen = Color(0xFF4CAF50);
final Color purpleAccent = Color(0xFF9C27B0);

// --- Data Models ---
class SavingsGoal {
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final double interestRate;
  final String emojiLevel;
  final Color? customColor;

  SavingsGoal({
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.interestRate,
    required this.emojiLevel,
    this.customColor,
  });

  int get daysRemaining => targetDate.difference(DateTime.now()).inDays;

  double get weeklyDepositNeeded {
    if (daysRemaining <= 0) {
      return targetAmount - currentAmount > 0
          ? (targetAmount - currentAmount)
          : 0.0;
    }
    int weeks = (daysRemaining / 7).ceil();
    return (targetAmount - currentAmount) / weeks;
  }

  double get progressPercentage =>
      (currentAmount / targetAmount * 100).clamp(0, 100);
}

// --- Goals Page ---
class GoalsPage extends StatefulWidget {
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> with TickerProviderStateMixin {
  final List<SavingsGoal> userGoals = [
    SavingsGoal(
      name: 'Gaming PC',
      targetAmount: 1800.0,
      currentAmount: 450.0,
      targetDate: DateTime.now().add(Duration(days: 365)),
      interestRate: 2.5,
      emojiLevel: '🎮',
      customColor: Color(0xFF6A1B9A),
    ),
    SavingsGoal(
      name: 'Europe Trip',
      targetAmount: 3000.0,
      currentAmount: 150.0,
      targetDate: DateTime.now().add(Duration(days: 540)),
      interestRate: 3.0,
      emojiLevel: '✈️',
      customColor: Color(0xFF0288D1),
    ),
  ];

  int _currentGoalIndex = 0;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1B2A),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            toolbarHeight: 72,
            collapsedHeight: 72,
            backgroundColor: primaryBlue,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryBlue, primaryBlue.withOpacity(0.8)],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Your Goals',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Track & Achieve 🎯',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          AvatarWidget(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20),

                // Stats Overview Cards
                _buildStatsOverview(),

                SizedBox(height: 24),

                // Main Goal Carousel
                _buildCurrentGoalSection(context),

                SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildAnimatedFAB(),
    );
  }

  Widget _buildStatsOverview() {
    double totalSaved = userGoals.fold(
      0,
      (sum, goal) => sum + goal.currentAmount,
    );
    double totalTarget = userGoals.fold(
      0,
      (sum, goal) => sum + goal.targetAmount,
    );
    int activeGoals = userGoals.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              '€${totalSaved.toStringAsFixed(0)}',
              'Total Saved',
              Icons.savings_outlined,
              successGreen,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _buildStatCard(
              '$activeGoals',
              'Active Goals',
              Icons.flag_outlined,
              accentOrange,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _buildStatCard(
              '${(totalSaved / totalTarget * 100).toStringAsFixed(0)}%',
              'Progress',
              Icons.trending_up,
              primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentGoalSection(BuildContext context) {
    if (userGoals.isEmpty) {
      return _buildEmptyState();
    }

    return SizedBox(
      height: 420,
      child: PageView.builder(
        itemCount: userGoals.length,
        controller: PageController(viewportFraction: 0.88),
        onPageChanged: (index) => setState(() => _currentGoalIndex = index),
        itemBuilder: (context, index) => _buildModernGoalCard(userGoals[index]),
      ),
    );
  }

  Widget _buildModernGoalCard(SavingsGoal goal) {
    double progress = goal.currentAmount / goal.targetAmount;
    Color cardColor = goal.customColor ?? accentOrange;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        elevation: 8,
        shadowColor: cardColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                // Header with gradient
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cardColor, cardColor.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              goal.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              goal.emojiLevel,
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      _buildCircularProgress(progress, cardColor),
                    ],
                  ),
                ),

                // Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Amount Display
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildAmountDisplay(
                              '€${goal.currentAmount.toStringAsFixed(0)}',
                              'Saved',
                              successGreen,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: lightBlue,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '${goal.progressPercentage.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryBlue,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            _buildAmountDisplay(
                              '€${goal.targetAmount.toStringAsFixed(0)}',
                              'Target',
                              Colors.grey[600]!,
                            ),
                          ],
                        ),

                        SizedBox(height: 16),
                        Divider(color: Colors.grey[200], height: 1),
                        SizedBox(height: 16),

                        // Weekly Plan
                        Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [softOrange, softOrange.withOpacity(0.5)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: accentOrange,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Weekly Goal',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      '€${goal.weeklyDepositNeeded.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: accentOrange,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${goal.daysRemaining}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: primaryBlue,
                                    ),
                                  ),
                                  Text(
                                    'days left',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 12),
                      ],
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

  Widget _buildCircularProgress(double progress, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 7,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              Center(
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getMotivationalMessage(progress),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                _getProgressDescription(progress),
                style: TextStyle(fontSize: 12, color: Colors.white70),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getMotivationalMessage(double progress) {
    if (progress >= 1.0) return 'Goal Achieved! 🎉';
    if (progress >= 0.75) return 'Almost There!';
    if (progress >= 0.5) return 'Halfway There!';
    if (progress >= 0.25) return 'Great Start!';
    return 'Just Getting Started';
  }

  String _getProgressDescription(double progress) {
    if (progress >= 1.0) return 'Time to celebrate your success';
    if (progress >= 0.75) return 'Final push to the finish line';
    if (progress >= 0.5) return 'You\'re doing amazing';
    if (progress >= 0.25) return 'Keep up the momentum';
    return 'Every journey begins somewhere';
  }

  Widget _buildAmountDisplay(String amount, String label, Color color) {
    return Flexible(
      child: Column(
        children: [
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text('🎯', style: TextStyle(fontSize: 64)),
          SizedBox(height: 20),
          Text(
            'Start Your First Goal!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Set a goal, track your progress, and watch your savings grow!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedFAB() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_pulseController.value * 0.1),
          child: FloatingActionButton.extended(
            onPressed: () => print('Add New Goal'),
            label: Text(
              'New Goal',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            icon: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, size: 20),
            ),
            backgroundColor: accentOrange,
            foregroundColor: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}
