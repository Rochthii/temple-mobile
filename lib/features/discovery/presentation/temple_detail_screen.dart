import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/colors.dart';
import '../domain/models/discovery_temple.dart';
import '../../temple_context/domain/temple_context_provider.dart';
import '../../temple_context/data/temple_repository.dart';

class TempleDetailScreen extends ConsumerStatefulWidget {
  final DiscoveryTemple temple;

  const TempleDetailScreen({super.key, required this.temple});

  @override
  ConsumerState<TempleDetailScreen> createState() => _TempleDetailScreenState();
}

class _TempleDetailScreenState extends ConsumerState<TempleDetailScreen> {

  @override
  void initState() {
    super.initState();
    // 1. CHUYỂN NGỮ CẢNH: Thay đổi ngữ cảnh của App sang Chùa này
    // WidgetsBinding.instance.addPostFrameCallback ensures state is modified after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(templeContextProvider.notifier).selectTemple(widget.temple.id, widget.temple.name);
    });
  }

  Future<void> _openGoogleMaps() async {
    if (widget.temple.latitude == null || widget.temple.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chùa chưa cập nhật tọa độ GPS')),
      );
      return;
    }

    final lat = widget.temple.latitude!;
    final lng = widget.temple.longitude!;
    
    // Google Maps Direction URL
    final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể mở Google Maps trên thiết bị này')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 1. Ảnh bìa & Nút quay lại
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hiển thị ảnh thật từ DB bằng URL của cover hoặc avatar
                  Image.network(
                    widget.temple.coverUrl ?? widget.temple.avatarUrl ?? 'https://images.unsplash.com/photo-1596765795079-fd8bb5df308a?q=80&w=2670&auto=format&fit=crop',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: AppColors.primary.withValues(alpha: 0.1)),
                  ),
                  // Lớp phủ tối để dễ đọc chữ
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Text(
                      widget.temple.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Nội dung Chi tiết (Thông tin, Địa chỉ, Nút Chỉ đường)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Địa chỉ & Nút
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: AppColors.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.temple.addressVi ?? 'Địa chỉ đang cập nhật',
                                  style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _openGoogleMaps,
                              icon: const Icon(Icons.directions, color: Colors.white),
                              label: const Text('Chỉ đường (Bản đồ)'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Giao diện Lịch sử và Nội quy lấy trực tiếp từ database
                  ref.watch(templeAboutProvider(widget.temple.id)).when(
                    data: (sections) {
                      final historySection = sections.where((s) => s.key == 'dong-chay-lich-su').firstOrNull;
                      final ruleSection = sections.where((s) => s.key == 'noi-quy-tu-vien').firstOrNull;
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (historySection != null) ...[
                            _buildSectionHeader(historySection.titleVi, Icons.history_edu),
                            const SizedBox(height: 12),
                            _buildDropCapText(
                              context,
                              historySection.contentVi ?? historySection.summaryVi ?? 'Đang cập nhật lịch sử.',
                            ),
                            const SizedBox(height: 24),
                          ],
                          
                          // Trụ trì đương nhiệm (Sẽ cập nhật từ user roles sau)
                          _buildSectionHeader('Ban Hộ tự & Trụ trì', Icons.groups),
                          const SizedBox(height: 12),
                          const Text(
                            'Cập nhật thông tin các bậc tôn túc đương nhiệm, chư Tăng Đại Đức và các vị có thẩm quyền trong Ban Hộ tự.',
                            style: TextStyle(fontSize: 16, height: 1.6, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 24),

                          if (ruleSection != null) ...[
                            _buildSectionHeader(ruleSection.titleVi, Icons.rule_sharp),
                            const SizedBox(height: 12),
                            Text(
                              ruleSection.contentVi ?? ruleSection.summaryVi ?? 'Đang cập nhật nội quy.',
                              style: const TextStyle(fontSize: 16, height: 1.6, color: AppColors.textPrimary),
                            ),
                          ],
                        ]
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    error: (error, _) => Text('Lỗi tải dữ liệu: $error', style: const TextStyle(color: Colors.red)),
                  ),
                  
                  const SizedBox(height: 60),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryDark, size: 28),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  Widget _buildDropCapText(BuildContext context, String text) {
    if (text.isEmpty) return const SizedBox();
    
    final theme = Theme.of(context);
    final firstChar = text.substring(0, 1);
    final rest = text.length > 1 ? text.substring(1) : '';

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: firstChar,
            style: theme.textTheme.displayLarge?.copyWith(
              color: AppColors.primaryDark,
              height: 1.0,
            ),
          ),
          TextSpan(
            text: rest,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.8),
          ),
        ],
      ),
    );
  }
}
