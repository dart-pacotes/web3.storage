import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:networking/networking.dart';
import 'package:web3_storage/web3_storage.dart';

const _kDefaultListFilter = ListFilter(
  page: 1,
  size: 10,
  sortRule: SortRule.date,
  sortOrder: SortOrder.desc,
);

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
    required final RawFile file,
  }) async {
    final result = await client.upload(file: file);

    return result.fold(
      (r) => Left(r),
      (l) {
        if (l is JsonResponse) {
          final cid = CIDExtension.fromJson(l.json);

          return Right(
            Web3File.fromRawFile(cid: cid, reference: file),
          );
        } else if (l is ErrorResponse) {
          return Left(
            Web3StorageHttpError.fromErrorResponse(l),
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
  /// Downloads a file from Web3.Storage given the file CID. Currently, only the file
  /// information endpoint returns the file name, so you have the option to skip the name
  /// resolve (i.e., for faster downloads, skip name resolve).
  ///
  Future<Either<RequestError, Web3File>> download({
    required final CID cid,
    bool skipNameResolve = true,
  }) async {
    Web3FileReference? reference;

    if (!skipNameResolve) {
      final infoResult = await info(cid: cid);

      if (infoResult.isRight()) {
        reference = infoResult.toIterable().first;
      } else {
        return Left(
          infoResult.swap().toIterable().first,
        );
      }
    }

    final result = await client.download(cid: cid);

    return result.fold(
      (r) => Left(r),
      (l) {
        if (l is! ErrorResponse) {
          return Right(
            Web3File(
              cid: cid,
              data: l.body,
              extension: reference?.extension ?? l.contentType.fileExtension,
              name: reference?.name ?? cid,
            ),
          );
        } else {
          return Left(
            Web3StorageHttpError.fromErrorResponse(l),
          );
        }
      },
    );
  }

  Future<Either<RequestError, List<Web3FileReference>>> list({
    final ListFilter filters = _kDefaultListFilter,
  }) async {
    final result = await client.list(filters: filters);

    return result.fold(
      (r) => Left(r),
      (l) {
        if (l is JsonResponse) {
          return Right(
            [
              ...l.asJsonArray.map(
                (j) => Web3FileReference.fromJson(j),
              ),
            ],
          );
        } else if (l is ErrorResponse) {
          return Left(
            Web3StorageHttpError.fromErrorResponse(l),
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

  Future<Either<RequestError, Web3FileReference>> info({
    required final CID cid,
  }) async {
    final result = await client.info(cid: cid);

    return result.fold(
      (r) => Left(r),
      (l) {
        if (l is JsonResponse) {
          return Right(
            Web3FileReference.fromJson(l.json),
          );
        } else if (l is ErrorResponse) {
          return Left(
            Web3StorageHttpError.fromErrorResponse(l),
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
