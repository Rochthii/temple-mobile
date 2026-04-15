import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/temple_context/domain/temple_context_provider.dart';
import '../../features/temple_context/domain/temple_context_state.dart';

class TempleContextBadge extends ConsumerWidget {
  const TempleContextBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(templeContextProvider);
    final theme = Theme.of(context);

    String label = 'Toàn Hệ Sinh Thái';
    Color badgeColor = theme.colorScheme.secondary;
    IconData icon = Icons.public;

    if (state.mode == ContextMode.selectedTemple) {
      label = state.tenantName ?? 'Chùa đã chọn';
      badgeColor = theme.colorScheme.primary;
      icon = Icons.home;
    } else if (state.mode == ContextMode.nearbySuggestion) {
      label = state.tenantName ?? 'Chùa gần bạn';
      badgeColor = theme.colorScheme.error; // Cảnh báo nhẹ
      icon = Icons.location_on;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.15),
            border: Border.all(color: badgeColor.withValues(alpha: 0.3), width: 0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: badgeColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: badgeColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
