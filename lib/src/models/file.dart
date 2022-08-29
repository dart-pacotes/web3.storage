import 'dart:typed_data';

import 'package:web3_storage/web3_storage.dart';

class Web3File extends FileReference {
  final CID cid;

  const Web3File({
    required this.cid,
    required super.data,
    required super.extension,
    required super.name,
  });
}

class FileReference {
  final String name;

  final String extension;

  final Uint8List data;

  int get size => data.lengthInBytes;

  String get pathName => '$name.$extension';

  const FileReference({
    required this.name,
    required this.extension,
    required this.data,
  });
}
