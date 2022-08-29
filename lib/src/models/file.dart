import 'dart:typed_data';

import 'package:web3_storage/web3_storage.dart';

final _w3linkBaseUri = Uri.parse('https://w3s.link/ipfs/');

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

  Uri get url => _w3linkBaseUri.resolve(cid);

  @override
  String toString() {
    return '$runtimeType(filename: $fileName, size: $size, url: $url)';
  }
}

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
