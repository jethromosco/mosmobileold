/// Centralized color definitions for consistent UI/UX
library app_colors;

import 'package:flutter/material.dart';

class AppColors {
  // Primary brand color - darker red for better contrast
  static const Color primary = Color(0xFFD32F2F); // Darker red

  // Background colors - blacker blacks for depth
  static const Color darkBackground = Color(0xFF0A0A0A); // Blacker primary
  static const Color surfaceBackground = Color(0xFF1A1A1A); // Secondary surface
  static const Color cardBackground = Color(0xFF1A1A1A); // Card/elevated surface
  static const Color disabledBackground = Color(0xFF2A2A2A); // Disabled state

  // Semantic colors
  static const Color stockGood = Color(0xFF66BB6A);
  static const Color stockLow = Color(0xFFFFA726);
  static const Color stockEmpty = Color(0xFFD32F2F); // Use primary dark red

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textMuted = Color(0xFF888888);
  static const Color textDisabled = Color(0xFF666666);

  // Border colors
  static const Color borderActive = Color(0xFFD32F2F); // Primary darker
  static const Color borderInactive = Color(0xFF3A3A3A);
  static const Color borderDivider = Color(0xFF2A2A2A);

  // Special colors
  static const Color lockColor = Color(0xFF888888);
  static const Color badgeBackground = Color(0xFF2A2A2A);

  // Coming soon state
  static const Color comingSoonText = Color(0xFF888888);
  static const Color comingSoonBackground = Color(0xFF0F0F0F);
  static const Color comingSoonOverlay = Color(0xFF1A1A1A);
}
