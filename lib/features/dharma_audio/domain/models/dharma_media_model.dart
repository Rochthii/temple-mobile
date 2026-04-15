// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dharma_media_model.freezed.dart';
part 'dharma_media_model.g.dart';

@freezed
abstract class DharmaMediaModel with _$DharmaMediaModel {
  const factory DharmaMediaModel({
    required String id,
    @JsonKey(name: 'title_vi') required String titleVi,
    @JsonKey(name: 'description_vi') String? descriptionVi,
    required String type,
    required String url,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @JsonKey(name: 'file_size') int? fileSize,
    @JsonKey(name: 'mime_type') String? mimeType,
    @JsonKey(name: 'view_count') @Default(0) int viewCount,
    @JsonKey(name: 'tenant_id') String? tenantId,
  }) = _DharmaMediaModel;

  factory DharmaMediaModel.fromJson(Map<String, dynamic> json) => _$DharmaMediaModelFromJson(json);
}
