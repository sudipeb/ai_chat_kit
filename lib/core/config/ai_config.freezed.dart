// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIConfig {

 String get openAiKey; String get geminiKey; String get claudeKey;
/// Create a copy of AIConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AIConfigCopyWith<AIConfig> get copyWith => _$AIConfigCopyWithImpl<AIConfig>(this as AIConfig, _$identity);

  /// Serializes this AIConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AIConfig&&(identical(other.openAiKey, openAiKey) || other.openAiKey == openAiKey)&&(identical(other.geminiKey, geminiKey) || other.geminiKey == geminiKey)&&(identical(other.claudeKey, claudeKey) || other.claudeKey == claudeKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,openAiKey,geminiKey,claudeKey);

@override
String toString() {
  return 'AIConfig(openAiKey: $openAiKey, geminiKey: $geminiKey, claudeKey: $claudeKey)';
}


}

/// @nodoc
abstract mixin class $AIConfigCopyWith<$Res>  {
  factory $AIConfigCopyWith(AIConfig value, $Res Function(AIConfig) _then) = _$AIConfigCopyWithImpl;
@useResult
$Res call({
 String openAiKey, String geminiKey, String claudeKey
});




}
/// @nodoc
class _$AIConfigCopyWithImpl<$Res>
    implements $AIConfigCopyWith<$Res> {
  _$AIConfigCopyWithImpl(this._self, this._then);

  final AIConfig _self;
  final $Res Function(AIConfig) _then;

/// Create a copy of AIConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? openAiKey = null,Object? geminiKey = null,Object? claudeKey = null,}) {
  return _then(_self.copyWith(
openAiKey: null == openAiKey ? _self.openAiKey : openAiKey // ignore: cast_nullable_to_non_nullable
as String,geminiKey: null == geminiKey ? _self.geminiKey : geminiKey // ignore: cast_nullable_to_non_nullable
as String,claudeKey: null == claudeKey ? _self.claudeKey : claudeKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AIConfig].
extension AIConfigPatterns on AIConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AIConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AIConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AIConfig value)  $default,){
final _that = this;
switch (_that) {
case _AIConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AIConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AIConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String openAiKey,  String geminiKey,  String claudeKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AIConfig() when $default != null:
return $default(_that.openAiKey,_that.geminiKey,_that.claudeKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String openAiKey,  String geminiKey,  String claudeKey)  $default,) {final _that = this;
switch (_that) {
case _AIConfig():
return $default(_that.openAiKey,_that.geminiKey,_that.claudeKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String openAiKey,  String geminiKey,  String claudeKey)?  $default,) {final _that = this;
switch (_that) {
case _AIConfig() when $default != null:
return $default(_that.openAiKey,_that.geminiKey,_that.claudeKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AIConfig extends AIConfig {
  const _AIConfig({required this.openAiKey, required this.geminiKey, required this.claudeKey}): super._();
  factory _AIConfig.fromJson(Map<String, dynamic> json) => _$AIConfigFromJson(json);

@override final  String openAiKey;
@override final  String geminiKey;
@override final  String claudeKey;

/// Create a copy of AIConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AIConfigCopyWith<_AIConfig> get copyWith => __$AIConfigCopyWithImpl<_AIConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AIConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AIConfig&&(identical(other.openAiKey, openAiKey) || other.openAiKey == openAiKey)&&(identical(other.geminiKey, geminiKey) || other.geminiKey == geminiKey)&&(identical(other.claudeKey, claudeKey) || other.claudeKey == claudeKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,openAiKey,geminiKey,claudeKey);

@override
String toString() {
  return 'AIConfig(openAiKey: $openAiKey, geminiKey: $geminiKey, claudeKey: $claudeKey)';
}


}

/// @nodoc
abstract mixin class _$AIConfigCopyWith<$Res> implements $AIConfigCopyWith<$Res> {
  factory _$AIConfigCopyWith(_AIConfig value, $Res Function(_AIConfig) _then) = __$AIConfigCopyWithImpl;
@override @useResult
$Res call({
 String openAiKey, String geminiKey, String claudeKey
});




}
/// @nodoc
class __$AIConfigCopyWithImpl<$Res>
    implements _$AIConfigCopyWith<$Res> {
  __$AIConfigCopyWithImpl(this._self, this._then);

  final _AIConfig _self;
  final $Res Function(_AIConfig) _then;

/// Create a copy of AIConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? openAiKey = null,Object? geminiKey = null,Object? claudeKey = null,}) {
  return _then(_AIConfig(
openAiKey: null == openAiKey ? _self.openAiKey : openAiKey // ignore: cast_nullable_to_non_nullable
as String,geminiKey: null == geminiKey ? _self.geminiKey : geminiKey // ignore: cast_nullable_to_non_nullable
as String,claudeKey: null == claudeKey ? _self.claudeKey : claudeKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
