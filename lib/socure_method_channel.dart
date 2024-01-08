import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socure/models/socure_error_result.dart';
import 'package:socure/models/socure_success_result.dart';
import 'package:socure/utils/callbacks.dart';

import 'socure_platform_interface.dart';

/// An implementation of [SocurePlatform] that uses method channels.
class MethodChannelSocure extends SocurePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('socure');

  @override
  Future<void> socureDocV({
    required String sdkKey,
    required String documentType,
    required String language,
    required OnDocVSuccessCallback onSuccess,
    required OnDocVErrorCallback onError,
  }) async {
    final result = await methodChannel.invokeMethod<String>(
      'docV',
      <String, dynamic>{
        'sdkKey': sdkKey,
        'documentType': documentType,
        'language': language,
      },
    );
    if (result != null) {
      Map<String, dynamic> json = jsonDecode(result);
      if (json.containsKey('docUUID')) {
        final docVSuccessResult = DocVSuccessResult.fromJson(json);
        onSuccess(docVSuccessResult);
      } else {
        final docVErrorResult = DocVErrorResult.fromJson(json);
        onError(docVErrorResult);
      }
    }
  }

  @override
  Future<void> socureFingerprint({
    required String sdkKey,
    required OnFingerprintSuccessCallback onSuccess,
    required OnFingerprintErrorCallback onError,
  }) async {
    final result = await methodChannel.invokeMethod<String>(
      'fingerprint',
      <String, dynamic>{
        'sdkKey': sdkKey,
      },
    );
    // Result is JWT or error message
    // Check if contains('.') or can be decoded?
    if (result == null) {
      return onError('Invalid JWT Token.');
    }
    try {
      JwtDecoder.decode(result);
      onSuccess(result);
    } catch (_) {
      onError('Invalid JWT Token.');
    }
  }
}
