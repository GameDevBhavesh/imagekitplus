import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:imagekitplus/imagekitplus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  List<dynamic>? text = ['none text'];
  final _imagekitplusPlugin = Imagekitplus();
  Uint8List? imageBytes;
  List<Map<String, dynamic>>? classification = [
    {
      "text": "unkown",
      "confidence": "0",
    }
  ];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void load() async {
    final ByteData bytes = await rootBundle.load('assets/images.jpeg');
    setState(() {
      imageBytes = bytes.buffer.asUint8List();
    });
  }

  void recognizeText() async {
    text = await Imagekitplus.recognizeText(imageBytes!);
    setState(() {});
  }

  void removebg() async {
    imageBytes = await Imagekitplus.removeBackround(imageBytes!);
    setState(() {});
  }

  void classify() async {
    print("classify 1");
    final result = await Imagekitplus.classifyImage(imageBytes!);
    classification = result!
        .map((e) => {"text": e["text"], "confidence": "${e["confidence"]}"})
        .toList();
    print(classification.toString());
    print("classify 1 end ");
    setState(() {});
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await Imagekitplus.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              Text(_platformVersion),
              Text("Text Recognized : ${text.toString()}"),
              if (imageBytes != null) Image.memory(imageBytes!),
              TextButton(
                  onPressed: () {
                    initPlatformState();
                  },
                  child: Text("load version")),
              TextButton(
                  onPressed: () {
                    load();
                  },
                  child: Text("load")),
              TextButton(
                  onPressed: () {
                    removebg();
                  },
                  child: Text("removebg")),
              TextButton(
                  onPressed: () {
                    classify();
                  },
                  child: Text("classify")),
              TextButton(
                  onPressed: () {
                    recognizeText();
                  },
                  child: Text("Recognize text")),
              if (classification != null)
                for (final c in classification!)
                  Text("${c["text"]} - ${c["confidence"]}")
            ]),
          ),
        ),
      ),
    );
  }
}
