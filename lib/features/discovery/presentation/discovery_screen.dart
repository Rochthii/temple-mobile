import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../shared/widgets/temple_context_badge.dart';
import '../domain/discovery_provider.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal() {
    final state = ref.read(discoveryProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('Lọc theo Tỉnh/Thành', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.provinces.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        title: const Text('Toàn quốc (Tất cả)'),
                        onTap: () {
                          ref.read(discoveryProvider.notifier).updateProvinceFilter(null);
                          Navigator.pop(context);
                        },
                      );
                    }
                    final province = state.provinces[index - 1];
                    return ListTile(
                      title: Text(province['name']),
                      onTap: () {
                        ref.read(discoveryProvider.notifier).updateProvinceFilter(province['id']);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(discoveryProvider);

    // Default to Center of Vietnam or user location
    final initialCenter = state.userLocation != null 
        ? LatLng(state.userLocation!.latitude, state.userLocation!.longitude)
        : const LatLng(10.7769, 106.7009); // HCM default

    return Scaffold(
      body: Stack(
        children: [
          // 1. Bản đồ OpenStreetMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.rochthii.app',
              ),
              MarkerLayer(
                markers: state.temples.where((t) => t.latitude != null && t.longitude != null).map((t) {
                  return Marker(
                    point: LatLng(t.latitude!, t.longitude!),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        context.push('/temple/${t.id}', extra: t);
                      },
                      child: const Icon(Icons.location_on, color: AppColors.primary, size: 40),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // 2. Các Overlay UI (Context Badge, Search Bar)
          SafeArea(
            child: Column(
              children: [
                // Context Badge ở trên cùng
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: TempleContextBadge(),
                  ),
                ),
                
                // Floating Search Bar & Filter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.8),
                                border: Border.all(color: AppColors.divider, width: 0.5),
                              ),
                              child: TextField(
                                controller: _searchController,
                                onSubmitted: (value) {
                                  ref.read(discoveryProvider.notifier).updateSearchQuery(value);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Tìm kiếm tự viện...',
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Icons.search, color: AppColors.primaryDark),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      _searchController.clear();
                                      ref.read(discoveryProvider.notifier).updateSearchQuery('');
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface.withValues(alpha: 0.8),
                              border: Border.all(color: AppColors.divider, width: 0.5),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.filter_list, 
                                color: state.selectedProvinceId != null ? AppColors.primary : AppColors.primaryDark
                              ),
                              onPressed: _showFilterModal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Nút định vị lại GPS
          Positioned(
            right: 16,
            bottom: 200, // Cao hơn bottom sheet để không bị che
            child: FloatingActionButton(
              heroTag: 'gps_btn',
              backgroundColor: Colors.white,
              onPressed: () {
                ref.read(discoveryProvider.notifier).refreshLocation();
                if (state.userLocation != null) {
                  _mapController.move(
                    LatLng(state.userLocation!.latitude, state.userLocation!.longitude), 
                    14.0
                  );
                }
              },
              child: const Icon(Icons.my_location, color: AppColors.secondary),
            ),
          ),

          // 4. Draggable Bottom Sheet (Danh sách chùa)
          DraggableScrollableSheet(
            initialChildSize: 0.25,
            minChildSize: 0.1,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95), // Tính năng Glassmorphism
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -2))
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 12),
                    if (state.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(color: AppColors.primary),
                      )
                    else if (state.temples.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('Không tìm thấy chùa nào trong khu vực.', style: TextStyle(color: AppColors.textSecondary)),
                      )
                    else
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: state.temples.length,
                          separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.divider),
                          itemBuilder: (context, index) {
                            final temple = state.temples[index];
                            final distanceKm = (temple.distanceMeters / 1000).toStringAsFixed(1);
                            
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              title: Text(temple.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(temple.addressVi ?? 'Đang cập nhật địa chỉ', style: const TextStyle(color: AppColors.textSecondary)),
                                  const SizedBox(height: 4),
                                  if (temple.distanceMeters > 0)
                                    Row(
                                      children: [
                                        const Icon(Icons.near_me, size: 14, color: AppColors.primary),
                                        const SizedBox(width: 4),
                                        Text('Cách đây $distanceKm km', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                ],
                              ),
                              onTap: () {
                                context.push('/temple/${temple.id}', extra: temple);
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
