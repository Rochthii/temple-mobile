class NewsModel {
  final String id;
  final String title;
  final String? excerpt;
  final String? content;
  final String? thumbnailUrl;
  final DateTime? publishedAt;
  final String? tenantId;

  NewsModel({
    required this.id,
    required this.title,
    this.excerpt,
    this.content,
    this.thumbnailUrl,
    this.publishedAt,
    this.tenantId,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as String,
      title: json['title_vi'] as String,
      excerpt: json['excerpt_vi'] as String?,
      content: json['content_vi'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      publishedAt: json['published_at'] != null 
          ? DateTime.parse(json['published_at'] as String)
          : null,
      tenantId: json['tenant_id'] as String?,
    );
  }
}
