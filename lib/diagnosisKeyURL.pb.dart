///
//  Generated code. Do not modify.
//  source: lib/diagnosisKeyURL.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class File extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('File', createEmptyInstance: create)
    ..aOM<Header>(1, 'header', subBuilder: Header.create)
    ..pc<Key>(2, 'key', $pb.PbFieldType.PM, subBuilder: Key.create)
    ..hasRequiredFields = false
  ;

  File._() : super();
  factory File() => create();
  factory File.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  File clone() => File()..mergeFromMessage(this);
  File copyWith(void Function(File) updates) => super.copyWith((message) => updates(message as File));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static File create() => File._();
  File createEmptyInstance() => create();
  static $pb.PbList<File> createRepeated() => $pb.PbList<File>();
  @$core.pragma('dart2js:noInline')
  static File getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File>(create);
  static File _defaultInstance;

  @$pb.TagNumber(1)
  Header get header => $_getN(0);
  @$pb.TagNumber(1)
  set header(Header v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasHeader() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeader() => clearField(1);
  @$pb.TagNumber(1)
  Header ensureHeader() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<Key> get key => $_getList(1);
}

class Header extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Header', createEmptyInstance: create)
    ..aInt64(1, 'startTimestamp', protoName: 'startTimestamp')
    ..aInt64(2, 'endTimestamp', protoName: 'endTimestamp')
    ..aOS(3, 'region')
    ..a<$core.int>(4, 'batchNum', $pb.PbFieldType.O3, protoName: 'batchNum')
    ..a<$core.int>(5, 'batchSize', $pb.PbFieldType.O3, protoName: 'batchSize')
    ..hasRequiredFields = false
  ;

  Header._() : super();
  factory Header() => create();
  factory Header.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Header.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Header clone() => Header()..mergeFromMessage(this);
  Header copyWith(void Function(Header) updates) => super.copyWith((message) => updates(message as Header));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Header create() => Header._();
  Header createEmptyInstance() => create();
  static $pb.PbList<Header> createRepeated() => $pb.PbList<Header>();
  @$core.pragma('dart2js:noInline')
  static Header getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Header>(create);
  static Header _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get startTimestamp => $_getI64(0);
  @$pb.TagNumber(1)
  set startTimestamp($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStartTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartTimestamp() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get endTimestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set endTimestamp($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEndTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndTimestamp() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get region => $_getSZ(2);
  @$pb.TagNumber(3)
  set region($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRegion() => $_has(2);
  @$pb.TagNumber(3)
  void clearRegion() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get batchNum => $_getIZ(3);
  @$pb.TagNumber(4)
  set batchNum($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBatchNum() => $_has(3);
  @$pb.TagNumber(4)
  void clearBatchNum() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get batchSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set batchSize($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasBatchSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearBatchSize() => clearField(5);
}

class Key extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Key', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'keyData', $pb.PbFieldType.OY, protoName: 'keyData')
    ..a<$core.int>(2, 'rollingStartNumber', $pb.PbFieldType.OU3, protoName: 'rollingStartNumber')
    ..a<$core.int>(3, 'rollingPeriod', $pb.PbFieldType.OU3, protoName: 'rollingPeriod')
    ..a<$core.int>(4, 'transmissionRiskLevel', $pb.PbFieldType.O3, protoName: 'transmissionRiskLevel')
    ..hasRequiredFields = false
  ;

  Key._() : super();
  factory Key() => create();
  factory Key.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Key.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Key clone() => Key()..mergeFromMessage(this);
  Key copyWith(void Function(Key) updates) => super.copyWith((message) => updates(message as Key));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Key create() => Key._();
  Key createEmptyInstance() => create();
  static $pb.PbList<Key> createRepeated() => $pb.PbList<Key>();
  @$core.pragma('dart2js:noInline')
  static Key getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Key>(create);
  static Key _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get keyData => $_getN(0);
  @$pb.TagNumber(1)
  set keyData($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKeyData() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyData() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get rollingStartNumber => $_getIZ(1);
  @$pb.TagNumber(2)
  set rollingStartNumber($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRollingStartNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearRollingStartNumber() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get rollingPeriod => $_getIZ(2);
  @$pb.TagNumber(3)
  set rollingPeriod($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRollingPeriod() => $_has(2);
  @$pb.TagNumber(3)
  void clearRollingPeriod() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get transmissionRiskLevel => $_getIZ(3);
  @$pb.TagNumber(4)
  set transmissionRiskLevel($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTransmissionRiskLevel() => $_has(3);
  @$pb.TagNumber(4)
  void clearTransmissionRiskLevel() => clearField(4);
}

