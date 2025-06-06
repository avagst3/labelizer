import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:labelizer/providers/detection_image_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/label_provider.dart';

class LabelizerBase extends StatelessWidget {
  const LabelizerBase({
    super.key,
    required this.images,
    required this.imageListViewer,
    required this.imageViewer,
    required this.labelBar,
    required this.imageSettings,
  });
  final List<Uint8List> images;
  final Widget imageListViewer;
  final Widget imageSettings;
  final Widget imageViewer;
  final Widget labelBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LabelProvider()),
          ChangeNotifierProvider(
            create: (context) => DetectionImageProvider(images),
          )
        ],
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 1, child: imageListViewer),
            Flexible(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: imageViewer,
                  ),
                  labelBar,
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: imageSettings,
            ),
          ],
        ),
      ),
    );
  }
}
