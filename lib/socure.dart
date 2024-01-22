import 'socure_platform_interface.dart';

class Socure {
  Future<String?> socureDocV({
    required String sdkKey,
    required String documentType,
    required String language,
  }) {
    return SocurePlatform.instance.socureDocV(
      sdkKey: sdkKey,
      documentType: documentType,
      language: language,
    );
  }

  Future<dynamic> socureFingerprint({
    required String sdkKey,
  }) {
    return SocurePlatform.instance.socureFingerprint(
      sdkKey: sdkKey,
    );
  }
}
