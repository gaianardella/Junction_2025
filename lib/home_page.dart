import 'package:flutter/material.dart';
import 'widgets/avatar_widget.dart';
import 'activity_page.dart';
import 'expense_page.dart';
import 'goals_page.dart';
import 'badges_page.dart';
import 'learning_path_page.dart';

// Global variables (updated theme: blue and orange)
final Color primaryBlue = Color(0xFF1E88E5);
final Color accentOrange = Color(0xFF3A9C9F);
final String userName = "Sarah";

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
      HomeContent(onGoToGoals: () => _onItemTapped(5)), // Separate class for home content
      LearningPathPage(),
      ActivityPage(),
      ExpensePage(),
      BadgesPage(),
      GoalsPage(),
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
        height: 70, // Bottom bar height
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: Icon(Icons.confirmation_number, color: Colors.white),
              onPressed: () => _onItemTapped(3),
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

// Separate class for home content: expense monitor with donut chart
class HomeContent extends StatefulWidget {
  final VoidCallback? onGoToGoals;
  HomeContent({this.onGoToGoals});
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // Demo current balance
  final double currentBalance = 12450.00;
  // Small saving goals to show top-right with progress bars
  List<Map<String, dynamic>> get savingGoals => [
        {
          'title': 'Gaming PC',
          'progress': 0.35,
          'color': Color(0xFF6A1B9A), // same purple as GoalsPage
        },
        {
          'title': 'Europe Trip',
          'progress': 0.60,
          'color': Color(0xFF0288D1), // same azure as GoalsPage
        },
      ];
  // Carousel controller
  final PageController _carouselController = PageController(viewportFraction: 0.9);
  int _carouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with greeting and avatar
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accentOrange, accentOrange.withOpacity(0.85)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 60, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${userName}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Overview',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  AvatarWidget(size: 50),
                ],
              ),
            ),
          ),

          // Saving goals (above balance)
          Padding(
            padding: EdgeInsets.fromLTRB(16, 18, 16, 4),
            child: GestureDetector(
              onTap: () => widget.onGoToGoals?.call(),
              child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: savingGoals.map((g) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                g['title'] as String,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${((g['progress'] as double) * 100).toStringAsFixed(0)}%',
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
                            value: (g['progress'] as double),
                            minHeight: 8,
                            backgroundColor: Colors.white.withOpacity(0.25),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              (g['color'] is Color)
                                  ? (g['color'] as Color)
                                  : ((g['title'] == 'Gaming PC')
                                      ? Color(0xFF6A1B9A)
                                      : (g['title'] == 'Europe Trip'
                                          ? Color(0xFF0288D1)
                                          : Color(0xFF5865A5))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            ),
          ),

          // Current Balance (no chart)
          Padding(
            padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Current Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '€${currentBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Carousel with 2 sections
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              height: 170,
              child: Stack(
                children: [
                  PageView(
                    controller: _carouselController,
                    onPageChanged: (i) => setState(() => _carouselIndex = i),
                    children: [
                      _buildTipCard(),
                      _buildSuggestionCard(),
                    ],
                  ),
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(2, (i) {
                        final bool active = i == _carouselIndex;
                        return Container(
                          width: active ? 20 : 8,
                          height: 8,
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: active ? accentOrange : Colors.white.withOpacity(0.4),
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
        ],
      ),
    );
  }

  Widget _buildCarouselCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentOrange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentOrange, size: 28),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentOrange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.restaurant_outlined, color: accentOrange, size: 28),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Spending Tip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "You spent too much at restaurants this month. You could improve your 'Europe Trip' goal.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentOrange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.food_bank_outlined, color: accentOrange, size: 28),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Suggestion',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Try meal prep this week to cut costs and stay on track.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentOrange,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text("Watch: Meal Prep 101"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
