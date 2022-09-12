import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_storage/web3_storage.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceBloc() : super(DeviceInitial()) {
    on<PickFileEvent>(
      (event, emit) async {
        emit(
          PickFileInProgress(),
        );

        final result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
        );

        if (result == null || result.count == 0) {
          emit(
            PickFileFailure(),
          );
        } else {
          final pickedFile = result.files.first;
          final pickedFileNameSplit = pickedFile.name.split('.');

          emit(
            PickFileSuccess(
              file: RawFile(
                data: pickedFile.bytes!,
                extension: pickedFile.extension!,
                name: pickedFileNameSplit
                    .take(pickedFileNameSplit.length - 1)
                    .join(),
              ),
            ),
          );
        }
      },
    );

    on<SaveFileEvent>(
      (event, emit) async {
        emit(
          SaveFileInProgress(),
        );

        final result = await FilePicker.platform.saveFile(
          fileName: event.file.fileName,
        );

        if (result == null || result.isEmpty) {
          emit(
            SaveFileFailure(),
          );
        } else {
          emit(
            SaveFileSuccess(),
          );
        }
      },
    );
  }
}
