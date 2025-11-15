import 'package:flutter/material.dart';
import 'quiz_page.dart';

class LearningPathPage extends StatefulWidget {
  @override
  State<LearningPathPage> createState() => _LearningPathPageState();
}

class _LearningPathPageState extends State<LearningPathPage> {
  final Color primaryBlue = const Color(0xFF1E88E5);
  final Color accentOrange = const Color(0xFF3A9C9F);
  final Color successGreen = const Color(0xFF4CAF50);

  final List<_PathNode> nodes = [
    _PathNode(title: 'Basics of Money', status: _NodeStatus.completed),
    _PathNode(title: 'Earnings & Income', status: _NodeStatus.completed),
    _PathNode(title: 'Budgeting 101', status: _NodeStatus.current),
    _PathNode(title: 'Saving Strategies', status: _NodeStatus.locked),
    _PathNode(title: 'Interest & Inflation', status: _NodeStatus.locked),
    _PathNode(title: 'Investing Basics', status: _NodeStatus.locked),
    _PathNode(title: 'Risk & Diversification', status: _NodeStatus.locked),
  ];

  List<_PathItem> _items = [];

  @override
  void initState() {
    super.initState();
    // Build items list interleaving section dividers
    final List<_SectionSpec> sections = [
      _SectionSpec('Foundations', 2),
      _SectionSpec('Money Management', 2),
      _SectionSpec('Saving & Goals', 2),
      _SectionSpec('Investing Basics', nodes.length - 6 > 0 ? nodes.length - 6 : 0),
    ];
    _items = _buildItemsWithSections(nodes, sections);
  }

  @override
  Widget build(BuildContext context) {
    final List<_PathItem> items =
        _items.isNotEmpty ? _items : _buildItemsWithSections(nodes, _sectionsSpec());
    return Scaffold(
      backgroundColor: Color(0xFF0D1B2A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Learning Path',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Financial Literacy',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: accentOrange, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'XP 1240',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  if (item.type == _PathItemType.section) {
                    return _buildSectionRow(item.title);
                  } else {
                    return _buildLessonTile(
                      title: item.title,
                      status: item.status ?? _NodeStatus.locked,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_PathItem> _buildItemsWithSections(
    List<_PathNode> nodes,
    List<_SectionSpec> sections,
  ) {
    final List<_PathItem> items = [];
    int cursor = 0;
    for (final section in sections) {
      if (section.count <= 0) continue;
      items.add(_PathItem.section(section.title));
      for (int i = 0; i < section.count && cursor < nodes.length; i++) {
        final n = nodes[cursor++];
        items.add(_PathItem.lesson(n.title, n.status));
      }
    }
    // If any leftover nodes exist
    while (cursor < nodes.length) {
      items.add(_PathItem.lesson(nodes[cursor].title, nodes[cursor].status));
      cursor++;
    }
    return items;
  }

  List<_SectionSpec> _sectionsSpec() {
    return [
      _SectionSpec('Foundations', 2),
      _SectionSpec('Money Management', 2),
      _SectionSpec('Saving & Goals', 2),
      _SectionSpec('Investing Basics', nodes.length - 6 > 0 ? nodes.length - 6 : 0),
    ];
  }

  Widget _buildSectionRow(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 10),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: Colors.white24)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: Colors.white24)),
        ],
      ),
    );
  }

  Widget _buildLessonTile({required String title, required _NodeStatus status}) {
    final bool isLocked = status == _NodeStatus.locked;
    final bool isCurrent = status == _NodeStatus.current;
    final Color edgeColor =
        isLocked ? Colors.white24 : (isCurrent ? accentOrange : successGreen);
    final Color chipBg = isLocked ? Colors.white10 : edgeColor.withOpacity(0.15);
    final Color chipFg = isLocked ? Colors.white60 : edgeColor;
    final IconData icon =
        isLocked ? Icons.lock_outline : (isCurrent ? Icons.play_arrow_rounded : Icons.check);

    final bool launchQuiz =
        !isLocked && title.toLowerCase().trim() == 'budgeting 101';

    return InkWell(
      onTap: launchQuiz
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => QuizPage()),
              );
            }
          : null,
      borderRadius: BorderRadius.circular(14),
      splashColor: edgeColor.withOpacity(0.15),
      highlightColor: Colors.white10,
      child: Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [edgeColor, edgeColor.withOpacity(0.75)],
              ),
              boxShadow: [
                BoxShadow(
                  color: edgeColor.withOpacity(0.25),
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Icon(icon, color: Colors.white, size: 24),
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isLocked ? Colors.white70 : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isLocked ? Icons.schedule : Icons.local_fire_department,
                        color: chipFg,
                        size: 14,
                      ),
                      SizedBox(width: 6),
                      Text(
                        isLocked ? 'Locked' : (isCurrent ? 'Continue' : 'Completed'),
                        style: TextStyle(
                          color: chipFg,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isCurrent)
            SizedBox(
              width: 10,
            ),
          if (isCurrent)
            Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
        ],
      ),
      ),
    );
  }
}

enum _NodeStatus { completed, current, locked }

class _PathNode {
  final String title;
  final _NodeStatus status;

  _PathNode({
    required this.title,
    required this.status,
  });
}

enum _PathItemType { section, lesson }

class _PathItem {
  final _PathItemType type;
  final String title;
  final _NodeStatus? status;

  _PathItem._(this.type, this.title, this.status);

  factory _PathItem.section(String title) => _PathItem._(_PathItemType.section, title, null);
  factory _PathItem.lesson(String title, _NodeStatus status) =>
      _PathItem._(_PathItemType.lesson, title, status);
}

class _SectionSpec {
  final String title;
  final int count;
  _SectionSpec(this.title, this.count);
}


