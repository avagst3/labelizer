import 'dart:typed_data';

class ClassificationImageModel {
  final Uint8List imageData;
  final double height;
  final double width;
  String? dataClass;

  ClassificationImageModel({
    required this.imageData,
    required this.height,
    required this.width,
    this.dataClass,
  });

  void setClass(String newDataClass) {
    dataClass = newDataClass;
  }

  void removeClass() {
    dataClass = null;
  }
}
