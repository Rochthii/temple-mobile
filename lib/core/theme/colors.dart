import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Premium Zen Mode - Saffron, Mahogany, Bone White
  static const Color background = Color(0xFFF9F6F0); // Bone White - Giấy dó
  static const Color primary = Color(0xFFE28743);    // Saffron Gold - Vàng nghệ nguyên bản
  static const Color primaryLight = Color(0xFFF3A66B);
  static const Color primaryDark = Color(0xFFB8662B);
  static const Color secondary = Color(0xFF2D1E17);  // Deep Mahogany - Nâu gỗ kiến trúc cổ
  static const Color secondaryLight = Color(0xFF523B30);
  static const Color surface = Color(0xFFF2EBE1);    // Parchment - Màu giấy da, dùng cho thẻ
  static const Color surfaceBright = Color(0xFFFDFBF7); // Trắng sáng hơn một chút
  static const Color textPrimary = Color(0xFF2D1E17); // Nâu đen dịu mắt thay vì đen kịt
  static const Color textSecondary = Color(0xFF7A6B63);
  static const Color divider = Color(0xFFE3DACD);
  static const Color error = Color(0xFFB74134);      // Đỏ trầm son mài
  static const Color success = Color(0xFF4A7C59);    // Xanh rêu cổ

  // Glassmorphism helper
  static Color glass(Color color, double opacity) => color.withValues(alpha: opacity);
}
