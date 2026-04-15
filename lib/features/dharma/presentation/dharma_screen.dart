import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class DharmaScreen extends StatelessWidget {
  const DharmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_stories_outlined, size: 80, color: AppColors.primary.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            const Text('Thư viện Pháp âm (Audio)'),
            const Text('Tính năng đang được phát triển...'),
          ],
        ),
      ),
    );
  }
}
