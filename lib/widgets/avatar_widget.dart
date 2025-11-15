import 'package:flutter/material.dart';

// Avatar Widget with Student Profile
class AvatarWidget extends StatelessWidget {
  final String imagePath;
  final double size;
  final int points;
  final int rank;
  final int streak;
  final Color borderColor;

  const AvatarWidget({
    Key? key,
    this.imagePath = 'assets/gaia.png', // Gaia's profile photo
    this.size = 40,
    this.points = 7520,
    this.rank = 1,
    this.streak = 12,
    this.borderColor = const Color(0xFF3A9C9F), // Match bottom menu accent
  }) : super(key: key);

  String _getRankTitle(int rank) {
    if (rank == 1) return '👑 Top Performer';
    if (rank == 2) return '⭐ Rising Star';
    if (rank == 3) return '🔥 High Achiever';
    if (rank <= 5) return '📚 Dedicated Learner';
    if (rank <= 10) return '💪 Making Progress';
    return '🎯 Getting Started';
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return Color(0xFFFFD700); // Gold
    if (rank == 2) return Color(0xFFC0C0C0); // Silver
    if (rank == 3) return Color(0xFFCD7F32); // Bronze
    return Color(0xFF3A9C9F); // Teal
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder:
              (context) => Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0D1B2A), Color(0xFF1B2838)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: borderColor.withOpacity(0.5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: borderColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Profile Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.white70),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Profile Picture with Rank Badge
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Animated glow effect
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  borderColor.withOpacity(0.4),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          // Profile picture with border
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: borderColor,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: borderColor.withOpacity(0.5),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Color(0xFF3A9C9F),
                                    child: Center(
                                      child: Text(
                                        'G',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          // Rank badge
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: borderColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color(0xFF0D1B2A),
                                  width: 3,
                                ),
                              ),
                              child: Text(
                                '#$rank',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Name
                      Text(
                        'Gaia',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),

                      // Rank Title
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              borderColor.withOpacity(0.3),
                              borderColor.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: borderColor.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          _getRankTitle(rank),
                          style: TextStyle(
                            color: borderColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),

                      // Stats Container
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Points
                            _buildStatRow(
                              Icons.stars,
                              'Total Points',
                              points.toString(),
                              Color(0xFFFFD700),
                            ),
                            SizedBox(height: 12),
                            Divider(
                              color: Colors.white.withOpacity(0.1),
                              height: 1,
                            ),
                            SizedBox(height: 12),
                            // Streak
                            _buildStatRow(
                              Icons.local_fire_department,
                              'Current Streak',
                              '$streak days',
                              Colors.orange,
                            ),
                            SizedBox(height: 12),
                            Divider(
                              color: Colors.white.withOpacity(0.1),
                              height: 1,
                            ),
                            SizedBox(height: 12),
                            // Rank
                            _buildStatRow(
                              Icons.emoji_events,
                              'Global Rank',
                              '#$rank',
                              _getRankColor(rank),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Achievement Progress
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF3A9C9F).withOpacity(0.2),
                              Color(0xFF3A9C9F).withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Color(0xFF3A9C9F).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.school,
                                  color: Color(0xFF3A9C9F),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Student Level',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF3A9C9F),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Level ${(points / 1000).floor() + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.edit, size: 18),
                              label: Text('Edit Profile'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF3A9C9F),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.share, size: 18),
                              label: Text('Share'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Color(0xFF3A9C9F),
                                side: BorderSide(color: Color(0xFF3A9C9F)),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Color(0xFF3A9C9F),
                child: Center(
                  child: Text(
                    'G',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 12),
            Text(label, style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
