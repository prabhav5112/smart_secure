// ignore_for_file: unused_field
import 'package:flutter/material.dart';

class MaliciousUrls extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _URLInputScreenState createState() => _URLInputScreenState();
}

class _URLInputScreenState extends State<MaliciousUrls> {
  TextEditingController _urlController = TextEditingController();
  String _enteredURL = '';

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _scanURL() {
    setState(() {
      _enteredURL = _urlController.text;
    });

    // Do something with the entered URL, such as making an API request or opening a web view.
    // For demonstration purposes, let's just print the URL.
    print('Entered URL: $_enteredURL');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.deepPurple,
        ),
      ),
      home: Scaffold(
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
                TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    labelText: 'Enter URL',
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
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
                            onPressed: () => _scanURL(),
                            label: Text('Scan URL'),
                            icon: const Icon(Icons.search_outlined)),
                      ),
                    ],
                  ),
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
