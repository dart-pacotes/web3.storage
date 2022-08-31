import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:networking/networking.dart';
import 'package:web3_storage/web3_storage.dart';

///
/// Returns an instance of [Web3Storage] using a single Web3.Storage API token.
///
Web3Storage withApiToken(final String apiToken) {
  return Web3Storage(
    client: Web3StorageNetworkingClient(
      apiToken: apiToken,
      httpClient: Client(),
    ),
  );
}

///
/// An interface to interact with Web3.Storage. Use the [withApiToken] top-level function to get an
/// instance of [Web3Storage] for your api token.
///
/// You can grab an API Token here: https://web3.storage/tokens/
///
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

  ///
  /// Downloads a file from Web3.Storage given the file CID. Currently the file name is assigned to
  /// the CID, as Web3.Storage does not provide a way to get the file name without having to list all
  /// the uploaded files.
  ///
  Future<Either<RequestError, Web3File>> download({
    required final CID cid,
  }) async {
    final result = await client.download(cid: cid);

    return result.fold(
      (r) => Left(r),
      (l) {
        if (l is! ErrorResponse) {
          return Right(
            Web3File(
              cid: cid,
              data: l.body,
              extension: l.contentType.fileExtension,
              name: cid,
            ),
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
