import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'widgets/avatar_widget.dart';

// --- Theme Colors ---
final Color primaryBlue = Color(0xFF00468C);
final Color accentOrange = Color(0xFFF77F00);
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

class AccomplishedGoal {
  final String title;
  final String region;
  final double amount;
  final String imagePath;
  final String emoji;

  AccomplishedGoal({
    required this.title,
    required this.region,
    required this.amount,
    required this.imagePath,
    required this.emoji,
  });
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

  final List<AccomplishedGoal> accomplishedGoals = [
    AccomplishedGoal(
      title: 'First Car',
      region: 'Helsinki',
      amount: 4000.0,
      imagePath: 'assets/car.jpg',
      emoji: '🚗',
    ),
    AccomplishedGoal(
      title: 'Apartment',
      region: 'Tampere',
      amount: 1500.0,
      imagePath: 'assets/apartment.jpg',
      emoji: '🏠',
    ),
    AccomplishedGoal(
      title: 'Festival',
      region: 'Oulu',
      amount: 500.0,
      imagePath: 'assets/festival.jpg',
      emoji: '🎪',
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
      backgroundColor: primaryBlue,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: primaryBlue,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryBlue, primaryBlue.withOpacity(0.8)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 40, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Your Goals',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Track & Achieve 🎯',
                              style: TextStyle(
                                fontSize: 16,
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

          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20),

                // Stats Overview Cards
                _buildStatsOverview(),

                SizedBox(height: 24),

                // Main Goal Carousel
                _buildCurrentGoalSection(context),

                SizedBox(height: 32),

                // AI Showcase
                _buildAIGoalShowcase(),

                SizedBox(height: 32),

                // Upcoming Goals
                _buildUpcomingGoalsList(),

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

                        // Interest Rate Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: successGreen,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${goal.interestRate.toStringAsFixed(1)}% interest rate',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: successGreen,
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildAIGoalShowcase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [purpleAccent, purpleAccent.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Peer Inspiration',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                'Real goals achieved by people like you',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: accomplishedGoals.length,
            itemBuilder:
                (context, index) =>
                    _buildAccomplishedGoalCard(accomplishedGoals[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildAccomplishedGoalCard(AccomplishedGoal goal) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 4,
        shadowColor: purpleAccent.withOpacity(0.2),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => print('Start Goal: ${goal.title}'),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            purpleAccent.withOpacity(0.7),
                            primaryBlue.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Text(goal.emoji, style: TextStyle(fontSize: 48)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 12,
                                color: Colors.grey[500],
                              ),
                              SizedBox(width: 4),
                              Text(
                                goal.region,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(
                            '€${goal.amount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: successGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: successGreen,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingGoalsList() {
    final upcoming = userGoals.skip(_currentGoalIndex + 1).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag_outlined, color: accentOrange, size: 24),
              SizedBox(width: 8),
              Text(
                'Next in Line',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (upcoming.isEmpty)
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: primaryBlue,
                    size: 32,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'All caught up! Focus on your current goal or add a new one.',
                      style: TextStyle(color: primaryBlue),
                    ),
                  ),
                ],
              ),
            ),
          ...upcoming.asMap().entries.map((entry) {
            int idx = entry.key;
            SavingsGoal goal = entry.value;
            return _buildUpcomingGoalItem(goal, idx);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildUpcomingGoalItem(SavingsGoal goal, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                goal.customColor?.withOpacity(0.2) ??
                    primaryBlue.withOpacity(0.2),
                goal.customColor?.withOpacity(0.1) ??
                    primaryBlue.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(goal.emojiLevel, style: TextStyle(fontSize: 28)),
          ),
        ),
        title: Text(
          goal.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Row(
            children: [
              _buildInfoChip(
                '€${goal.targetAmount.toStringAsFixed(0)}',
                Icons.savings_outlined,
              ),
              SizedBox(width: 8),
              _buildInfoChip('${goal.daysRemaining}d', Icons.schedule),
            ],
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.arrow_forward, color: accentOrange, size: 20),
        ),
        onTap: () => print('View Goal: ${goal.name}'),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
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
