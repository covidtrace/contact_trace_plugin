///
//  Generated code. Do not modify.
//  source: lib/export.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const TemporaryExposureKeyExport$json = const {
  '1': 'TemporaryExposureKeyExport',
  '2': const [
    const {'1': 'start_timestamp', '3': 1, '4': 1, '5': 6, '10': 'startTimestamp'},
    const {'1': 'end_timestamp', '3': 2, '4': 1, '5': 6, '10': 'endTimestamp'},
    const {'1': 'region', '3': 3, '4': 1, '5': 9, '10': 'region'},
    const {'1': 'batch_num', '3': 4, '4': 1, '5': 5, '10': 'batchNum'},
    const {'1': 'batch_size', '3': 5, '4': 1, '5': 5, '10': 'batchSize'},
    const {'1': 'signature_infos', '3': 6, '4': 3, '5': 11, '6': '.SignatureInfo', '10': 'signatureInfos'},
    const {'1': 'keys', '3': 7, '4': 3, '5': 11, '6': '.TemporaryExposureKey', '10': 'keys'},
  ],
};

const SignatureInfo$json = const {
  '1': 'SignatureInfo',
  '2': const [
    const {'1': 'app_bundle_id', '3': 1, '4': 1, '5': 9, '10': 'appBundleId'},
    const {'1': 'android_package', '3': 2, '4': 1, '5': 9, '10': 'androidPackage'},
    const {'1': 'verification_key_version', '3': 3, '4': 1, '5': 9, '10': 'verificationKeyVersion'},
    const {'1': 'verification_key_id', '3': 4, '4': 1, '5': 9, '10': 'verificationKeyId'},
    const {'1': 'signature_algorithm', '3': 5, '4': 1, '5': 9, '10': 'signatureAlgorithm'},
  ],
};

const TemporaryExposureKey$json = const {
  '1': 'TemporaryExposureKey',
  '2': const [
    const {'1': 'key_data', '3': 1, '4': 1, '5': 12, '10': 'keyData'},
    const {'1': 'transmission_risk_level', '3': 2, '4': 1, '5': 5, '10': 'transmissionRiskLevel'},
    const {'1': 'rolling_start_interval_number', '3': 3, '4': 1, '5': 5, '10': 'rollingStartIntervalNumber'},
    const {'1': 'rolling_period', '3': 4, '4': 1, '5': 5, '7': '144', '10': 'rollingPeriod'},
  ],
};

const TEKSignatureList$json = const {
  '1': 'TEKSignatureList',
  '2': const [
    const {'1': 'signatures', '3': 1, '4': 3, '5': 11, '6': '.TEKSignature', '10': 'signatures'},
  ],
};

const TEKSignature$json = const {
  '1': 'TEKSignature',
  '2': const [
    const {'1': 'signature_info', '3': 1, '4': 1, '5': 11, '6': '.SignatureInfo', '10': 'signatureInfo'},
    const {'1': 'batch_num', '3': 2, '4': 1, '5': 5, '10': 'batchNum'},
    const {'1': 'batch_size', '3': 3, '4': 1, '5': 5, '10': 'batchSize'},
    const {'1': 'signature', '3': 4, '4': 1, '5': 12, '10': 'signature'},
  ],
};

