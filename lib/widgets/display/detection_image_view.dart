import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../methods/rectangle_methods.dart';
import '../../model/detection_image_model.dart';
import '../../model/rectangle_model.dart';
import '../../providers/detection_image_provider.dart';
import '../../providers/label_provider.dart';
import '../components/resize_target.dart';

class DetectionImageView extends StatefulWidget {
  const DetectionImageView(
      {super.key, required this.imageHeight, this.maxScale = 100});

  final double imageHeight;
  final double maxScale;

  @override
  State<DetectionImageView> createState() => _DetectionImageViewState();
}

class _DetectionImageViewState extends State<DetectionImageView> {
  Offset? startPoint;
  Offset? currentPoint;

  void _moveSelectedRect(Offset delta, RectModel rect, double imageWidth,
      double imageHeight, int? selectedRectangleIndex) {
    if (selectedRectangleIndex == null) return;

    setState(() {
      rect.left += delta.dx;
      rect.top += delta.dy;

      // Clamp position within image bounds
      if (rect.left < 0) rect.left = 0;
      if (rect.top < 0) rect.top = 0;
      if (rect.left + rect.width > imageWidth) {
        rect.left = imageWidth - rect.width;
      }
      if (rect.top + rect.height > imageHeight) {
        rect.top = imageHeight - rect.height;
      }
    });
  }

  void _resizeSelectedRect(Offset delta, int corner, RectModel rect,
      double imageWidth, double imageHeight, int? selectedRectangleIndex) {
    if (selectedRectangleIndex == null) return;

    setState(() {
      List<double> newDim =
          resizeRectangle(delta, corner, rect, imageWidth, imageHeight);

      rect.left = newDim[0];
      rect.top = newDim[1];
      rect.width = newDim[3];
      rect.height = newDim[2];
    });
  }

  @override
  Widget build(BuildContext context) {
    double imageHeight =
        MediaQuery.of(context).size.height * widget.imageHeight;
    return Consumer<DetectionImageProvider>(
      builder: (context, detectionImageProvider, _) {
        int index = detectionImageProvider.selectedIndex;
        if (detectionImageProvider.imagesList.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          DetectionImageModel detectionImageModel =
              detectionImageProvider.imagesList[index];
          double baseWidth = detectionImageModel.width;
          double baseHeight = detectionImageModel.height;
          double imageWidth = baseWidth * (imageHeight / baseHeight);
          int? selectedRectangleIndex =
              detectionImageProvider.selectedRectIndex;
          return SizedBox(
            height: imageHeight,
            width: imageWidth,
            child: InteractiveViewer(
              minScale: 1,
              maxScale: widget.maxScale,
              constrained: false,
              child: SizedBox(
                height: imageHeight,
                width: imageWidth,
                child: Consumer<LabelProvider>(
                  builder: (context, labelProvider, _) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanStart: (details) {
                        if (!labelProvider.isDrawing) return;
                        final localPos = details.localPosition;
                        if (localPos.dx < 0 ||
                            localPos.dx > imageWidth ||
                            localPos.dy < 0 ||
                            localPos.dy > imageHeight) {
                          return;
                        }
                        setState(() {
                          startPoint = localPos;
                          currentPoint = localPos;
                        });
                      },
                      onPanUpdate: (details) {
                        if (!labelProvider.isDrawing || startPoint == null) {
                          return;
                        }
                        final localPos = details.localPosition;
                        setState(() {
                          currentPoint = Offset(
                            localPos.dx.clamp(0, imageWidth),
                            localPos.dy.clamp(0, imageHeight),
                          );
                        });
                      },
                      onPanEnd: (details) {
                        if (!labelProvider.isDrawing ||
                            startPoint == null ||
                            currentPoint == null) {
                          return;
                        }
                        final newRect = createRectangle(
                          startPoint!,
                          currentPoint!,
                          imageWidth,
                          imageHeight,
                          labelProvider.label!,
                          labelProvider.labelListId!,
                        );
                        context
                            .read<DetectionImageProvider>()
                            .addRectangle(newRect);
                        setState(() {
                          startPoint = null;
                          currentPoint = null;
                        });
                        context.read<LabelProvider>().notDrawing();
                      },
                      onTapDown: (details) {
                        int? tapedIndex;
                        for (var i = 0;
                            i < detectionImageModel.rectangles.length;
                            i++) {
                          if (detectionImageModel.rectangles[i]
                              .contains(details.localPosition)) {
                            tapedIndex = i;
                            break;
                          }
                        }
                        context
                            .read<DetectionImageProvider>()
                            .updateSelectedRect(tapedIndex);
                      },
                      child: Stack(
                        children: [
                          Image.memory(
                            detectionImageModel.imageData,
                            height: imageHeight,
                            width: imageWidth,
                            fit: BoxFit.fill,
                          ),
                          if (labelProvider.isDrawing &&
                              startPoint != null &&
                              currentPoint != null)
                            Positioned(
                              left: startPoint!.dx < currentPoint!.dx
                                  ? startPoint!.dx
                                  : currentPoint!.dx,
                              top: startPoint!.dy < currentPoint!.dy
                                  ? startPoint!.dy
                                  : currentPoint!.dy,
                              width: (startPoint!.dx - currentPoint!.dx).abs(),
                              height: (startPoint!.dy - currentPoint!.dy).abs(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      labelProvider.label!.color.withAlpha(50),
                                  border: Border.all(
                                    color: labelProvider.label!.color,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          for (int i = 0;
                              i < detectionImageModel.rectangles.length;
                              i++)
                            Positioned(
                              left: detectionImageModel.rectangles[i].left,
                              top: detectionImageModel.rectangles[i].top,
                              child: ResizeTarget(
                                rect: detectionImageModel.rectangles[i],
                                isSelected: selectedRectangleIndex == i,
                                rectIndex: i, // Pass the index // New callback
                                onMove: (delta) {
                                  if (selectedRectangleIndex == i) {
                                    _moveSelectedRect(
                                        delta,
                                        detectionImageModel.rectangles[i],
                                        imageWidth,
                                        imageHeight,
                                        selectedRectangleIndex);
                                  }
                                },

                                onResize: (delta, corner) {
                                  if (selectedRectangleIndex == i) {
                                    _resizeSelectedRect(
                                        delta,
                                        corner,
                                        detectionImageModel.rectangles[i],
                                        imageWidth,
                                        imageHeight,
                                        selectedRectangleIndex);
                                  }
                                },
                                onTap: () {
                                  context
                                      .read<DetectionImageProvider>()
                                      .updateSelectedRect(i);
                                },
                                onResizeEndEnd: () {
                                  context
                                      .read<DetectionImageProvider>()
                                      .updateRectangle(
                                          i, detectionImageModel.rectangles[i]);
                                },
                                onMoveEnd: () {
                                  context
                                      .read<DetectionImageProvider>()
                                      .updateRectangle(
                                          i, detectionImageModel.rectangles[i]);
                                },
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
