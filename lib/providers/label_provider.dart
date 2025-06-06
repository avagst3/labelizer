import 'package:flutter/material.dart';

import '../model/label.dart';

class LabelProvider extends ChangeNotifier {
  bool _isDrawing = false;
  Label? _label;
  int? _labelListId;

  Label? get label => _label;
  bool get isDrawing => _isDrawing;
  int? get labelListId => _labelListId;

  void setNewLabel(Label label, int labelListId) {
    _label = label;
    _labelListId = labelListId;
    _isDrawing = true;
    notifyListeners();
  }

  void notDrawing() {
    _isDrawing = false;
    _label = null;
    _labelListId = null;
    notifyListeners();
  }
}
