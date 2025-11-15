import 'package:flutter/material.dart';
import 'widgets/avatar_widget.dart';
import 'activity_page.dart';
import 'expense_page.dart';
import 'goals_page.dart';
import 'badges_page.dart';
import 'learning_path_page.dart';
import 'spending_sandbox_page.dart';
import 'budget_course_page.dart';
import 'dart:math'; // For random data in interactive widgets

// Global variables (updated theme: blue and orange)
final Color primaryBlue = Color(0xFF1E88E5);
final Color accentOrange = Color(0xFF3A9C9F);
final String userName = "Gaia";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Pages for the bottom tab navigator
  late final List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      // If the user taps on the home tab from within the home tab,
      // it should navigate to the actual HomeContent if it's currently on a sub-page,
      // but here we only handle BottomNavBar taps, so 0 is HomeContent.
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Index mapping: 0: Home, 1: Learn (Groups), 2: Activity (Esports), 3: Expense (Wallet), 4: Badges (Military)
    // Extra pages (5: Goals) are available for programmatic navigation.
    _pages = [
      HomeContent(
        onGoToGoals: () => _onItemTapped(5),
        onGoToExpense: () => _onItemTapped(3),
        onGoToLearning: () => _onItemTapped(1),
      ), // Separate class for home content
      LearningPathPage(), // Index 1
      SpendingSandboxPage(), // Index 2
      ExpensePage(), // Index 3
      BadgesPage(), // Index 4
      GoalsPage(), // Index 5 (Not directly in NavBar, but linkable)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1B2A), // Dark background
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: accentOrange,
        notchMargin: 8,
        height: 70, // Bottom bar height
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Activity Page (Esports)
            IconButton(
              icon: Icon(Icons.sports_esports, color: Colors.white),
              onPressed: () => _onItemTapped(2),
              tooltip: 'Activity',
            ),
            // Expense Page (Wallet)
            IconButton(
              icon: Icon(Icons.account_balance_wallet, color: Colors.white),
              onPressed: () => _onItemTapped(3),
              tooltip: 'Expense',
            ),
            SizedBox(width: 50), // Spacer for FAB
            // Learning Path Page (Groups)
            IconButton(
              icon: Icon(Icons.groups, color: Colors.white),
              onPressed: () => _onItemTapped(1),
              tooltip: 'Learn',
            ),
            // Badges Page (Military)
            IconButton(
              icon: Icon(Icons.military_tech, color: Colors.white),
              onPressed: () => _onItemTapped(4),
              tooltip: 'Badges',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentOrange,
        onPressed: () => _onItemTapped(0),
        shape: CircleBorder(),
        elevation: 4,
        child: Icon(Icons.home, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// Separate class for home content: enhanced with interactive elements
class HomeContent extends StatefulWidget {
  final VoidCallback? onGoToGoals;
  final VoidCallback? onGoToExpense;
  final VoidCallback? onGoToLearning;

  HomeContent({this.onGoToGoals, this.onGoToExpense, this.onGoToLearning});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // Demo data for an interactive dashboard feel
  double currentBalance = 12450.00;
  double monthlySpending = 1850.50;
  double spendingLimit = 2500.00;

  // Small saving goals to show top-right with progress bars
  List<Map<String, dynamic>> get savingGoals => [
    {
      'title': 'Gaming PC',
      'progress': 0.35,
      'color': Color(0xFF6A1B9A),
      'target': 2500.0,
      'saved': 875.0,
    },
    {
      'title': 'Europe Trip',
      'progress': 0.60,
      'color': Color(0xFF0288D1),
      'target': 5000.0,
      'saved': 3000.0,
    },
  ];

  // Carousel controller
  final PageController _carouselController = PageController(
    viewportFraction: 0.92, // Slightly wider for mobile fit
  );
  int _carouselIndex = 0;

  // Simulate an update
  void _simulateBalanceUpdate() {
    setState(() {
      currentBalance +=
          Random().nextInt(500) - 250; // Add/subtract small random amount
      if (currentBalance < 0) currentBalance = 0;
      monthlySpending += Random().nextInt(50) - 25;
      if (monthlySpending < 0) monthlySpending = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Balance data refreshed!"),
        duration: Duration(milliseconds: 800),
        backgroundColor: accentOrange.withOpacity(0.8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Upper Section: Interactive Header (SliverAppBar)
        SliverAppBar(
          pinned: true,
          expandedHeight: 200.0,
          backgroundColor: Color(0xFF0D1B2A), // Match body background
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 24, bottom: 16),
            centerTitle: false,
            title: Text(
              'Overview',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  // Use a deeper variant of accentOrange for the header background
                  colors: [accentOrange.withOpacity(0.9), accentOrange],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 60, 24, 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${userName}!',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        GestureDetector(
                          onTap: _simulateBalanceUpdate,
                          child: Row(
                            children: [
                              Text(
                                'Tap to Refresh Data',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.refresh,
                                color: Colors.white.withOpacity(0.8),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AvatarWidget(size: 50),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                // Future implementation: Settings page
              },
            ),
          ],
        ),

        // Middle Content Section (SliverList for scrollability)
        SliverList(
          delegate: SliverChildListDelegate([
            // Current Balance and Monthly Spending Summary (Single Card)
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: _buildBalanceSummaryCard(),
            ),

            // Saving Goals Quick View (Clickable Card to GoalsPage)
            Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: _buildSavingGoalsCard(),
            ),

            // Continue Learning Card (Interactive Progress)
            Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: _buildContinueCard(),
            ),

            // Tip/Suggestion Carousel (Interactive Swipe)
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                height: 170, // Fixed height for the carousel
                child: Stack(
                  children: [
                    PageView(
                      controller: _carouselController,
                      onPageChanged: (i) => setState(() => _carouselIndex = i),
                      children: [_buildTipCard(), _buildSuggestionCard()],
                    ),
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(2, (i) {
                          final bool active = i == _carouselIndex;
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: active ? 20 : 8,
                            height: 8,
                            margin: EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color:
                                  active
                                      ? accentOrange
                                      : Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ]),
        ),
      ],
    );
  }

  void _openBudgetCourse() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => BudgetCoursePage()));
  }

  // --- NEW/UPDATED WIDGETS ---

  Widget _buildCard({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(20),
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(
          0.15,
        ), // Slightly less opaque background for contrast
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }

  Widget _buildBalanceSummaryCard() {
    final double remaining = spendingLimit - monthlySpending;
    final bool isOverBudget = remaining < 0;

    return GestureDetector(
      onTap: widget.onGoToExpense,
      child: _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Finances',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(color: Colors.white12, height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Balance',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '€${currentBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Monthly Spent',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '€${monthlySpending.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: accentOrange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  isOverBudget
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline,
                  color: isOverBudget ? Colors.redAccent : Colors.greenAccent,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isOverBudget
                        ? 'Over budget! €${remaining.abs().toStringAsFixed(2)}'
                        : '€${remaining.toStringAsFixed(2)} left to spend',
                    style: TextStyle(
                      color: isOverBudget ? Colors.redAccent : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingGoalsCard() {
    return GestureDetector(
      onTap: widget.onGoToGoals,
      child: _buildCard(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Saving Goals',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(Icons.star_half, color: primaryBlue, size: 20),
              ],
            ),
            SizedBox(height: 12),
            ...savingGoals.map((g) {
              final double progress = g['progress'] as double;
              final Color progressColor = g['color'] as Color;
              final double target = g['target'] as double;
              final double saved = g['saved'] as double;

              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          g['title'] as String,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${((progress) * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progressColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '€${saved.toStringAsFixed(0)} / €${target.toStringAsFixed(0)}',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                  ],
                ),
              );
            }).toList(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'View All >',
                style: TextStyle(
                  color: primaryBlue.withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Refactored Continue Card
  Widget _buildContinueCard() {
    final double progress = 0.35; // Example saved progress
    return GestureDetector(
      onTap: widget.onGoToLearning,
      child: _buildCard(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: Colors.white.withOpacity(0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(accentOrange),
                    ),
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Budgeting 101',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Mini-course on budgeting basics: Module 2',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            // Use an IconButton for a cleaner look
            IconButton(
              onPressed: _openBudgetCourse,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: accentOrange,
                size: 24,
              ),
              tooltip: 'Continue Learning',
            ),
          ],
        ),
      ),
    );
  }

  // Refactored Tip Card
  Widget _buildTipCard() {
    return _buildCard(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentOrange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.lightbulb_outline,
                      color: accentOrange,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Smart Tip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(Icons.swipe_left, color: Colors.white54, size: 18),
            ],
          ),
          SizedBox(height: 12),
          Text(
            "You spent too much at restaurants this month. Cut down to improve your 'Europe Trip' goal progress. Eating out budget remaining: €250.",
            style: TextStyle(color: Colors.white70, fontSize: 13),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Refactored Suggestion Card
  Widget _buildSuggestionCard() {
    return _buildCard(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.school_outlined,
                  color: primaryBlue,
                  size: 24,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Actionable Insight',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Expanded(
            child: Text(
              'Your high food spending is impacting your goals. Check out the "Meal Prep 101" course to learn how to cut costs.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Integrate with backend system to fetch personalized insights
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Fetching insights from backend..."),
                    duration: Duration(milliseconds: 1000),
                    backgroundColor: accentOrange.withOpacity(0.8),
                  ),
                );
              },
              icon: Icon(Icons.cloud_download, size: 20),
              label: Text("Get Insights"),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentOrange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                textStyle: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
