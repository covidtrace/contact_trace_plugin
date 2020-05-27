///
//  Generated code. Do not modify.
//  source: lib/export.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class TemporaryExposureKeyExport extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TemporaryExposureKeyExport', createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'startTimestamp', $pb.PbFieldType.OF6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'endTimestamp', $pb.PbFieldType.OF6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, 'region')
    ..a<$core.int>(4, 'batchNum', $pb.PbFieldType.O3)
    ..a<$core.int>(5, 'batchSize', $pb.PbFieldType.O3)
    ..pc<SignatureInfo>(6, 'signatureInfos', $pb.PbFieldType.PM, subBuilder: SignatureInfo.create)
    ..pc<TemporaryExposureKey>(7, 'keys', $pb.PbFieldType.PM, subBuilder: TemporaryExposureKey.create)
    ..hasRequiredFields = false
  ;

  TemporaryExposureKeyExport._() : super();
  factory TemporaryExposureKeyExport() => create();
  factory TemporaryExposureKeyExport.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TemporaryExposureKeyExport.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  TemporaryExposureKeyExport clone() => TemporaryExposureKeyExport()..mergeFromMessage(this);
  TemporaryExposureKeyExport copyWith(void Function(TemporaryExposureKeyExport) updates) => super.copyWith((message) => updates(message as TemporaryExposureKeyExport));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TemporaryExposureKeyExport create() => TemporaryExposureKeyExport._();
  TemporaryExposureKeyExport createEmptyInstance() => create();
  static $pb.PbList<TemporaryExposureKeyExport> createRepeated() => $pb.PbList<TemporaryExposureKeyExport>();
  @$core.pragma('dart2js:noInline')
  static TemporaryExposureKeyExport getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TemporaryExposureKeyExport>(create);
  static TemporaryExposureKeyExport _defaultInstance;

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

  @$pb.TagNumber(6)
  $core.List<SignatureInfo> get signatureInfos => $_getList(5);

  @$pb.TagNumber(7)
  $core.List<TemporaryExposureKey> get keys => $_getList(6);
}

class SignatureInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SignatureInfo', createEmptyInstance: create)
    ..aOS(1, 'appBundleId')
    ..aOS(2, 'androidPackage')
    ..aOS(3, 'verificationKeyVersion')
    ..aOS(4, 'verificationKeyId')
    ..aOS(5, 'signatureAlgorithm')
    ..hasRequiredFields = false
  ;

  SignatureInfo._() : super();
  factory SignatureInfo() => create();
  factory SignatureInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignatureInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SignatureInfo clone() => SignatureInfo()..mergeFromMessage(this);
  SignatureInfo copyWith(void Function(SignatureInfo) updates) => super.copyWith((message) => updates(message as SignatureInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SignatureInfo create() => SignatureInfo._();
  SignatureInfo createEmptyInstance() => create();
  static $pb.PbList<SignatureInfo> createRepeated() => $pb.PbList<SignatureInfo>();
  @$core.pragma('dart2js:noInline')
  static SignatureInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignatureInfo>(create);
  static SignatureInfo _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get appBundleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set appBundleId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAppBundleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppBundleId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get androidPackage => $_getSZ(1);
  @$pb.TagNumber(2)
  set androidPackage($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAndroidPackage() => $_has(1);
  @$pb.TagNumber(2)
  void clearAndroidPackage() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get verificationKeyVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set verificationKeyVersion($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVerificationKeyVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVerificationKeyVersion() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get verificationKeyId => $_getSZ(3);
  @$pb.TagNumber(4)
  set verificationKeyId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasVerificationKeyId() => $_has(3);
  @$pb.TagNumber(4)
  void clearVerificationKeyId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get signatureAlgorithm => $_getSZ(4);
  @$pb.TagNumber(5)
  set signatureAlgorithm($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSignatureAlgorithm() => $_has(4);
  @$pb.TagNumber(5)
  void clearSignatureAlgorithm() => clearField(5);
}

class TemporaryExposureKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TemporaryExposureKey', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'keyData', $pb.PbFieldType.OY)
    ..a<$core.int>(2, 'transmissionRiskLevel', $pb.PbFieldType.O3)
    ..a<$core.int>(3, 'rollingStartIntervalNumber', $pb.PbFieldType.O3)
    ..a<$core.int>(4, 'rollingPeriod', $pb.PbFieldType.O3, defaultOrMaker: 144)
    ..hasRequiredFields = false
  ;

  TemporaryExposureKey._() : super();
  factory TemporaryExposureKey() => create();
  factory TemporaryExposureKey.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TemporaryExposureKey.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  TemporaryExposureKey clone() => TemporaryExposureKey()..mergeFromMessage(this);
  TemporaryExposureKey copyWith(void Function(TemporaryExposureKey) updates) => super.copyWith((message) => updates(message as TemporaryExposureKey));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TemporaryExposureKey create() => TemporaryExposureKey._();
  TemporaryExposureKey createEmptyInstance() => create();
  static $pb.PbList<TemporaryExposureKey> createRepeated() => $pb.PbList<TemporaryExposureKey>();
  @$core.pragma('dart2js:noInline')
  static TemporaryExposureKey getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TemporaryExposureKey>(create);
  static TemporaryExposureKey _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get keyData => $_getN(0);
  @$pb.TagNumber(1)
  set keyData($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKeyData() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyData() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get transmissionRiskLevel => $_getIZ(1);
  @$pb.TagNumber(2)
  set transmissionRiskLevel($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTransmissionRiskLevel() => $_has(1);
  @$pb.TagNumber(2)
  void clearTransmissionRiskLevel() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get rollingStartIntervalNumber => $_getIZ(2);
  @$pb.TagNumber(3)
  set rollingStartIntervalNumber($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRollingStartIntervalNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearRollingStartIntervalNumber() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get rollingPeriod => $_getI(3, 144);
  @$pb.TagNumber(4)
  set rollingPeriod($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRollingPeriod() => $_has(3);
  @$pb.TagNumber(4)
  void clearRollingPeriod() => clearField(4);
}

class TEKSignatureList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TEKSignatureList', createEmptyInstance: create)
    ..pc<TEKSignature>(1, 'signatures', $pb.PbFieldType.PM, subBuilder: TEKSignature.create)
    ..hasRequiredFields = false
  ;

  TEKSignatureList._() : super();
  factory TEKSignatureList() => create();
  factory TEKSignatureList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TEKSignatureList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  TEKSignatureList clone() => TEKSignatureList()..mergeFromMessage(this);
  TEKSignatureList copyWith(void Function(TEKSignatureList) updates) => super.copyWith((message) => updates(message as TEKSignatureList));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TEKSignatureList create() => TEKSignatureList._();
  TEKSignatureList createEmptyInstance() => create();
  static $pb.PbList<TEKSignatureList> createRepeated() => $pb.PbList<TEKSignatureList>();
  @$core.pragma('dart2js:noInline')
  static TEKSignatureList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TEKSignatureList>(create);
  static TEKSignatureList _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<TEKSignature> get signatures => $_getList(0);
}

class TEKSignature extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TEKSignature', createEmptyInstance: create)
    ..aOM<SignatureInfo>(1, 'signatureInfo', subBuilder: SignatureInfo.create)
    ..a<$core.int>(2, 'batchNum', $pb.PbFieldType.O3)
    ..a<$core.int>(3, 'batchSize', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(4, 'signature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  TEKSignature._() : super();
  factory TEKSignature() => create();
  factory TEKSignature.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TEKSignature.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  TEKSignature clone() => TEKSignature()..mergeFromMessage(this);
  TEKSignature copyWith(void Function(TEKSignature) updates) => super.copyWith((message) => updates(message as TEKSignature));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TEKSignature create() => TEKSignature._();
  TEKSignature createEmptyInstance() => create();
  static $pb.PbList<TEKSignature> createRepeated() => $pb.PbList<TEKSignature>();
  @$core.pragma('dart2js:noInline')
  static TEKSignature getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TEKSignature>(create);
  static TEKSignature _defaultInstance;

  @$pb.TagNumber(1)
  SignatureInfo get signatureInfo => $_getN(0);
  @$pb.TagNumber(1)
  set signatureInfo(SignatureInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSignatureInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignatureInfo() => clearField(1);
  @$pb.TagNumber(1)
  SignatureInfo ensureSignatureInfo() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get batchNum => $_getIZ(1);
  @$pb.TagNumber(2)
  set batchNum($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBatchNum() => $_has(1);
  @$pb.TagNumber(2)
  void clearBatchNum() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get batchSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set batchSize($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBatchSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearBatchSize() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get signature => $_getN(3);
  @$pb.TagNumber(4)
  set signature($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSignature() => $_has(3);
  @$pb.TagNumber(4)
  void clearSignature() => clearField(4);
}

