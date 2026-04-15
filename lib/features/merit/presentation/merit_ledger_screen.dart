import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import 'package:go_router/go_router.dart';

class MeritLedgerScreen extends StatelessWidget {
  const MeritLedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data for transparency ledger
    final mockDonations = [
      {
        'name': 'Phật tử Diệu Hạnh',
        'time': '2 giờ trước',
        'amount': '100,000',
        'message': 'Cầu quốc thái dân an, gia đạo bình hòa.',
      },
      {
        'name': 'Phật tử Dao Tâm',
        'time': '5 giờ trước',
        'amount': '50,000',
        'message': 'Hồi hướng công đức cho cửu huyền thất tổ.',
      },
      {
        'name': 'Nặc danh',
        'time': '1 ngày trước',
        'amount': '500,000',
        'message': 'Phát tâm cúng dường Tam Bảo.',
      },
      {
        'name': 'Phật tử Thiện Nhân',
        'time': '2 ngày trước',
        'amount': '2,000,000',
        'message': 'Tu tạo tháp chuông.',
      },
      {
        'name': 'Phật tử Nguyên Trí',
        'time': '3 ngày trước',
        'amount': '100,000',
        'message': '',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background, // Bone White #fcf9f4
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: AppColors.primaryDark,
          onPressed: () => context.pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 48.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sổ Vàng\nCông Đức',
                    style: TextStyle(
                      fontFamily: 'NotoSerif',
                      fontSize: 40,
                      height: 1.2,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Summary Block
                  Text(
                    'TỔNG CÔNG ĐỨC (VNĐ)',
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '150,450,000 ',
                          style: TextStyle(
                            fontFamily: 'NotoSerif',
                            fontSize: 48,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        TextSpan(
                          text: '₫',
                          style: TextStyle(
                            fontFamily: 'NotoSerif',
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary, // Saffron Gold
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Ledger List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = mockDonations[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name']!,
                                    style: const TextStyle(
                                      fontFamily: 'NotoSerif',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['time']!,
                                    style: AppTypography.textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${item['amount']} ',
                                    style: const TextStyle(
                                      fontFamily: 'NotoSerif',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: '₫',
                                    style: TextStyle(
                                      fontFamily: 'NotoSerif',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (item['message']!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Lời nguyện cầu: ${item['message']}',
                            style: const TextStyle(
                              fontFamily: 'NotoSerif',
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
                childCount: mockDonations.length,
              ),
            ),
          ),
          
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 64),
          )
        ],
      ),
    );
  }
}
