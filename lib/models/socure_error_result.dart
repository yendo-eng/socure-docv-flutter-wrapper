import 'dart:convert';

DocVErrorResult docVErrorResultFromJson(String str) =>
    DocVErrorResult.fromJson(json.decode(str));

String docVErrorResultToJson(DocVErrorResult data) =>
    json.encode(data.toJson());

class DocVErrorResult {
  CapturedImages? capturedImages;
  String? errorMessage;
  String? sessionId;
  String? statusCode;

  DocVErrorResult({
    this.capturedImages,
    this.errorMessage,
    this.sessionId,
    this.statusCode,
  });

  factory DocVErrorResult.fromJson(Map<String, dynamic> json) =>
      DocVErrorResult(
        capturedImages: json["capturedImages"] == null
            ? null
            : CapturedImages.fromJson(json["capturedImages"]),
        errorMessage: json["errorMessage"],
        sessionId: json["sessionId"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "capturedImages": capturedImages?.toJson(),
        "errorMessage": errorMessage,
        "sessionId": sessionId,
        "statusCode": statusCode,
      };

  @override
  String toString() {
    return 'DocVErrorResult(capturedImages: ${capturedImages.toString()}, errorMessage: $errorMessage, sessionId: $sessionId, statusCode: $statusCode)';
  }
}

class CapturedImages {
  String? passport;
  CapturedImages({
    this.passport,
  });

  factory CapturedImages.fromJson(Map<String, dynamic> json) => CapturedImages(
        passport: json["passport"],
      );

  Map<String, dynamic> toJson() => {
        "passport": passport,
      };

  @override
  String toString() => 'CapturedImages(passport: $passport)';
}
