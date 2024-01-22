import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socure/models/fingerprint_failure.dart';
import 'package:socure/models/fingerprint_success.dart';

import 'socure_platform_interface.dart';

/// An implementation of [SocurePlatform] that uses method channels.
class MethodChannelSocure extends SocurePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('socure');

  @override
  Future<String?> socureDocV({
    required String sdkKey,
    required String documentType,
    required String language,
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
        return json['docUUID'];
      }
    }

    return null;
  }

  @override
  Future<dynamic> socureFingerprint({
    required String sdkKey,
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
      return null;
    }
    try {
      JwtDecoder.decode(result);
      return FingerprintSuccess(result);
    } catch (_) {
      return FingerprintFailure(result);
    }
  }
}
