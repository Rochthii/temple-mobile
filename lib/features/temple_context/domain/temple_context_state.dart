enum ContextMode {
  allTemples,
  selectedTemple,
  nearbySuggestion,
}

class TempleContextState {
  final ContextMode mode;
  final String? tenantId;
  final String? tenantName;

  const TempleContextState({
    this.mode = ContextMode.allTemples,
    this.tenantId,
    this.tenantName,
  });

  TempleContextState copyWith({
    ContextMode? mode,
    String? tenantId,
    String? tenantName,
  }) {
    return TempleContextState(
      mode: mode ?? this.mode,
      tenantId: tenantId ?? this.tenantId,
      tenantName: tenantName ?? this.tenantName,
    );
  }
}
