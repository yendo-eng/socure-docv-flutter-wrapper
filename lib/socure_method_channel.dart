import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
    required OnDocVSuccessCallback onSuccess,
    required OnDocVErrorCallback onError,
  }) async {
    final result = await methodChannel.invokeMethod<String>(
      'docV',
      <String, dynamic>{
        'sdkKey': sdkKey,
        'documentType': documentType,
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
    try {
      _parseJwt(result);
      onSuccess(result!);
    } on JwtException catch (error) {
      onError(error.message);
    }
  }

  Map<String, dynamic> _parseJwt(String? token) {
    if (token == null) {
      throw JwtException('Invalid JWT token');
    }
    final parts = token.split('.');
    if (parts.length != 3) {
      throw JwtException('Invalid JWT token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw JwtException('Invalid JWT payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}

class JwtException implements Exception {
  final String message;

  JwtException(this.message);

  @override
  String toString() {
    return message;
  }
}
