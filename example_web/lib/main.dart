import 'package:example_web/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:web3_storage/web3_storage.dart';

const _kImageFileExtensions = ['jpg', 'jpeg', 'png', 'webp'];

// Yes, this is an API token of a dummy account. Be responsible of what you do :)
const _kTextApiToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweDYwN0Y3ZTU2MmNBQzE5NjIxNDEyMjExYjgzRjFjMGNCNzMxMzFFNDEiLCJpc3MiOiJ3ZWIzLXN0b3JhZ2UiLCJpYXQiOjE2NjMwMjIxMzU0OTAsIm5hbWUiOiJ3ZWIzc3RvcmFnZS5kYXJ0IHB1YmxpYyBleGFtcGxlIn0.jIJKm8AfeFowFUBsKL1mMtUadGGu5IB1djTg-iHL7L0';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web3.Storage Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => Web3StorageBloc(
              web3storage: withApiToken(_kTextApiToken),
            )..add(ListUserUploadsEvent()),
          ),
          BlocProvider(
            create: (context) => DeviceBloc(),
          ),
        ],
        child: const MyHomePage(
          title: 'Web3.Storage Demo',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final deviceBloc = context.read<DeviceBloc>();
    final web3StorageBloc = context.read<Web3StorageBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocListener<DeviceBloc, DeviceState>(
        listener: (context, state) {
          if (state is PickFileSuccess) {
            web3StorageBloc.add(
              UploadFileEvent(
                file: state.file,
              ),
            );
          }
        },
        child: BlocConsumer<Web3StorageBloc, Web3StorageState>(
          listener: (context, state) {
            if (state is Web3StorageCallFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error.toString())),
              );
            } else if (state is DownloadFileSuccess) {
              deviceBloc.add(
                SaveFileEvent(
                  file: state.file,
                ),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                ListView.builder(
                  itemBuilder: (context, index) {
                    return Web3FileListTile(
                      file: state.uploadedFiles[index],
                    );
                  },
                  itemCount: state.uploadedFiles.length,
                ),
                if (state is ListUserUploadsInProgress ||
                    state is UploadFileInProgress)
                  const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              _showSetApiTokenDialog(context);
            },
            tooltip: 'Set API Token',
            child: const Icon(Icons.token),
          ),
          const SizedBox(
            width: 16.0,
          ),
          FloatingActionButton(
            onPressed: () {
              deviceBloc.add(
                PickFileEvent(),
              );
            },
            tooltip: 'Upload File',
            child: const Icon(Icons.upload_file),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _showSetApiTokenDialog(final BuildContext context) {
    final apiTokenEditingController = TextEditingController();

    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('API Token'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: apiTokenEditingController,
              ),
              const SizedBox(
                height: 16.0,
              ),
              const SelectableText(
                'You can grab an API Token here: https://web3.storage/tokens/',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                final web3StorageBloc = context.read<Web3StorageBloc>();

                web3StorageBloc.add(
                  UpdateApiTokenEvent(
                    apiToken: apiTokenEditingController.text,
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class Web3FileListTile extends StatelessWidget {
  final Web3FileReference file;

  const Web3FileListTile({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late IconData extensionIcon;
    late bool isImageFile;

    if (_kImageFileExtensions.contains(file.extension)) {
      extensionIcon = Icons.image;
      isImageFile = true;
    } else {
      extensionIcon = Icons.raw_on;
      isImageFile = false;
    }

    return ListTile(
      leading: Icon(extensionIcon),
      title: Text(
        '${file.fileName} (${file.size} bytes)',
      ),
      subtitle: SelectableText(file.cid),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isImageFile)
            TextButton(
              child: const Text(
                'Preview',
              ),
              onPressed: () {
                _showImagePreviewDialog(context, file);
              },
            ),
          TextButton(
            child: const Text(
              'Download',
            ),
            onPressed: () {
              final web3StorageBloc = context.read<Web3StorageBloc>();

              web3StorageBloc.add(
                DownloadFileEvent(cid: file.cid),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showImagePreviewDialog(
    final BuildContext context,
    final Web3FileReference file,
  ) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(file.fileName),
          content: Image.network(
            file.cid.web.toString(),
          ),
        );
      },
    );
  }
}
