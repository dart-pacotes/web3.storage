import 'package:networking/networking.dart';

extension ContentTypeExtension on ContentType {
  String get fileExtension {
    switch (this) {
      case ContentType.jpeg:
        return 'jpeg';
      case ContentType.json:
        return 'json';
      case ContentType.png:
        return 'png';
      case ContentType.plainText:
        return 'txt';
      case ContentType.formData:
      case ContentType.binary:
      default:
        return 'bin';
    }
  }
}
