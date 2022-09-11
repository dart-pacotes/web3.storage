import 'package:dartz/dartz.dart';
import 'package:http/http.dart' hide Request, Response, get;
import 'package:networking/networking.dart';
import 'package:web3_storage/web3_storage.dart';

const _kNoneCid = 'none';

const _kUploadEndpoint = '/upload';
const _kListUploadsEndpoint = '/user/uploads';

String _fileInformationEndpoint(final CID cid) =>
    '$_kListUploadsEndpoint/${cid.isNotEmpty ? cid : _kNoneCid}';

const _kFileNameHeader = 'X-NAME';

///
/// A networking client to interact with Web3.Storage HTTP API
///
class Web3StorageNetworkingClient extends NetworkingClient {
  final String apiToken;

  Web3StorageNetworkingClient({
    required Client httpClient,
    required this.apiToken,
  }) : super(
          baseUrl: Uri.parse('https://api.web3.storage'),
          httpClient: httpClient,
        );

  Future<Either<RequestError, Response>> upload({
    required final RawFile file,
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

  Future<Either<RequestError, Response>> download({
    required final CID cid,
  }) {
    return send(
      request: Request(
        uri: cid.web,
        verb: HttpVerb.get,
      ),
    );
  }

  Future<Either<RequestError, Response>> list({
    required final ListFilter filters,
  }) {
    return get(
      endpoint: _kListUploadsEndpoint,
      queryParameters: filters.toQueryParameters,
    );
  }

  Future<Either<RequestError, Response>> info({
    required final CID cid,
  }) {
    return get(
      endpoint: _fileInformationEndpoint(cid),
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
          'Authorization': 'Bearer $apiToken',
        },
      ),
    );
  }
}
