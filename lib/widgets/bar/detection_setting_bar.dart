import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:labelizer/model/detection_image_model.dart';
import 'package:provider/provider.dart';

import '../../model/rectangle_model.dart';
import '../../providers/detection_image_provider.dart';

class DetectionSettingBar extends StatelessWidget {
  List<List<String>> saveData(DetectionImageModel image) {
    List<List<String>> datas = [];
    for (var rect in image.rectangles) {
      List<String> data = [];
      data.add(rect.labelListId.toString());
      data.add((rect.top / image.height).toString());
      data.add((rect.left / image.width).toString());
      data.add((rect.height / image.height).toString());
      data.add((rect.width / image.width).toString());
      datas.add(data);
    }
    return datas;
  }

  Map<String, dynamic> exportData(
      DetectionImageProvider detectionImageProvider) {
    int i = 0;
    Map<String, dynamic> exportData = {};
    for (var image in detectionImageProvider.imagesList) {
      exportData[i.toString()] = saveData(image);
      i += 1;
    }
    return exportData;
  }

  const DetectionSettingBar(
      {super.key,
      required this.onSaveCallBack,
      required this.onExportCallBack});

  final Function(List<List<String>>) onSaveCallBack;
  final Function(Map<String, dynamic>) onExportCallBack;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _heightController = TextEditingController();
    final TextEditingController _widthController = TextEditingController();
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black12.withAlpha(10),
      padding: EdgeInsets.all(10),
      child: Consumer<DetectionImageProvider>(
          builder: (context, detectionImageProvider, _) {
        if (detectionImageProvider.selectedRectIndex != null) {
          _heightController.text = detectionImageProvider.selectedImage!
              .rectangles[detectionImageProvider.selectedRectIndex!].height
              .toString();
          _widthController.text = detectionImageProvider.selectedImage!
              .rectangles[detectionImageProvider.selectedRectIndex!].width
              .toString();
        } else {
          _widthController.text = "";
          _heightController.text = "";
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 2,
                    children: detectionImageProvider.selectedImage == null
                        ? []
                        : detectionImageProvider.selectedImage!.rectangles
                            .map((rect) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: InkWell(
                                child: Row(
                                  spacing: 10,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: rect.label.color,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text(
                                        rect.label.name,
                                        style: TextStyle(
                                          color: rect.label.color
                                                      .computeLuminance() >
                                                  0.5
                                              ? Colors
                                                  .black // Dark text for light background
                                              : Colors
                                                  .white, // Light text for dark background
                                        ),
                                      ),
                                    ),
                                    Text(
                                        rect.height.roundToDouble().toString()),
                                    Text(rect.width.roundToDouble().toString()),
                                  ],
                                ),
                                onTap: () {
                                  context
                                      .read<DetectionImageProvider>()
                                      .updateSelectedRect(detectionImageProvider
                                          .selectedImage!.rectangles
                                          .indexOf(rect));
                                },
                              ),
                            );
                          }).toList(),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<DetectionImageProvider>().saveOne();
                      var data =
                          saveData(detectionImageProvider.selectedImage!);
                      onSaveCallBack(data);
                    },
                    icon: Icon(Icons.save),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<DetectionImageProvider>().removeRectangle(
                          detectionImageProvider.selectedImage!.rectangles[
                              detectionImageProvider.selectedRectIndex!]);
                    },
                    icon: Icon(Icons.delete),
                  ),
                  FilledButton(
                    onPressed: () {
                      var data = exportData(detectionImageProvider);
                      onExportCallBack(data);
                    },
                    child: Text("Export"),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 4,
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Column(
                  spacing: 20,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Height"),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: _heightController,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Width"),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: _widthController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: FilledButton(
                        onPressed: () {
                          var rect =
                              detectionImageProvider.selectedImage!.rectangles[
                                  detectionImageProvider.selectedRectIndex!];

                          detectionImageProvider.updateRectangle(
                            detectionImageProvider.selectedRectIndex!,
                            RectModel(
                              left: rect.left,
                              label: rect.label,
                              top: rect.top,
                              labelListId: rect.labelListId,
                              height: double.parse(_heightController.text),
                              width: double.parse(_widthController.text),
                            ),
                          );
                        },
                        child: Text("Update"),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<DetectionImageProvider>().previous();
                    },
                    icon: Icon(Icons.arrow_left),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<DetectionImageProvider>().next();
                    },
                    icon: Icon(Icons.arrow_right),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
