import 'dart:typed_data';

import 'package:web3_storage/web3_storage.dart';

///
/// Models the needed information to represent a file in Web3.Storage.
///
class Web3File extends FileReference {
  final CID cid;

  static Web3File fromReference({
    required final CID cid,
    required final FileReference reference,
  }) {
    return Web3File(
      cid: cid,
      data: reference.data,
      extension: reference.extension,
      name: reference.name,
    );
  }

  const Web3File({
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
/// Models the information needed to reference a file
///
class FileReference {
  final String name;

  final String extension;

  final Uint8List data;

  int get size => data.lengthInBytes;

  String get fileName => '$name.$extension';

  const FileReference({
    required this.name,
    required this.extension,
    required this.data,
  });

  @override
  String toString() {
    return '$runtimeType(filename: $fileName, size: $size)';
  }
}
