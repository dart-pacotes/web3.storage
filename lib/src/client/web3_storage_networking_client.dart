import 'package:dartz/dartz.dart';
import 'package:http/http.dart' hide Request, Response;
import 'package:networking/networking.dart';
import 'package:web3_storage/web3_storage.dart';

const _kUploadEndpoint = '/upload';

const _kFileNameHeader = 'X-NAME';

class Web3StorageNetworkingClient extends NetworkingClient {
  final String apiKey;

  Web3StorageNetworkingClient({
    required Client httpClient,
    required this.apiKey,
  }) : super(
          baseUrl: Uri.parse('https://api.web3.storage'),
          httpClient: httpClient,
        );

  Future<Either<RequestError, Response>> upload({
    required final FileReference file,
  }) {
    final fileName = file.fileName;

    return multipart(
      endpoint: _kUploadEndpoint,
      files: {
        fileName: file.data,
      },
      headers: {
        _kFileNameHeader: fileName,
      },
    );
  }

  @override
  Future<Either<RequestError, Response>> send({
    required final Request request,
  }) {
    return super.send(
      request: request.copyWith(
        headers: {
          ...request.headers,
          'Authorization': 'Bearer $apiKey',
        },
      ),
    );
  }
}
