import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/label.dart';
import '../../../providers/label_provider.dart';

class LabelItem extends StatelessWidget {
  const LabelItem({
    super.key,
    required this.height,
    required this.width,
    required this.label,
    required this.index,
  });
  final double height;
  final double width;
  final Label label;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<LabelProvider>(
      builder: (context, labelProvider, _) {
        return InkWell(
          onTap: () {
            context.read<LabelProvider>().setNewLabel(label, index);
          },
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color:
                  labelProvider.isDrawing && labelProvider.labelListId == index
                      ? label.color
                      : label.color.withAlpha(100),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(label.name),
            ),
          ),
        );
      },
    );
  }
}
