// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dharma_media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DharmaMediaModel _$DharmaMediaModelFromJson(Map<String, dynamic> json) =>
    _DharmaMediaModel(
      id: json['id'] as String,
      titleVi: json['title_vi'] as String,
      descriptionVi: json['description_vi'] as String?,
      type: json['type'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      fileSize: (json['file_size'] as num?)?.toInt(),
      mimeType: json['mime_type'] as String?,
      viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
      tenantId: json['tenant_id'] as String?,
    );

Map<String, dynamic> _$DharmaMediaModelToJson(_DharmaMediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title_vi': instance.titleVi,
      'description_vi': instance.descriptionVi,
      'type': instance.type,
      'url': instance.url,
      'thumbnail_url': instance.thumbnailUrl,
      'file_size': instance.fileSize,
      'mime_type': instance.mimeType,
      'view_count': instance.viewCount,
      'tenant_id': instance.tenantId,
    };
