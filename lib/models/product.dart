import 'package:flutter/foundation.dart';

class Product {
  final int id;
  final String innerDiameter;
  final String outerDiameter;
  final String thickness;
  final String type;
  final String brand;

  Product({
    required this.id,
    required this.innerDiameter,
    required this.outerDiameter,
    required this.thickness,
    required this.type,
    required this.brand,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    String parseSize(dynamic val) {
      if (val == null) return '0';
      return val.toString().trim();
    }
    
    final rowId = map['rowid'] ?? map['_id'] ?? 0;
    debugPrint('[PRODUCT] fromMap: rowid=$rowId, map keys=${map.keys.toList()}');
    
    return Product(
      id: rowId,
      innerDiameter: parseSize(map['id']),
      outerDiameter: parseSize(map['od']),
      thickness: parseSize(map['thk']),
      type: map['type']?.toString() ?? '',
      brand: map['brand']?.toString() ?? '',
    );
  }

  factory Product.fromMapDynamic(
    Map<String, dynamic> map, {
    required String idCol,
    required String odCol,
    required String thkCol,
  }) {
    String parseSize(dynamic val) {
      if (val == null) return '0';
      return val.toString().trim();
    }

    // Use rowid as primary key to avoid conflict with 'id' dimension column
    final primaryKey = map['rowid'] ?? map['_id'] ?? map['pk'] ?? 0;

    return Product(
      id: primaryKey is int ? primaryKey : int.tryParse(primaryKey.toString()) ?? 0,
      innerDiameter: parseSize(map[idCol]),
      outerDiameter: parseSize(map[odCol]),
      thickness: parseSize(map[thkCol]),
      type: map['type']?.toString() ?? map['seal_type']?.toString() ?? '',
      brand: map['brand']?.toString() ?? map['manufacturer']?.toString() ?? '',
    );
  }

  String get displayName => '$type $innerDiameter-$outerDiameter-$thickness $brand';
}
