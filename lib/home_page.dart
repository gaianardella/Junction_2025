import 'package:flutter/material.dart';
import 'widgets/avatar_widget.dart';
import 'activity_page.dart';
import 'expense_page.dart';
import 'goals_page.dart';
import 'badges_page.dart';
import 'learning_path_page.dart';
import 'spending_sandbox_page.dart';
import 'budget_course_page.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

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
      backgroundColor: Color(0xFF0D1B2A),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: accentOrange,
        notchMargin: 8,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.sports_esports, color: Colors.white),
              onPressed: () => _onItemTapped(2),
              tooltip: 'Activity',
            ),
            IconButton(
              icon: Icon(Icons.account_balance_wallet, color: Colors.white),
              onPressed: () => _onItemTapped(3),
              tooltip: 'Expense',
            ),
            SizedBox(width: 50),
            IconButton(
              icon: Icon(Icons.groups, color: Colors.white),
              onPressed: () => _onItemTapped(1),
              tooltip: 'Learn',
            ),
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

// --------------------------- HOME CONTENT ------------------------------

class HomeContent extends StatefulWidget {
  final VoidCallback? onGoToGoals;
  final VoidCallback? onGoToExpense;
  final VoidCallback? onGoToLearning;

  HomeContent({this.onGoToGoals, this.onGoToExpense, this.onGoToLearning});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  double currentBalance = 12450.00;
  double monthlySpending = 1850.50;
  double spendingLimit = 2500.00;

  bool _isLoadingInsights = false;
  String _insightText = '';
  String _insightTitleClean = '';
  String _insightReason = '';

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

  final PageController _carouselController = PageController(
    viewportFraction: 0.92,
  );

  int _carouselIndex = 0;

  void _simulateBalanceUpdate() {
    setState(() {
      currentBalance += Random().nextInt(500) - 250;
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

  // Slide-in animation from right (like Learning Path)
  Widget _slideInFromRight({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeInOut,
      builder: (context, value, c) {
        return Transform.translate(
          offset: Offset(20 * (1 - value), 0),
          child: Opacity(opacity: value, child: c),
        );
      },
      child: child,
    );
  }

  // -------------------------------------------------------------------------
  // FETCH INSIGHTS
  // -------------------------------------------------------------------------

  Future<void> _fetchInsights() async {
    setState(() => _isLoadingInsights = true);

    try {
      final response = await http.post(
        Uri.parse(
          'https://backend-service-647778379452.europe-north1.run.app/recommend/nano',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);

          // STEP 1 – Extract raw_text
          final rawText = data["gemini_response"]?["raw_text"];

          if (rawText == null) {
            throw Exception("Missing gemini_response.raw_text");
          }

          // STEP 2 – Remove ```json … ``` formatting
          final cleaned =
              rawText.replaceAll("```json", "").replaceAll("```", "").trim();

          // STEP 3 – Parse the JSON inside raw_text
          final inner = json.decode(cleaned);

          // STEP 4 – Build the final sentence
          final title = inner["title"] ?? "Unknown title";
          final reason = inner["reason"] ?? "No reason provided";

          final cleanTitle = title.toString().replaceAll("*", "").trim();
          final rawReason = reason.toString().trim();
          final loweredReason = rawReason.isEmpty
              ? "it fits your learning profile."
              : rawReason[0].toLowerCase() + rawReason.substring(1);
          final formattedReason = loweredReason.endsWith(".")
              ? loweredReason
              : "$loweredReason.";

          final newInsight =
              "We recommend $cleanTitle because $formattedReason";

          // STEP 5 – Update UI
          setState(() {
            _insightText = newInsight;
            _insightTitleClean = cleanTitle;
            _insightReason = formattedReason;
            _isLoadingInsights = false;
          });
        } catch (e) {
          setState(() {
            _insightText = "Error parsing insight: $e";
            _isLoadingInsights = false;
          });
        }
      } else {
        throw Exception("Server error ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _isLoadingInsights = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red.withOpacity(0.8),
        ),
      );
    }
  }

  // --------------------------- BUILD UI ------------------------------

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 110.0,
          backgroundColor: Color(0xFF0D1B2A),
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 20, bottom: 12),
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
                  colors: [accentOrange.withOpacity(0.9), accentOrange],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Hello, ${userName}!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: AvatarWidget(size: 52),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // actions removed
        ),

        // Middle Content
        SliverList(
          delegate: SliverChildListDelegate([
            _slideInFromRight(
              index: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: _buildBalanceSummaryCard(),
              ),
            ),
            _slideInFromRight(
              index: 1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: _buildSavingGoalsCard(),
              ),
            ),
            _slideInFromRight(
              index: 2,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: _buildContinueCard(),
              ),
            ),
            _slideInFromRight(
              index: 3,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  height: _isLoadingInsights
                      ? 200
                      : (_insightText.isNotEmpty ? 280 : 170),
                  child: Stack(
                    children: [
                      PageView(
                        controller: _carouselController,
                        onPageChanged: (i) =>
                            setState(() => _carouselIndex = i),
                        children: [_buildTipCard(), _buildSuggestionCard()],
                      ),
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(2, (i) {
                            bool active = i == _carouselIndex;
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: active ? 20 : 8,
                              height: 8,
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: active
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
            ),
            SizedBox(height: 16),
          ]),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // CARD WIDGETS
  // -------------------------------------------------------------------------

  Widget _buildCard({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(20),
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.15),
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
              ],
            ),
            SizedBox(height: 8),
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
              ],
            ),
            SizedBox(height: 12),
            ...savingGoals.map((g) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          g['title'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${(g['progress'] * 100).toStringAsFixed(0)}%',
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
                        value: g['progress'],
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(g['color']),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '€${g['saved']} / €${g['target']}',
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

  Widget _buildContinueCard() {
    final double progress = 0.35;
    return GestureDetector(
      onTap: widget.onGoToLearning,
      child: _buildCard(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Row(
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
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BudgetCoursePage()),
                );
              },
              icon: Icon(
                Icons.arrow_forward_ios,
                color: accentOrange,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard() {
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
          SizedBox(height: 12),
          Text(
            "You spent too much at restaurants this month. Cut down to improve your 'Europe Trip' progress.",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

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
                  color: accentOrange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.school_outlined,
                  color: accentOrange,
                  size: 24,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Recommended Insight',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Flexible(
            child: _isLoadingInsights
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(accentOrange),
                    ),
                  )
                : (_insightText.isNotEmpty || _insightTitleClean.isNotEmpty
                    ? SingleChildScrollView(
                        padding: EdgeInsets.only(right: 6),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
                            children: [
                              TextSpan(text: 'We recommend '),
                              TextSpan(
                                text: _insightTitleClean.isNotEmpty ? _insightTitleClean : 'this',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(text: ' because ${_insightReason.isNotEmpty ? _insightReason : ''}'),
                            ],
                          ),
                        ),
                      )
                    : SizedBox.shrink()),
          ),
          SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _isLoadingInsights ? null : _fetchInsights,
            icon: Icon(Icons.cloud_download, size: 20),
            label: Text(_isLoadingInsights ? "Loading..." : "Get Insights"),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentOrange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}