import 'dart:typed_data';

import 'rectangle_model.dart';

class DetectionImageModel {
  Uint8List imageData;
  double height;
  double width;
  bool isSaved = false;
  List<RectModel> rectangles = [];

  DetectionImageModel({
    required this.imageData,
    required this.height,
    required this.width,
  });

  void addRectangle(RectModel rectangle) {
    rectangles.add(rectangle);
    isSaved = false;
  }

  void removeRectangle(RectModel rectangle) {
    rectangles.remove(rectangle);
    isSaved = false;
  }

  void updateRectangle(int index, RectModel newRectangle) {
    rectangles[index] = newRectangle;
    isSaved = false;
  }

  int getRectangleIndex(RectModel rectangle) {
    return rectangles.indexOf(rectangle);
  }

  void save() {
    isSaved = true;
  }
}
