/// Active database mapping — only these 4 categories have active databases
/// Format: '{CATEGORY_DISPLAY_NAME}_{UNIT}': '{database_filename}'
const Map<String, String> categoryDbMap = {
  'OIL SEALS_MM': 'oilseals_mm_inventory.db',
  'MONOSEALS_MM': 'monoseals_mm_inventory.db',
  'WIPER SEALS_MM': 'wiperseals_mm_inventory.db',
  'WIPERMONO_MM': 'wipermono_mm_inventory.db',
};

/// Helper function to resolve database filename from category and unit
/// Returns null if the category/unit combination is not active
String? resolveDbFileName(String category, String unit) {
  final key = '${category.toUpperCase()}_${unit.toUpperCase()}';
  return categoryDbMap[key];
}
