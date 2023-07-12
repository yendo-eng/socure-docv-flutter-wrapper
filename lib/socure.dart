import 'package:socure/utils/callbacks.dart';

import 'socure_platform_interface.dart';

class Socure {
  // final OnSuccessCallbak
  Future<void> launchSocure({
    required String sdkKey,
    required String documentType,
    required OnSuccessCallback onSuccess,
    required OnErrorCallback onError,
  }) {
    return SocurePlatform.instance.launchSocure(
      sdkKey: sdkKey,
      documentType: documentType,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
