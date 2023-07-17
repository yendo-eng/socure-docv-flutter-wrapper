import 'package:socure/models/socure_error_result.dart';
import 'package:socure/models/socure_success_result.dart';

typedef OnDocVSuccessCallback = void Function(DocVSuccessResult data);
typedef OnDocVErrorCallback = void Function(DocVErrorResult data);

typedef OnFingerprintSuccessCallback = void Function(String data);
typedef OnFingerprintErrorCallback = void Function(String data);
