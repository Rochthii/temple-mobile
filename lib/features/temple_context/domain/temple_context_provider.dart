import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/shared_prefs.dart';
import 'temple_context_state.dart';

class TempleContextNotifier extends Notifier<TempleContextState> {
  @override
  TempleContextState build() {
    // Đọc trạng thái đã lưu từ SharedPreferences
    final savedModeStr = SharedPrefs.contextMode;
    final savedId = SharedPrefs.tenantId;
    final savedName = SharedPrefs.tenantName;

    if (savedModeStr != null) {
      final mode = ContextMode.values.firstWhere(
        (e) => e.name == savedModeStr,
        orElse: () => ContextMode.allTemples,
      );
      return TempleContextState(
        mode: mode,
        tenantId: savedId,
        tenantName: savedName,
      );
    }

    return const TempleContextState(mode: ContextMode.allTemples);
  }

  void selectTemple(String id, String name) {
    state = state.copyWith(
      mode: ContextMode.selectedTemple,
      tenantId: id,
      tenantName: name,
    );
    _saveToPrefs();
  }

  void suggestNearbyTemple(String id, String name) {
    if (state.mode != ContextMode.selectedTemple) {
      state = state.copyWith(
        mode: ContextMode.nearbySuggestion,
        tenantId: id,
        tenantName: name,
      );
      _saveToPrefs();
    }
  }

  void clearTemple() {
    state = const TempleContextState(mode: ContextMode.allTemples);
    _saveToPrefs();
  }

  void _saveToPrefs() {
    SharedPrefs.setContextMode(state.mode.name);
    SharedPrefs.setTenantId(state.tenantId);
    SharedPrefs.setTenantName(state.tenantName);
  }
}

final templeContextProvider = NotifierProvider<TempleContextNotifier, TempleContextState>(() {
  return TempleContextNotifier();
});
