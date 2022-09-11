import 'dart:typed_data';

import 'package:web3_storage/web3_storage.dart';

///
/// Models the needed information to represent a file in Web3.Storage
///
class Web3File extends RawFile {
  final CID cid;

  static Web3File fromRawFile({
    required final CID cid,
    required final RawFile reference,
  }) {
    return Web3File(
      cid: cid,
      data: reference.data,
      extension: reference.extension,
      name: reference.name,
    );
  }

  Web3File({
    required this.cid,
    required super.data,
    required super.extension,
    required super.name,
  });

  @override
  String toString() {
    return '$runtimeType(filename: $fileName, size: $size, url: ${cid.web})';
  }
}

///
/// Models the needed information to reference a file in Web3.Storage
///
class Web3FileReference extends FileReference {
  final CID cid;

  const Web3FileReference({
    required this.cid,
    required super.name,
    required super.extension,
    required super.size,
  });

  static Web3FileReference fromJson(Map<String, dynamic> json) {
    final fileName = "${json['name']}";
    final fileNameSplit = fileName.split('.');
    final cid = json['cid'];
    final size = json['dagSize'] ?? 0;

    String name, extension = '';

    if (fileNameSplit.length >= 2) {
      name = fileNameSplit.take(fileNameSplit.length - 1).join('.');
      extension = fileNameSplit.last;
    } else {
      name = fileName;
    }

    return Web3FileReference(
      cid: cid,
      name: name,
      extension: extension,
      size: size,
    );
  }

  @override
  String toString() {
    return '$runtimeType(filename: $fileName, size: $size, url: ${cid.web})';
  }
}

class RawFile extends FileReference {
  final Uint8List data;

  RawFile({
    required final String name,
    required final String extension,
    required this.data,
  }) : super(extension: extension, name: name, size: data.lengthInBytes);
}

///
/// Models the needed information to reference a file
///
class FileReference {
  final String name;

  final String extension;

  final int size;

  String get fileName => '$name${extension.isNotEmpty ? '.$extension' : ''}';

  const FileReference({
    required this.name,
    required this.extension,
    required this.size,
  });

  @override
  String toString() {
    return '$runtimeType(filename: $fileName, size: $size)';
  }
}
