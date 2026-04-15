import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../temple_context/domain/temple_context_provider.dart';
import '../../temple_context/domain/temple_context_state.dart';
import '../../temple_context/presentation/temple_picker_modal.dart';
import '../../../core/theme/colors.dart';
import '../data/news_repository.dart';
import '../domain/models/news_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templeState = ref.watch(templeContextProvider);
    final theme = Theme.of(context);

    // Xây dựng câu chào Mantra tĩnh tại
    final hour = DateTime.now().hour;
    String greeting = 'Xin chào';
    if (hour < 11) {
      greeting = 'Buổi sáng thanh tịnh';
    } else if (hour < 14) {
      greeting = 'Buổi trưa an lành';
    } else if (hour < 18) {
      greeting = 'Buổi chiều tĩnh lặng';
    } else {
      greeting = 'Buổi tối bình an';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Kéo thêm khoảng trống cho hiệu ứng Glass phía trên
          const SliverToBoxAdapter(child: SizedBox(height: 60)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    templeState.mode == ContextMode.allTemples
                        ? 'Hệ sinh thái Đa Chùa Khmer'
                        : templeState.tenantName ?? '',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 48), // Negative space rộng
                  _buildContextCard(context, templeState),
                  const SizedBox(height: 48),
                  Text(
                    'Tiêu Điểm',
                    style: theme.textTheme.displaySmall,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildNewsFeed(ref, templeState.tenantId),
          const SliverToBoxAdapter(child: SizedBox(height: 80)), // Lót đáy
        ],
      ),
    );
  }

  Widget _buildContextCard(BuildContext context, TempleContextState state) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => showTemplePicker(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider, width: 0.8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(Icons.temple_hindu, color: AppColors.primaryDark, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.mode == ContextMode.allTemples
                        ? 'Đang xem: Toàn hệ thống'
                        : 'Không gian hiện tại',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.mode == ContextMode.allTemples
                        ? 'Khám phá tất cả các chùa Khmer'
                        : (state.tenantName ?? 'Đã chọn chùa'),
                    style: theme.textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsFeed(WidgetRef ref, String? tenantId) {
    return ref.watch(newsFutureProvider(tenantId)).when(
      data: (news) => news.isEmpty
          ? const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text('Chưa có tin tức mới.', style: TextStyle(color: AppColors.textSecondary)),
                ),
              ),
            )
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = news[index];
                  return Column(
                    children: [
                      _buildNewsEditorialCard(context, item),
                      if (index < news.length - 1)
                        const Divider(indent: 24, endIndent: 24),
                    ],
                  );
                },
                childCount: news.length,
              ),
            ),
      loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: AppColors.primary))),
      error: (err, stack) => SliverToBoxAdapter(child: Text('Lỗi: $err')),
    );
  }

  Widget _buildNewsEditorialCard(BuildContext context, NewsModel item) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        context.push('/news/${item.id}', extra: item);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.thumbnailUrl != null)
              Container(
                height: 200,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(item.thumbnailUrl!),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
              ),
            Text(
              item.title,
              style: theme.textTheme.headlineMedium?.copyWith(height: 1.3),
            ),
            const SizedBox(height: 12),
            Text(
              item.excerpt ?? '',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Text(
              "Xem tiếp",
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.primaryDark,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
