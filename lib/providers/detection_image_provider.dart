import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../model/detection_image_model.dart';
import '../model/rectangle_model.dart';

class DetectionImageProvider extends ChangeNotifier {
  List<DetectionImageModel> _imagesList = [];
  int _selectedIndex = 0;
  int? _selectedRectIndex;

  DetectionImageModel? get selectedImage =>
      imagesList.isEmpty ? null : _imagesList[_selectedIndex];
  List<DetectionImageModel> get imagesList => _imagesList;
  int get selectedIndex => _selectedIndex;
  int? get selectedRectIndex => _selectedRectIndex;

  DetectionImageProvider(List<Uint8List> images) {
    _initImage(images);
  }

  Future<void> _initImage(List<Uint8List> imageBytesList) async {
    for (var image in imageBytesList) {
      final codec = await ui.instantiateImageCodec(image);
      final frame = await codec.getNextFrame();
      _imagesList.add(
        DetectionImageModel(
          imageData: image,
          height: frame.image.height.toDouble(),
          width: frame.image.width.toDouble(),
        ),
      );
    }
    notifyListeners();
  }

  void updateSelectedRect(int? index) {
    _selectedRectIndex = index;

    notifyListeners();
  }

  void updateIndex(DetectionImageModel newImage) {
    _selectedIndex = _imagesList.indexOf(newImage);
    notifyListeners();
  }

  void updateImage(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void addRectangle(RectModel rectangle) {
    selectedImage!.addRectangle(rectangle);
    selectedImage!.isSaved = false;
    _selectedRectIndex = selectedImage!.rectangles.length - 1;
    notifyListeners();
  }

  void updateRectangle(int index, RectModel newRectangle) {
    selectedImage!.updateRectangle(index, newRectangle);
    selectedImage!.isSaved = false;
    notifyListeners();
  }

  void next() {
    selectedIndex < _imagesList.length - 1
        ? _selectedIndex += 1
        : _selectedIndex = selectedIndex;
    notifyListeners();
  }

  void previous() {
    selectedIndex > 0 ? _selectedIndex -= 1 : _selectedIndex = selectedIndex;
    notifyListeners();
  }

  void removeRectangle(RectModel rectangle) {
    selectedImage!.removeRectangle(rectangle);
    selectedImage!.isSaved = false;
    _selectedRectIndex = null;
    notifyListeners();
  }

  void saveOne() {
    selectedImage!.save();
    notifyListeners();
  }

  void saveAll() {
    imagesList.forEach((image) {
      image.save();
    });
    notifyListeners();
  }
}
