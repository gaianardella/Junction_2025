import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'widgets/avatar_widget.dart';
import 'activity_page.dart';
import 'ticket_page.dart';
import 'community_page.dart';
import 'badges_page.dart';

// Global variables (updated theme: blue and orange)
final Color primaryBlue = Color(0xFF1E88E5);
final Color accentOrange = Color(0xFFFF6D00);
final String userName = "Sarah";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  
  // Pages for the bottom tab navigator
  final List<Widget> _pages = [
    HomeContent(), // Separate class for home content
    CommunityPage(),
    ActivityPage(),
    TicketsPage(),
    BadgesPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: primaryBlue,
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
              tooltip: 'Community',
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
        backgroundColor: Colors.white,
        onPressed: () => _onItemTapped(0),
        shape: CircleBorder(),
        elevation: 4,
        child: Icon(Icons.home, color: primaryBlue, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// Separate class for home content: expense monitor with donut chart
class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // Demo data for expense categories
  final List<Map<String, dynamic>> categories = [
    {'name': 'Food', 'amount': 420.0, 'color': Color(0xFF42A5F5)},       // light blue
    {'name': 'Transport', 'amount': 180.0, 'color': Color(0xFFFFA000)},  // orange
    {'name': 'Home', 'amount': 950.0, 'color': Color(0xFF1976D2)},       // blue
    {'name': 'Shopping', 'amount': 260.0, 'color': Color(0xFFFF8F00)},   // dark orange
    {'name': 'Leisure', 'amount': 140.0, 'color': Color(0xFF64B5F6)},    // light blue
  ];
 
  double get totalSpent =>
      categories.fold(0.0, (sum, c) => sum + (c['amount'] as double));
 
  String get totalSpentLabel {
    final value = totalSpent;
    if (value >= 1000) {
      return '€${(value / 1000).toStringAsFixed(1)}k';
    }
    return '€${value.toStringAsFixed(0)}';
  }

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
                colors: [primaryBlue, primaryBlue.withOpacity(0.85)],
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
                        '${userName}\'s expenses',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            'Monthly total',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: accentOrange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              totalSpentLabel,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  AvatarWidget(size: 50),
                ],
              ),
            ),
          ),
 
          // Donut chart
          Padding(
            padding: EdgeInsets.fromLTRB(16, 40, 16, 38),
            child: SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 1,
                      centerSpaceRadius: 55,
                      startDegreeOffset: -90,
                      sections: categories.map((c) {
                        final double amount = c['amount'] as double;
                        final double percent =
                            totalSpent == 0 ? 0 : (amount / totalSpent) * 100;
                        return PieChartSectionData(
                          color: c['color'] as Color,
                          value: amount,
                          title: '',
                          radius: 75,
                          badgeWidget: null,
                          showTitle: false,
                        );
                      }).toList(),
                    ),
                    swapAnimationDuration: Duration(milliseconds: 600),
                    swapAnimationCurve: Curves.easeOutCubic,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        totalSpentLabel,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
 
          // Categories list (title removed)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
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
              padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 6),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final c = categories[index];
                  final double amount = c['amount'] as double;
                  final double percent =
                      totalSpent == 0 ? 0 : (amount / totalSpent) * 100;
                  return Card(
                    color: Colors.grey.withOpacity(0.2),
                    elevation: 0,
                    margin: EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: (c['color'] as Color).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: c['color'] as Color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        c['name'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: LinearProgressIndicator(
                        value: totalSpent == 0 ? 0 : amount / totalSpent,
                        backgroundColor: Colors.grey[200],
                        color: accentOrange,
                        minHeight: 6,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '€${amount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${percent.toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
 
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
