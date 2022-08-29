import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:networking/networking.dart';
import 'package:web3_storage/web3_storage.dart';

Web3Storage withApiKey(final String apiKey) {
  return Web3Storage(
    client: Web3StorageNetworkingClient(
      apiKey: apiKey,
      httpClient: Client(),
    ),
  );
}

class Web3Storage {
  final Web3StorageNetworkingClient client;

  const Web3Storage({
    required this.client,
  });

  Future<Either<RequestError, Web3File>> upload({
    required final FileReference file,
  }) async {
    final result = await client.upload(file: file);

    return result.fold(
      (r) => Left(r),
      (l) {
        if (l is JsonResponse) {
          final cid = CIDExtension.fromJson(l.json);

          return Right(
            Web3File.fromReference(cid: cid, reference: file),
          );
        } else {
          return Left(
            UnknownError(
              cause: l.toString(),
              stackTrace: StackTrace.current,
            ),
          );
        }
      },
    );
  }
}
