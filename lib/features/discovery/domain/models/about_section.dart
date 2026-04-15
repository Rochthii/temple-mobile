class AboutSection {
  final String id;
  final String key;
  final String titleVi;
  final String? contentVi;
  final String? summaryVi;
  final String? imageUrl;
  final String? tenantId;

  AboutSection({
    required this.id,
    required this.key,
    required this.titleVi,
    this.contentVi,
    this.summaryVi,
    this.imageUrl,
    this.tenantId,
  });

  factory AboutSection.fromJson(Map<String, dynamic> json) {
    return AboutSection(
      id: json['id'] as String,
      key: json['key'] as String,
      titleVi: json['title_vi'] as String,
      contentVi: json['content_vi'] as String?,
      summaryVi: json['summary_vi'] as String?,
      imageUrl: json['image_url'] as String?,
      tenantId: json['tenant_id'] as String?,
    );
  }
}
