import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:networking/networking.dart';
import 'package:web3_storage/web3_storage.dart';

part 'web3_storage_event.dart';
part 'web3_storage_state.dart';

class Web3StorageBloc extends Bloc<Web3StorageEvent, Web3StorageState> {
  late Web3Storage web3storage;

  Web3StorageBloc({
    required this.web3storage,
  }) : super(const Web3StorageInitial(uploadedFiles: [])) {
    on<ListUserUploadsEvent>(
      (event, emit) async {
        emit(
          ListUserUploadsInProgress(
            uploadedFiles: state.uploadedFiles,
          ),
        );

        final result = await web3storage.list();

        emit(
          result.fold(
            (l) => ListUserUploadsFailure(
              uploadedFiles: state.uploadedFiles,
              error: l,
            ),
            (r) => ListUserUploadsSuccess(
              uploadedFiles: r,
            ),
          ),
        );
      },
    );

    on<UploadFileEvent>(
      (event, emit) async {
        emit(
          UploadFileInProgress(
            uploadedFiles: state.uploadedFiles,
          ),
        );

        final result = await web3storage.upload(
          file: event.file,
        );

        emit(
          result.fold(
            (l) => UploadFileFailure(
              uploadedFiles: state.uploadedFiles,
              error: l,
            ),
            (r) => UploadFileSuccess(
              uploadedFiles: [
                if (state.uploadedFiles.where((x) => x.cid == r.cid).isEmpty)
                  Web3FileReference(
                    cid: r.cid,
                    name: r.name,
                    extension: r.extension,
                    size: r.size,
                  ),
                ...state.uploadedFiles,
              ],
              file: r,
            ),
          ),
        );
      },
    );

    on<DownloadFileEvent>(
      (event, emit) async {
        emit(
          DownloadFileInProgress(
            uploadedFiles: state.uploadedFiles,
          ),
        );

        final result = await web3storage.download(
          cid: event.cid,
          skipNameResolve: false,
        );

        emit(
          result.fold(
            (l) => DownloadFileFailure(
              uploadedFiles: state.uploadedFiles,
              error: l,
            ),
            (r) => DownloadFileSuccess(
              uploadedFiles: state.uploadedFiles,
              file: r,
            ),
          ),
        );
      },
    );

    on<UpdateApiTokenEvent>(
      (event, emit) async {
        web3storage = withApiToken(event.apiToken);

        add(
          ListUserUploadsEvent(),
        );
      },
    );
  }
}
