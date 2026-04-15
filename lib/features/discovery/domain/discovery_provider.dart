import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/discovery_repository.dart';
import 'models/discovery_temple.dart';

final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  return DiscoveryRepository(Supabase.instance.client);
});

// State class for Discovery Map
class DiscoveryState {
  final bool isLoading;
  final Position? userLocation;
  final List<DiscoveryTemple> temples;
  final String? searchQuery;
  final String? selectedProvinceId;
  final List<Map<String, dynamic>> provinces;
  final String? error;

  const DiscoveryState({
    this.isLoading = false,
    this.userLocation,
    this.temples = const [],
    this.searchQuery,
    this.selectedProvinceId,
    this.provinces = const [],
    this.error,
  });

  DiscoveryState copyWith({
    bool? isLoading,
    Position? userLocation,
    List<DiscoveryTemple>? temples,
    String? searchQuery,
    String? selectedProvinceId,
    List<Map<String, dynamic>>? provinces,
    String? error,
    bool clearError = false,
  }) {
    return DiscoveryState(
      isLoading: isLoading ?? this.isLoading,
      userLocation: userLocation ?? this.userLocation,
      temples: temples ?? this.temples,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedProvinceId: selectedProvinceId ?? this.selectedProvinceId,
      provinces: provinces ?? this.provinces,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class DiscoveryNotifier extends Notifier<DiscoveryState> {
  late final DiscoveryRepository _repository;

  @override
  DiscoveryState build() {
    _repository = ref.read(discoveryRepositoryProvider);
    Future.microtask(() => _init());
    return const DiscoveryState();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final provinces = await _repository.getProvinces();
      
      Position? position;
      try {
        position = await _determinePosition();
      } catch (e) {
        // Ignored, will use default location
      }

      state = state.copyWith(provinces: provinces, userLocation: position);

      await searchTemples();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Dịch vụ định vị đã bị tắt.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Quyền vị trí bị từ chối');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Quyền vị trí bị từ chối vĩnh viễn, không thể yêu cầu quyền.');
    } 

    return await Geolocator.getCurrentPosition();
  }

  Future<void> searchTemples() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final lat = state.userLocation?.latitude ?? 10.7769;
      final lng = state.userLocation?.longitude ?? 106.7009;

      final results = await _repository.searchNearbyTemples(
        userLat: lat,
        userLong: lng,
        searchQuery: state.searchQuery,
        provinceId: state.selectedProvinceId,
      );

      state = state.copyWith(isLoading: false, temples: results);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    searchTemples();
  }

  void updateProvinceFilter(String? provinceId) {
    state = state.copyWith(selectedProvinceId: provinceId);
    searchTemples();
  }

  void refreshLocation() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final position = await _determinePosition();
      state = state.copyWith(userLocation: position);
      await searchTemples();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final discoveryProvider = NotifierProvider<DiscoveryNotifier, DiscoveryState>(() {
  return DiscoveryNotifier();
});
