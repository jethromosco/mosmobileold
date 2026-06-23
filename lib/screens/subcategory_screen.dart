import 'package:flutter/material.dart';
import '../constants/category_structure.dart';
import '../constants/app_colors.dart';
import 'search_screen.dart';

class SubcategoryScreen extends StatefulWidget {
  final String category;
  final Map<String, dynamic>? subStructure;

  const SubcategoryScreen({
    super.key,
    required this.category,
    this.subStructure,
  });

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Maps subcategory display names to their categoryDbMap keys
  String _resolveDbCategory(String displayName) {
    const Map<String, String> dbCategoryNames = {
      'OIL SEALS': 'OIL SEALS',
      'MONOSEALS': 'MONOSEALS',
      'WIPER SEALS': 'WIPER SEALS',
      'WIPERMONO': 'WIPERMONO',
    };
    return dbCategoryNames[displayName] ?? displayName;
  }

  /// Checks if a value is a coming soon string
  bool _isComingSoon(dynamic value) {
    return value == 'coming_soon';
  }

  /// Checks if children are units (MM/INCH) or more subcategories
  bool _isUnitLevel(Map<String, dynamic> map) {
    return map.keys.every((k) => k == 'MM' || k == 'INCH');
  }

  /// Handle tap on a category/subcategory item
  void _handleTap(String key, dynamic value) {
    if (_isComingSoon(value)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.lock_outline, color: Colors.white70, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$key coming soon',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.disabledBackground,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(12),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Handle direct unit tap (key is MM or INCH with string value 'active')
    if ((key == 'MM' || key == 'INCH') && value is String && value == 'active') {
      final dbCategory = _resolveDbCategory(widget.category);
      debugPrint('[APP] Navigating to search: $dbCategory $key');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchScreen(
            category: dbCategory,
            unit: key,
          ),
        ),
      );
      return;
    }

    if (value is Map<String, dynamic>) {
      if (_isUnitLevel(value)) {
        // Show unit selection
        _showUnitSelection(key, value);
      } else {
        // Navigate deeper into subcategories
        debugPrint('[APP] Navigating to subcategory: $key');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SubcategoryScreen(
              category: key,
              subStructure: value,
            ),
          ),
        );
      }
    }
  }

  /// Show bottom sheet with unit selection
  void _showUnitSelection(String categoryName, Map<String, dynamic> units) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              categoryName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose a measurement unit',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ...units.entries.map((entry) {
              final isActive = entry.value == 'active';
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isActive
                        ? AppColors.primary
                        : AppColors.disabledBackground,
                    foregroundColor:
                        isActive ? Colors.white : Colors.white38,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: isActive ? 4 : 0,
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (isActive) {
                      final dbCategory = _resolveDbCategory(categoryName);
                      debugPrint(
                        '[APP] Navigating to search: $dbCategory ${entry.key}',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SearchScreen(
                            category: dbCategory,
                            unit: entry.key,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.lock_outline, color: Colors.white70, size: 18),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${entry.key} coming soon',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: AppColors.disabledBackground,
                          duration: const Duration(seconds: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.all(12),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (!isActive)
                        const Icon(Icons.lock_outline, size: 18),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the structure for this category
    final structure =
        widget.subStructure ?? (categoryStructure[widget.category] as Map<String, dynamic>?);

    if (structure == null || _isComingSoon(structure)) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.category),
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.surfaceBackground,
          surfaceTintColor: Colors.transparent,
        ),
        body: Container(
          color: AppColors.surfaceBackground,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.construction_outlined,
                      size: 36,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.category,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Available in a future update',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Determine header text based on structure
    final isUnitLevel = _isUnitLevel(structure);
    final headerText = isUnitLevel ? 'Select Unit' : 'Select Option';
    final itemCount = structure.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
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
                    Text(
                      headerText,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isUnitLevel
                          ? 'Choose a measurement type'
                          : 'Choose an option to continue',
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
                    final entry = structure.entries.elementAt(index);
                    final isComingSoon = _isComingSoon(entry.value);
                    
                    final delay = (index * 50) / 1000;
                    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Interval(delay, delay + 0.3, curve: Curves.easeOut),
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
                              onTap: () => _handleTap(entry.key, entry.value),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: isComingSoon
                                      ? const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF1A1A1A),
                                            Color(0xFF0F0F0F),
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
                                        ? Colors.white.withValues(alpha: 0.1)
                                        : AppColors.primary.withValues(alpha: 0.6),
                                    width: 2.5,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: isComingSoon
                                      ? []
                                      : [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(alpha: 0.15),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                ),
                                child: Stack(
                                  children: [
                                    if (!isComingSoon)
                                      Positioned(
                                        right: -20,
                                        bottom: -20,
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.05),
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                        ),
                                      ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        if (isComingSoon)
                                          Container(
                                            width: 64,
                                            height: 64,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.08),
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.lock_outline,
                                                size: 32,
                                                color: Colors.white38,
                                              ),
                                            ),
                                          )
                                        else
                                          Container(
                                            width: 64,
                                            height: 64,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.check_circle_outline,
                                                size: 32,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        const SizedBox(height: 16),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 6),
                                            child: Text(
                                              entry.key,
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
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.08),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'Soon',
                                              style: TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white38,
                                              ),
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
                  },
                  childCount: itemCount,
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
