// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dharma_media_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DharmaMediaModel {

 String get id;@JsonKey(name: 'title_vi') String get titleVi;@JsonKey(name: 'description_vi') String? get descriptionVi; String get type; String get url;@JsonKey(name: 'thumbnail_url') String? get thumbnailUrl;@JsonKey(name: 'file_size') int? get fileSize;@JsonKey(name: 'mime_type') String? get mimeType;@JsonKey(name: 'view_count') int get viewCount;@JsonKey(name: 'tenant_id') String? get tenantId;
/// Create a copy of DharmaMediaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DharmaMediaModelCopyWith<DharmaMediaModel> get copyWith => _$DharmaMediaModelCopyWithImpl<DharmaMediaModel>(this as DharmaMediaModel, _$identity);

  /// Serializes this DharmaMediaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DharmaMediaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.type, type) || other.type == type)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,titleVi,descriptionVi,type,url,thumbnailUrl,fileSize,mimeType,viewCount,tenantId);

@override
String toString() {
  return 'DharmaMediaModel(id: $id, titleVi: $titleVi, descriptionVi: $descriptionVi, type: $type, url: $url, thumbnailUrl: $thumbnailUrl, fileSize: $fileSize, mimeType: $mimeType, viewCount: $viewCount, tenantId: $tenantId)';
}


}

/// @nodoc
abstract mixin class $DharmaMediaModelCopyWith<$Res>  {
  factory $DharmaMediaModelCopyWith(DharmaMediaModel value, $Res Function(DharmaMediaModel) _then) = _$DharmaMediaModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'title_vi') String titleVi,@JsonKey(name: 'description_vi') String? descriptionVi, String type, String url,@JsonKey(name: 'thumbnail_url') String? thumbnailUrl,@JsonKey(name: 'file_size') int? fileSize,@JsonKey(name: 'mime_type') String? mimeType,@JsonKey(name: 'view_count') int viewCount,@JsonKey(name: 'tenant_id') String? tenantId
});




}
/// @nodoc
class _$DharmaMediaModelCopyWithImpl<$Res>
    implements $DharmaMediaModelCopyWith<$Res> {
  _$DharmaMediaModelCopyWithImpl(this._self, this._then);

  final DharmaMediaModel _self;
  final $Res Function(DharmaMediaModel) _then;

/// Create a copy of DharmaMediaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? titleVi = null,Object? descriptionVi = freezed,Object? type = null,Object? url = null,Object? thumbnailUrl = freezed,Object? fileSize = freezed,Object? mimeType = freezed,Object? viewCount = null,Object? tenantId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: freezed == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,tenantId: freezed == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DharmaMediaModel].
extension DharmaMediaModelPatterns on DharmaMediaModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DharmaMediaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DharmaMediaModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DharmaMediaModel value)  $default,){
final _that = this;
switch (_that) {
case _DharmaMediaModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DharmaMediaModel value)?  $default,){
final _that = this;
switch (_that) {
case _DharmaMediaModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'title_vi')  String titleVi, @JsonKey(name: 'description_vi')  String? descriptionVi,  String type,  String url, @JsonKey(name: 'thumbnail_url')  String? thumbnailUrl, @JsonKey(name: 'file_size')  int? fileSize, @JsonKey(name: 'mime_type')  String? mimeType, @JsonKey(name: 'view_count')  int viewCount, @JsonKey(name: 'tenant_id')  String? tenantId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DharmaMediaModel() when $default != null:
return $default(_that.id,_that.titleVi,_that.descriptionVi,_that.type,_that.url,_that.thumbnailUrl,_that.fileSize,_that.mimeType,_that.viewCount,_that.tenantId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'title_vi')  String titleVi, @JsonKey(name: 'description_vi')  String? descriptionVi,  String type,  String url, @JsonKey(name: 'thumbnail_url')  String? thumbnailUrl, @JsonKey(name: 'file_size')  int? fileSize, @JsonKey(name: 'mime_type')  String? mimeType, @JsonKey(name: 'view_count')  int viewCount, @JsonKey(name: 'tenant_id')  String? tenantId)  $default,) {final _that = this;
switch (_that) {
case _DharmaMediaModel():
return $default(_that.id,_that.titleVi,_that.descriptionVi,_that.type,_that.url,_that.thumbnailUrl,_that.fileSize,_that.mimeType,_that.viewCount,_that.tenantId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'title_vi')  String titleVi, @JsonKey(name: 'description_vi')  String? descriptionVi,  String type,  String url, @JsonKey(name: 'thumbnail_url')  String? thumbnailUrl, @JsonKey(name: 'file_size')  int? fileSize, @JsonKey(name: 'mime_type')  String? mimeType, @JsonKey(name: 'view_count')  int viewCount, @JsonKey(name: 'tenant_id')  String? tenantId)?  $default,) {final _that = this;
switch (_that) {
case _DharmaMediaModel() when $default != null:
return $default(_that.id,_that.titleVi,_that.descriptionVi,_that.type,_that.url,_that.thumbnailUrl,_that.fileSize,_that.mimeType,_that.viewCount,_that.tenantId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DharmaMediaModel implements DharmaMediaModel {
  const _DharmaMediaModel({required this.id, @JsonKey(name: 'title_vi') required this.titleVi, @JsonKey(name: 'description_vi') this.descriptionVi, required this.type, required this.url, @JsonKey(name: 'thumbnail_url') this.thumbnailUrl, @JsonKey(name: 'file_size') this.fileSize, @JsonKey(name: 'mime_type') this.mimeType, @JsonKey(name: 'view_count') this.viewCount = 0, @JsonKey(name: 'tenant_id') this.tenantId});
  factory _DharmaMediaModel.fromJson(Map<String, dynamic> json) => _$DharmaMediaModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'title_vi') final  String titleVi;
@override@JsonKey(name: 'description_vi') final  String? descriptionVi;
@override final  String type;
@override final  String url;
@override@JsonKey(name: 'thumbnail_url') final  String? thumbnailUrl;
@override@JsonKey(name: 'file_size') final  int? fileSize;
@override@JsonKey(name: 'mime_type') final  String? mimeType;
@override@JsonKey(name: 'view_count') final  int viewCount;
@override@JsonKey(name: 'tenant_id') final  String? tenantId;

/// Create a copy of DharmaMediaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DharmaMediaModelCopyWith<_DharmaMediaModel> get copyWith => __$DharmaMediaModelCopyWithImpl<_DharmaMediaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DharmaMediaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DharmaMediaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.type, type) || other.type == type)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,titleVi,descriptionVi,type,url,thumbnailUrl,fileSize,mimeType,viewCount,tenantId);

@override
String toString() {
  return 'DharmaMediaModel(id: $id, titleVi: $titleVi, descriptionVi: $descriptionVi, type: $type, url: $url, thumbnailUrl: $thumbnailUrl, fileSize: $fileSize, mimeType: $mimeType, viewCount: $viewCount, tenantId: $tenantId)';
}


}

/// @nodoc
abstract mixin class _$DharmaMediaModelCopyWith<$Res> implements $DharmaMediaModelCopyWith<$Res> {
  factory _$DharmaMediaModelCopyWith(_DharmaMediaModel value, $Res Function(_DharmaMediaModel) _then) = __$DharmaMediaModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'title_vi') String titleVi,@JsonKey(name: 'description_vi') String? descriptionVi, String type, String url,@JsonKey(name: 'thumbnail_url') String? thumbnailUrl,@JsonKey(name: 'file_size') int? fileSize,@JsonKey(name: 'mime_type') String? mimeType,@JsonKey(name: 'view_count') int viewCount,@JsonKey(name: 'tenant_id') String? tenantId
});




}
/// @nodoc
class __$DharmaMediaModelCopyWithImpl<$Res>
    implements _$DharmaMediaModelCopyWith<$Res> {
  __$DharmaMediaModelCopyWithImpl(this._self, this._then);

  final _DharmaMediaModel _self;
  final $Res Function(_DharmaMediaModel) _then;

/// Create a copy of DharmaMediaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? titleVi = null,Object? descriptionVi = freezed,Object? type = null,Object? url = null,Object? thumbnailUrl = freezed,Object? fileSize = freezed,Object? mimeType = freezed,Object? viewCount = null,Object? tenantId = freezed,}) {
  return _then(_DharmaMediaModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: freezed == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,tenantId: freezed == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
