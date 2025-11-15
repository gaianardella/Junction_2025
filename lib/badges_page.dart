import 'package:flutter/material.dart';
import 'widgets/avatar_widget.dart';
import 'monthly_challenge_page.dart';

class BadgesPage extends StatefulWidget {
  @override
  _BadgesPageState createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage>
    with SingleTickerProviderStateMixin {
  final Color backgroundBlue = Color(0xFF0D1B2A);
  final Color accent = Color(0xFF3A9C9F);
  final Color goldColor = Color(0xFFFFD700);
  final Color silverColor = Color(0xFFC0C0C0);
  final Color bronzeColor = Color(0xFFCD7F32);

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> leaderboard = [
    {
      'name': 'Gaia',
      'points': 7520,
      'me': true,
      'avatar': 'assets/gaia.png', // Use your uploaded Samir image
      'streak': 12,
      'change': 2, // Position change (positive = moved up)
    },
    {
      'name': 'Samir',
      'points': 7210,
      'avatar': 'assets/img_samir.png', // Use your uploaded Gaia image
      'streak': 8,
      'change': -1,
    },
    {
      'name': 'Robert',
      'points': 6900,
      'avatar': 'assets/Robert.jpg',
      'streak': 15,
      'change': 1,
    },
    {
      'name': 'Dimitrii',
      'points': 6415,
      'avatar': 'assets/Dimitrii.jpg',
      'streak': 5,
      'change': 0,
    },
    {
      'name': 'Anastasiia',
      'points': 6100,
      'avatar': 'assets/Anastasiia.jpg',
      'streak': 20,
      'change': 3,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _openMonthlyChallenge() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => MonthlyChallengePage()));
  }

  Color _getMedalColor(int position) {
    switch (position) {
      case 0:
        return goldColor;
      case 1:
        return silverColor;
      case 2:
        return bronzeColor;
      default:
        return Colors.white70;
    }
  }

  IconData _getMedalIcon(int position) {
    if (position < 3) return Icons.emoji_events;
    return Icons.circle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header spacing (banner removed)
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Scoreboard',
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

                // Stats overview
                _buildStatsOverview(),
                SizedBox(height: 20),

                // Scoreboard
                _buildLeaderboard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeBanner() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (value * 0.05),
          child: GestureDetector(
            onTap: _openMonthlyChallenge,
            child: Container(
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent.withOpacity(0.2), accent.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: accent.withOpacity(0.5), width: 1.5),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.2),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Avatar from monthly challenge
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: accent, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.35),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/avatar_profile.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Monthly Challenge',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: accent.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'NEW',
                                style: TextStyle(
                                  color: Color(0xFF0D1B2A),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Help Maya settle in Helsinki with smart money choices',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Colors.white70, size: 28),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsOverview() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Your Rank', '#1', Icons.trending_up, accent),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Total Points',
            '7,520',
            Icons.stars,
            goldColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
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
              Icon(icon, color: color, size: 20),
              SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.leaderboard, color: accent, size: 24),
              SizedBox(width: 10),
              Text(
                'Leaderboard',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'This Week',
                  style: TextStyle(
                    color: accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...leaderboard.asMap().entries.map((entry) {
            final idx = entry.key;
            final user = entry.value;
            return _buildLeaderboardItem(idx, user);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(int idx, Map<String, dynamic> user) {
    final bool me = user['me'] == true;
    final int change = user['change'] ?? 0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (idx * 100)),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient:
                    me
                        ? LinearGradient(
                          colors: [
                            accent.withOpacity(0.15),
                            accent.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                        : null,
                color: me ? null : Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: me ? accent.withOpacity(0.5) : Colors.white10,
                  width: me ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  // Rank with medal
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _getMedalColor(idx).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child:
                          idx < 3
                              ? Icon(
                                _getMedalIcon(idx),
                                color: _getMedalColor(idx),
                                size: 20,
                              )
                              : Text(
                                '${idx + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                    ),
                  ),
                  SizedBox(width: 12),

                  // Profile photo
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: me ? accent : Colors.white24,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: me ? accent.withOpacity(0.3) : Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                    child: Image.asset(
                      user['avatar'],
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return CircleAvatar(
                          radius: 22,
                          backgroundColor: accent.withOpacity(0.3),
                          child: Text(
                            user['name'][0],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    ),
                  ),
                  SizedBox(width: 12),

                  // Name and streak
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                user['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      me ? FontWeight.w700 : FontWeight.w600,
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (me) ...[
                              SizedBox(width: 6),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: accent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'YOU',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              color: Colors.orange,
                              size: 13,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${user['streak']} day streak',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Points and change indicator
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${user['points']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 2),
                      if (change != 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              change > 0
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: change > 0 ? Colors.green : Colors.red,
                              size: 12,
                            ),
                            Text(
                              '${change.abs()}',
                              style: TextStyle(
                                color: change > 0 ? Colors.green : Colors.red,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          '—',
                          style: TextStyle(color: Colors.white38, fontSize: 11),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
