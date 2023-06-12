// ignore_for_file: unused_field

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
//import 'package:image/image.dart' as img;

class MaliciousApps extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<MaliciousApps> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _dialogTitleController = TextEditingController();
  final _initialDirectoryController = TextEditingController();
  final _fileExtensionController = TextEditingController();
  String? _fileName;
  String? _directoryPath;
  List<PlatformFile>? _paths;
  String? _extension;
  bool _isLoading = false;
  bool _lockParentWindow = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;

  @override
  void initState() {
    super.initState();
    _fileExtensionController
        .addListener(() => _extension = _fileExtensionController.text);
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _userAborted = false;
    });
  }

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        dialogTitle: _dialogTitleController.text,
        initialDirectory: _initialDirectoryController.text,
        lockParentWindow: _lockParentWindow,
      ))
          ?.files;
      //String? fpath = "${_directoryPath!}/${_fileName!}";
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
      _directoryPath =
          _paths != null ? _paths!.map((e) => e.path).toString() : '...';
    });
  }

  void _loadTFModel() async {
    print("In loadTFModel\n");
    var model = 'assets/converted_tflite/model_unquant.tflite';
    var labels = 'assets/converted_tflite/labels.txt';
    await Tflite.loadModel(
        model: model,
        labels: labels,
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
  }

  void runModel() async {
    print("In runModel\n");
    var recognitions = await Tflite.runModelOnImage(
        path: _directoryPath!, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );
    print(recognitions);
    await Tflite.close();
  }

  void _scanFiles() async {
    _resetState();
    try {
      print("In scanFiles\n");
      _loadTFModel();
      runModel();
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.deepPurple,
        ),
      ),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            'Smart Secure',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Configuration',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 400.0),
                      child: SwitchListTile.adaptive(
                        title: Text(
                          'Pick multiple files',
                          textAlign: TextAlign.left,
                        ),
                        onChanged: (bool value) =>
                            setState(() => _multiPick = value),
                        value: _multiPick,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Divider(),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Actions',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: <Widget>[
                      SizedBox(
                        width: 120,
                        child: FloatingActionButton.extended(
                            onPressed: () => _pickFiles(),
                            label:
                                Text(_multiPick ? 'Pick files' : 'Pick file'),
                            icon: const Icon(Icons.description)),
                      ),
                      SizedBox(
                        width: 120,
                        child: FloatingActionButton.extended(
                            onPressed: () => _scanFiles(),
                            label: Text('Scan file'),
                            icon: const Icon(Icons.search_outlined)),
                      ),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'File(s) selected',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Builder(
                  builder: (BuildContext context) => _isLoading
                      ? Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 40.0,
                                  ),
                                  child: const CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          ],
                        )
                      : _userAborted
                          ? Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: SizedBox(
                                      width: 300,
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.error_outline,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 40.0),
                                        title: const Text(
                                          'User has aborted the dialog',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : _paths != null
                              ? Container(
                                  padding: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.50,
                                  child: Scrollbar(
                                    child: ListView.separated(
                                      itemCount:
                                          _paths != null && _paths!.isNotEmpty
                                              ? _paths!.length
                                              : 1,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final bool isMultiPath =
                                            _paths != null &&
                                                _paths!.isNotEmpty;
                                        final String name =
                                            'File $index: ${isMultiPath ? _paths!.map((e) => e.name).toList()[index] : _fileName ?? '...'}';
                                        final path = _paths!
                                            .map((e) => e.path)
                                            .toList()[index]
                                            .toString();

                                        return ListTile(
                                          title: Text(
                                            name,
                                          ),
                                          subtitle: Text(path),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const Divider(),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                ),
                SizedBox(
                  height: 40.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
