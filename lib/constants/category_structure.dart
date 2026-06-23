/// Full category and subcategory structure for MOSCO Mobile
/// Matches the desktop app's home_page.py structure
/// Status values: 'active', 'coming_soon'
library category_structure;

const Map<String, dynamic> categoryStructure = {
  'OIL SEALS': {
    'MM': 'active',
    'INCH': 'coming_soon',
  },
  'O-RINGS': {
    'NITRILE (NBR)': {
      'MM': 'coming_soon',
      'INCH': 'coming_soon',
    },
    'SILICONE': {
      'MM': 'coming_soon',
      'INCH': 'coming_soon',
    },
    'VITON (FKM)': {
      'MM': 'coming_soon',
      'INCH': 'coming_soon',
    },
  },
  'O-CORDS': {
    'NITRILE (NBR)': 'coming_soon',
    'SILICONE': 'coming_soon',
    'VITON (FKM)': 'coming_soon',
    'POLYCORD': 'coming_soon',
  },
  'O-RING KITS': 'coming_soon',
  'PACKING SEALS': {
    'MONOSEALS': {
      'MM': 'active',
      'INCH': 'coming_soon',
    },
    'WIPER SEALS': {
      'MM': 'active',
      'INCH': 'coming_soon',
    },
    'WIPERMONO': {
      'MM': 'active',
      'INCH': 'coming_soon',
    },
    'VEE PACKING': {
      'MM': 'coming_soon',
      'INCH': 'coming_soon',
    },
    'ZF PACKING': 'coming_soon',
  },
  'MECHANICAL SHAFT SEALS': 'coming_soon',
  'LOCK RINGS (CIRCLIPS)': {
    'INTERNAL': {
      'MM': 'coming_soon',
      'INCH': 'coming_soon',
    },
    'EXTERNAL': {
      'MM': 'coming_soon',
      'INCH': 'coming_soon',
    },
    'E-RINGS': 'coming_soon',
  },
  'V-RINGS': {
    'VS': 'coming_soon',
    'VA': 'coming_soon',
    'VL': 'coming_soon',
  },
  'QUAD RINGS (AIR SEALS)': {
    'MM': 'coming_soon',
    'INCH': 'coming_soon',
  },
  'PISTON CUPS': {
    'PISTON CUPS': 'coming_soon',
    'DOUBLE ACTION': 'coming_soon',
  },
  'OIL CAPS': 'coming_soon',
  'RUBBER DIAPHRAGMS': 'coming_soon',
  'COUPLING INSERTS': 'coming_soon',
  'IMPELLERS': 'coming_soon',
  'BUSHINGS (FLAT RINGS)': 'coming_soon',
  'VALVE SEALS': {
    'MM': 'coming_soon',
    'INCH': 'coming_soon',
  },
  'BALL BEARINGS': 'coming_soon',
  'GREASE & SEALANTS': 'coming_soon',
  'ETC. (SPECIAL)': 'coming_soon',
};
