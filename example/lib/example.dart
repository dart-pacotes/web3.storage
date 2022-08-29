import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:web3_storage/web3_storage.dart';

void main() async {
  // You can grab an API Token here: https://web3.storage/tokens/
  final String apiToken = '<web3.storage_api_token>';

  final web3Storage = withApiToken(apiToken);

  // Create file reference model of what will be uploaded to Web3.storage
  final file = FileReference(
    name: 'hello',
    extension: 'txt',
    data: Uint8List.fromList(
      utf8.encode('Hello world'),
    ),
  );

  // Upload it
  final result = await web3Storage.upload(file: file);

  // Tadaaaaam! It should print your Web3 file IPFS CID
  print(result);

  exit(0);
}
