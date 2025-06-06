import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:labelizer/labelizer.dart';
import 'package:labelizer/widgets/bar/labels/labels_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Uint8List>> _imagesFuture;

  @override
  void initState() {
    super.initState();
    _imagesFuture = generateValidTestImages(10); // Generate images only once
  }

  Future<Uint8List> createTestImageBytes(
      {int width = 600, int height = 400}) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    // Fill with random color
    final paint = ui.Paint()
      ..color =
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), paint);

    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    print(byteData!.buffer.asUint8List());
    return byteData!.buffer.asUint8List();
  }

  Future<List<Uint8List>> generateValidTestImages(int count) async {
    var lst = Future.wait(
      List.generate(count, (_) => createTestImageBytes()),
    );
    return lst;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<List<Uint8List>>(
          future: _imagesFuture, // Use the cached future
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading images'));
            }

            final images = snapshot.data!;
            return LabelizerBase(
              images: images,
              imageListViewer: ImageListBar(),
              imageViewer: DetectionImageView(imageHeight: 0.8),
              labelBar: LabelsBar(
                color: Colors.white60,
                height: 50,
                width: 900,
                labels: [
                  Label(Colors.amber, "ping"),
                  Label(Colors.red, "red"),
                  Label(Colors.blueGrey, "bluegray"),
                  Label(Colors.brown, 'brown'),
                  Label(Colors.brown, 'brown'),
                  Label(Colors.brown, 'brown'),
                  Label(Colors.brown, 'brown'),
                  Label(Colors.brown, 'brown'),
                  Label(Colors.brown, 'brown'),
                  Label(Colors.brown, 'brown'),
                  Label(Colors.brown, 'brown'),
                  Label(Colors.brown, 'brown'),
                  Label(Colors.brown, 'brown'),
                  Label(Colors.brown, 'brown'),
                  Label(Colors.brown, 'brown'),
                ],
              ),
              imageSettings: DetectionSettingBar(
                onExportCallBack: (data) {
                  print(data);
                },
                onSaveCallBack: (data) {
                  print(data);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
