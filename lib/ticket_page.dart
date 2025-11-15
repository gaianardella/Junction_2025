import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'widgets/avatar_widget.dart'; // keep this file in your project

// Theme & global colors
final Color primaryBlue = Color(0xFF1E88E5);
final Color accentOrange = Color(0xFFFF6D00);
final Color warningRed = Color(0xFFE53935);
final Color successGreen = Color(0xFF43A047);
final String userName = "Sarah";

// New main background color (Dark Blue)
final Color mainDarkBlue = Color(0xFF0D1B2A);
final Color expenseSectionBackground = Color(0xFF18181A);

class TicketsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpenseTrackerContent();
  }
}

class SpendingPrediction {
  final String category;
  final double currentSpending;
  final double predictedNextMonth;
  final double trend;
  final String insight;
  final bool isWarning;

  SpendingPrediction({
    required this.category,
    required this.currentSpending,
    required this.predictedNextMonth,
    required this.trend,
    required this.insight,
    required this.isWarning,
  });
}

class ExpenseTrackerContent extends StatefulWidget {
  @override
  _ExpenseTrackerContentState createState() => _ExpenseTrackerContentState();
}

class _ExpenseTrackerContentState extends State<ExpenseTrackerContent>
    with TickerProviderStateMixin {
  // Chart/pulse controllers
  late AnimationController _chartAnimationController;
  late AnimationController _pulseController;
  late Animation<double> _chartAnimation;

  // Dynamic account balance (you can update this variable programmatically)
  double accountBalance = 14095.0; // default value (dynamic variable)

  // Demo categories
  List<Map<String, dynamic>> categories = [
    {
      'name': 'Subscriptions',
      'amount': 950.0,
      'color': Color(0xFFE53935),
      'lastMonth': 600.0,
      'icon': Icons.warning_amber_rounded,
      'isAlert': true,
    },
    {
      'name': 'Food',
      'amount': 420.0,
      'color': Color(0xFF42A5F5),
      'lastMonth': 380.0,
      'icon': Icons.restaurant,
    },
    {
      'name': 'Transport',
      'amount': 180.0,
      'color': Color(0xFFFFA000),
      'lastMonth': 150.0,
      'icon': Icons.directions_car,
    },
    {
      'name': 'Shopping',
      'amount': 260.0,
      'color': Color(0xFFFF8F00),
      'lastMonth': 280.0,
      'icon': Icons.shopping_bag,
    },
    {
      'name': 'Leisure',
      'amount': 140.0,
      'color': Color(0xFF64B5F6),
      'lastMonth': 160.0,
      'icon': Icons.sports_esports,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Ensure alert categories are at the top
    _sortCategories();

    // Chart animation
    _chartAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1400),
    );
    _chartAnimation = CurvedAnimation(
      parent: _chartAnimationController,
      curve: Curves.easeOutCubic,
    );

    // Pulse for alert icons
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // start chart
    _chartAnimationController.forward();
  }

  void _sortCategories() {
    categories.sort((a, b) {
      bool aIsAlert = a['isAlert'] == true;
      bool bIsAlert = b['isAlert'] == true;
      if (aIsAlert && !bIsAlert) return -1;
      if (!aIsAlert && bIsAlert) return 1;
      return 0;
    });
  }

  @override
  void dispose() {
    _chartAnimationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  double get totalSpent =>
      categories.fold(0.0, (sum, c) => sum + (c['amount'] as double));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainDarkBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (greeting + avatar)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $userName',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Overview',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                    AvatarWidget(size: 44),
                  ],
                ),
              ),

              SizedBox(height: 18),

              // Chart + center balance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.pie_chart, color: primaryBlue, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Spending Breakdown',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    _buildAnimatedChartWithBalance(),
                  ],
                ),
              ),

              // --- CHANGE: Increased spacing here to push the chart up ---
              SizedBox(height: 36),

              // Expense list section (starts with a different background color)
              Container(
                color: expenseSectionBackground,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        children: List.generate(categories.length, (index) {
                          final c = categories[index];
                          final double amount = c['amount'] as double;
                          final double lastMonth = c['lastMonth'] as double;
                          final double change = amount - lastMonth;
                          final bool isAlert = c['isAlert'] == true;
                          final double percent =
                              totalSpent == 0 ? 0 : (amount / totalSpent) * 100;

                          return _buildGlassExpenseItem(
                            name: c['name'] as String,
                            iconData: c['icon'] as IconData,
                            color: c['color'] as Color,
                            amount: amount,
                            percent: percent,
                            isAlert: isAlert,
                            change: change,
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Animated pie chart with center balance (uses TweenAnimationBuilder for count-up)
  Widget _buildAnimatedChartWithBalance() {
    // Safe fallback
    final total = totalSpent > 0 ? totalSpent : 1.0;

    return AnimatedBuilder(
      animation: _chartAnimation,
      builder: (context, child) {
        // center account balance animation - scale/tint synced with chart animation
        return SizedBox(
          height: 260,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animated pie: scale + fade + pop radius
              Transform.scale(
                scale: 0.92 + (_chartAnimation.value * 0.14),
                child: Opacity(
                  opacity: _chartAnimation.value,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 74,
                      startDegreeOffset: -90,
                      sections:
                          categories.map((c) {
                            final double amount = c['amount'] as double;
                            final animatedValue =
                                amount * _chartAnimation.value;
                            return PieChartSectionData(
                              color: c['color'] as Color,
                              value: animatedValue,
                              radius:
                                  58 +
                                  (_chartAnimation.value * 16), // pop animation
                              title: '',
                              showTitle: false,
                            );
                          }).toList(),
                    ),
                    swapAnimationDuration: Duration(milliseconds: 600),
                    swapAnimationCurve: Curves.easeOutCubic,
                  ),
                ),
              ),

              // Center glass circle with animated account balance
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: accountBalance),
                  duration: Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.95 + (_chartAnimation.value * 0.12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '€${value >= 1000 ? (value / 1000).toStringAsFixed(1) + 'k' : value.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 26,
                              color: primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Total Balance',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Glassmorphic expense item
  Widget _buildGlassExpenseItem({
    required String name,
    required IconData iconData,
    required Color color,
    required double amount,
    required double percent,
    required bool isAlert,
    required double change,
  }) {
    // Right-side amount text style
    final amountText =
        (amount >= 0 ? '+€' : '-€') + amount.abs().toStringAsFixed(2);
    final amountColor = amount >= 0 ? successGreen : warningRed;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.02),
                  Colors.white.withOpacity(0.01),
                ],
              ),
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.45),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon circle with neon accent
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(-0.6, -0.6),
                      radius: 1.2,
                      colors: [color.withOpacity(0.22), Colors.transparent],
                    ),
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.03)),
                  ),
                  child: Center(
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withOpacity(0.14),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.12),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(iconData, color: color, size: 20),
                    ),
                  ),
                ),

                SizedBox(width: 12),

                // Name & subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isAlert) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: warningRed,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'ALERT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            change >= 0
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 12,
                            color: change >= 0 ? warningRed : successGreen,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '${change >= 0 ? '+' : ''}€${change.toStringAsFixed(0)} vs last month',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right column: amount + percent
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      amountText,
                      style: TextStyle(
                        color: amount >= 0 ? successGreen : warningRed,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${percent.toStringAsFixed(0)}%',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Background painter — subtle pattern for the header region (kept for aesthetics)
class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.02)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    for (int i = 0; i < 4; i++) {
      double radius = (i + 1) * 36.0;
      canvas.drawCircle(Offset(size.width * 0.9, -10), radius, paint);
    }

    for (int i = 0; i < 6; i++) {
      double x = i * 60.0;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height * 0.4, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
