import 'package:socure/utils/callbacks.dart';

import 'socure_platform_interface.dart';

class Socure {
  Future<void> socureDocV({
    required String sdkKey,
    required String documentType,
    required String language,
    required OnDocVSuccessCallback onSuccess,
    required OnDocVErrorCallback onError,
  }) {
    return SocurePlatform.instance.socureDocV(
      sdkKey: sdkKey,
      documentType: documentType,
      language: language,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  Future<void> socureFingerprint({
    required String sdkKey,
    required OnFingerprintSuccessCallback onSuccess,
    required OnFingerprintErrorCallback onError,
  }) {
    return SocurePlatform.instance.socureFingerprint(
      sdkKey: sdkKey,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
