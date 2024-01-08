import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:socure/utils/callbacks.dart';

import 'socure_method_channel.dart';

abstract class SocurePlatform extends PlatformInterface {
  /// Constructs a SocurePlatform.
  SocurePlatform() : super(token: _token);

  static final Object _token = Object();

  static SocurePlatform _instance = MethodChannelSocure();

  /// The default instance of [SocurePlatform] to use.
  ///
  /// Defaults to [MethodChannelSocure].
  static SocurePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SocurePlatform] when
  /// they register themselves.
  static set instance(SocurePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> socureDocV({
    required String sdkKey,
    required String documentType,
    required String language,
    required OnDocVSuccessCallback onSuccess,
    required OnDocVErrorCallback onError,
  }) {
    throw UnimplementedError('socureDocV() has not been implemented.');
  }

  Future<void> socureFingerprint({
    required String sdkKey,
    required OnFingerprintSuccessCallback onSuccess,
    required OnFingerprintErrorCallback onError,
  }) {
    throw UnimplementedError('socureFingerprint() has not been implemented.');
  }
}
