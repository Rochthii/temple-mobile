import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/temple_context_provider.dart';
import '../data/temple_repository.dart';
import '../../../core/theme/colors.dart';

class TemplePickerModal extends ConsumerWidget {
  const TemplePickerModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lắng nghe dữ liệu đổ về từ Supabase Database
    final templesAsyncValue = ref.watch(templesFutureProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Chọn Không gian Chùa',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              onTap: () {
                ref.read(templeContextProvider.notifier).clearTemple();
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              leading: const CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.apps, color: Colors.white, size: 20),
              ),
              title: const Text('Toàn bộ hệ sinh thái'),
              subtitle: const Text('Xem tin tức và pháp âm tổng hợp'),
              trailing: const Icon(Icons.chevron_right, size: 20),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
            child: Divider(height: 1),
          ),
          Expanded(
            child: templesAsyncValue.when(
              data: (temples) {
                if (temples.isEmpty) {
                  return const Center(child: Text('Chưa có dữ liệu chùa.'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: temples.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final temple = temples[index];
                    return ListTile(
                      onTap: () {
                        ref.read(templeContextProvider.notifier).selectTemple(
                              temple.id,
                              temple.name,
                            );
                        Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.background,
                        backgroundImage: temple.avatarUrl != null ? NetworkImage(temple.avatarUrl!) : null,
                        child: temple.avatarUrl == null 
                            ? Icon(Icons.temple_hindu, color: AppColors.primary.withValues(alpha: 0.6), size: 20)
                            : null,
                      ),
                      title: Text(temple.name,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Lỗi: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showTemplePicker(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const TemplePickerModal(),
  );
}
