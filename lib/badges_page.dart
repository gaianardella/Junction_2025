import 'package:flutter/material.dart';
import 'widgets/avatar_widget.dart';
import 'monthly_challenge_page.dart';

class BadgesPage extends StatefulWidget {
  @override
  _BadgesPageState createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage> {
  final Color backgroundBlue = Color(0xFF0D1B2A);
  final Color accent = Color(0xFF3A9C9F);
  final List<Map<String, dynamic>> leaderboard = [
    {'name': 'Sarah', 'points': 7520, 'me': true},
    {'name': 'Alex', 'points': 7210},
    {'name': 'Mika', 'points': 6900},
    {'name': 'Jon', 'points': 6415},
    {'name': 'Priya', 'points': 6100},
  ];

  void _openMonthlyChallenge() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MonthlyChallengePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlue,
      appBar: AppBar(
        title: Text('Scoreboard', style: TextStyle(color: Colors.white)),
        backgroundColor: accent,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: AvatarWidget(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Monthly challenge banner
            GestureDetector(
              onTap: _openMonthlyChallenge,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  border: Border.all(color: accent.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.flag, color: Colors.white),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('New Monthly Challenge', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Tap to play a quick financial story', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.white70),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Scoreboard
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.leaderboard, color: accent),
                      SizedBox(width: 8),
                      Text('Leaderboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 12),
                  ...leaderboard.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final user = entry.value;
                    final bool me = user['me'] == true;
                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: me ? accent.withOpacity(0.12) : Colors.white.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: me ? accent.withOpacity(0.5) : Colors.white10),
                      ),
                      child: Row(
                        children: [
                          Text('${idx + 1}', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                          SizedBox(width: 12),
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: accent.withOpacity(0.2),
                            child: Text(user['name'][0], style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              user['name'],
                              style: TextStyle(color: Colors.white, fontWeight: me ? FontWeight.w700 : FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('${user['points']} pts', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
