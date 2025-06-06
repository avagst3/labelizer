import 'package:flutter/material.dart';

import 'label.dart';

/// Documentation for RectModel
///
/// Object that contain all data to draw a rectangle
///
/// > * _`@param: [double]`_ - left
/// > * _`@param: [double]`_ - right
/// > * _`@param: [double]`_ - height
/// > * _`@param: [Label]`_ - label
/// > * _`@param: [int]`_ - labelListId
///
/// > _`@returns: [RectModel]`_
class RectModel {
  double left;
  double top;
  double width;
  double height;
  Label label;
  int labelListId;

  RectModel({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.label,
    required this.labelListId,
  });

  /// Documentation for contains
  /// > * _`@param: [Ofset]`_ - point
  ///
  /// > _`@returns: [bool]`_
  bool contains(Offset point) {
    return point.dx >= left &&
        point.dx <= left + width &&
        point.dy >= top &&
        point.dy <= top + height;
  }
}
