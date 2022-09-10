import 'package:networking/networking.dart';

class Web3StorageHttpError extends HttpError {
  final String name;

  final String message;

  final String type;

  static Web3StorageHttpError fromErrorResponse(
    final ErrorResponse errorResponse,
  ) {
    final httpError = errorResponse.toHttpError;

    final bodyAsJson = errorResponse.json;

    return Web3StorageHttpError._(
      name: bodyAsJson['name'] ?? bodyAsJson['code'] ?? '',
      message: bodyAsJson['message'] ?? '',
      type: httpError.runtimeType.toString(),
      cause: httpError.cause,
      stackTrace: httpError.stackTrace,
      statusCode: errorResponse.statusCode,
    );
  }

  Web3StorageHttpError._({
    required this.name,
    required this.message,
    required this.type,
    required super.cause,
    required super.stackTrace,
    required super.statusCode,
  });

  @override
  String toString() {
    return '$type{name: $name, message: $message}';
  }
}
