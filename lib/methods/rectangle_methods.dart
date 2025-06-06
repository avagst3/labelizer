import 'package:flutter/material.dart';

import '../model/label.dart';
import '../model/rectangle_model.dart';

RectModel createRectangle(Offset start,Offset end,double imageWidth,double imageHeight,Label label, int labelListId){
  double left = start.dx < end.dx ? start.dx : end.dx;
    double top = start.dy < end.dy ? start.dy : end.dy;
    double width = (start.dx - end.dx).abs();
    double height = (start.dy - end.dy).abs();

    if (left < 0) left = 0;
    if (top < 0) top = 0;
    if (left + width > imageWidth) width = imageWidth - left;
    if (top + height > imageHeight) height = imageHeight - top;

    return RectModel(
      left: left,
      top: top,
      width: width,
      height: height,
      label: label,
      labelListId: labelListId,
    );
}

List<double> resizeRectangle(Offset delta, int corner, RectModel rect, double imageWidth,double imageHeight){
    double newLeft = rect.left;
    double newTop = rect.top;
    double newWidth = rect.width;
    double newHeight = rect.height;

    switch (corner) {
        case 0: // Top-left
          newLeft += delta.dx;
          newTop += delta.dy;
          newWidth -= delta.dx;
          newHeight -= delta.dy;
          break;
        case 1: // Top-right
          newTop += delta.dy;
          newWidth += delta.dx;
          newHeight -= delta.dy;
          break;
        case 2: // Bottom-left
          newLeft += delta.dx;
          newWidth -= delta.dx;
          newHeight += delta.dy;
          break;
        case 3: // Bottom-right
          newWidth += delta.dx;
          newHeight += delta.dy;
          break;
      }

      // Ensure minimum size
      if (newWidth < 30) {
        if (corner == 0 || corner == 2) {
          newLeft -= (30 - newWidth); // Adjust left if resizing from left
        }
        newWidth = 30;
      }
      if (newHeight < 30) {
        if (corner == 0 || corner == 1) {
          newTop -= (30 - newHeight); // Adjust top if resizing from top
        }
        newHeight = 30;
      }

      // Clamp within image bounds
      if (newLeft < 0) newLeft = 0;
      if (newTop < 0) newTop = 0;
      if (newLeft + newWidth > imageWidth) newLeft = imageWidth - newWidth;
      if (newTop + newHeight > imageHeight) {
        newTop = imageHeight - newHeight;
      }
    return [newLeft,newTop,newHeight,newWidth];
}