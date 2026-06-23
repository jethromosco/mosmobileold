import 'package:flutter/material.dart';
import '../constants/category_structure.dart';
import '../constants/app_colors.dart';
import 'subcategory_screen.dart';

// Category emoji mapping for modern UI
const Map<String, String> categoryEmojis = {
  'OIL SEALS': '🛢️',
  'O-RINGS': '⭕',
  'O-CORDS': '🔗',
  'O-RING KITS': '📦',
  'PACKING SEALS': '🔐',
  'MECHANICAL SHAFT SEALS': '⚙️',
  'LOCK RINGS (CIRCLIPS)': '🔄',
  'V-RINGS': '✓',
  'QUAD RINGS (AIR SEALS)': '💨',
  'PISTON CUPS': '🏆',
  'OIL CAPS': '🧢',
  'RUBBER DIAPHRAGMS': '📄',
  'COUPLING INSERTS': '🔧',
  'IMPELLERS': '🌀',
  'BUSHINGS (FLAT RINGS)': '🛞',
  'VALVE SEALS': '🚪',
  'BALL BEARINGS': '⚪',
  'GREASE & SEALANTS': '🧴',
  'ETC. (SPECIAL)': '🎁',
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isComingSoon(dynamic value) {
    return value == 'coming_soon';
  }

  void _handleComingSoonTap(String categoryName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.lock_outline, color: Colors.white70, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$categoryName coming soon',
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2A2A2A),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(12),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildCategoryCard(String name, dynamic value, int index) {
    final isComingSoon = _isComingSoon(value);
    final emoji = categoryEmojis[name] ?? '📦';
    
    final delay = (index * 50) / 1000;
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(delay, delay + 0.4, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: GestureDetector(
              onTap: isComingSoon
                  ? () => _handleComingSoonTap(name)
                  : () {
                      debugPrint('[APP] Category selected: $name');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubcategoryScreen(category: name),
                        ),
                      );
                    },
              child: Container(
                decoration: BoxDecoration(
                  gradient: isComingSoon
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1A1A1A),
                            Color(0xFF0A0A0A),
                          ],
                        )
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF252525),
                            Color(0xFF1A1A1A),
                          ],
                        ),
                  border: Border.all(
                    color: isComingSoon
                        ? Colors.white.withValues(alpha: 0.08)
                        : AppColors.primary.withValues(alpha: 0.7),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isComingSoon
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Stack(
                  children: [
                    // Background pattern effect
                    if (!isComingSoon)
                      Positioned(
                        right: -20,
                        bottom: -20,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935).withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    // Main content
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Emoji icon
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: isComingSoon
                                ? Colors.white.withValues(alpha: 0.05)
                                : const Color(0xFFE53935).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              emoji,
                              style: TextStyle(
                                fontSize: 40,
                                color: isComingSoon
                                    ? Colors.white38
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Category name
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              name,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isComingSoon
                                    ? Colors.white38
                                    : Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                        if (isComingSoon) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 0.5,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  size: 10,
                                  color: Colors.white38,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Coming Soon',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = categoryStructure.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MOSCO Mobile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.darkBackground,
        surfaceTintColor: Colors.transparent,
      ),
      body: Container(
        color: AppColors.darkBackground,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'All Categories',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Browse ${categories.length} product categories',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.95,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = categories[index];
                    return _buildCategoryCard(
                      category.key,
                      category.value,
                      index,
                    );
                  },
                  childCount: categories.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }
}
