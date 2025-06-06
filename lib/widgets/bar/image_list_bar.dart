import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/detection_image_provider.dart';

class ImageListBar extends StatelessWidget {
  const ImageListBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black12.withAlpha(10),
      child: Consumer<DetectionImageProvider>(
          builder: (context, detectionImageProvider, _) {
        return SingleChildScrollView(
          child: Column(
            children: detectionImageProvider.imagesList.map(
              (image) {
                var item = InkWell(
                  onTap: () =>
                      context.read<DetectionImageProvider>().updateIndex(image),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.memory(
                        image.imageData,
                        height: 50,
                        width: 50,
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color:
                              image.isSaved ? Colors.greenAccent : Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      )
                    ],
                  ),
                );
                return item;
              },
            ).toList(),
          ),
        );
      }),
    );
  }
}
