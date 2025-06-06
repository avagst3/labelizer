import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../model/label.dart';
import 'label_item.dart';

/// Documentation for LabelBar
///
/// Display the list of the labels that you selected
///
class LabelsBar extends StatelessWidget {
  const LabelsBar({
    super.key,
    required this.color,
    required this.height,
    required this.width,
    required this.labels,
    this.nbDisplayedLabel = 10,
  });
  final Color color;
  final double height;
  final double width;
  final int nbDisplayedLabel;
  final List<Label> labels;

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // Shadow color
            blurRadius: 5, // Softness of the shadow
            offset: Offset(0, 3), // Position of the shadow
            spreadRadius: 2, // How far the shadow spreads
          ),
        ],
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: labels.map((label) {
              var item = LabelItem(
                height: height * 0.7,
                width: width / nbDisplayedLabel,
                label: label,
                index: i,
              );
              i += 1;
              return item;
            }).toList(),
          ),
        ),
      ),
    );
  }
}
