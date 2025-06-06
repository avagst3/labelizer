import 'package:flutter/material.dart';

import '../../model/rectangle_model.dart';

class ResizeTarget extends StatelessWidget {
  final RectModel rect;
  final bool isSelected;
  final int rectIndex; // Added: The index of this rectangle in the list
  final Function(Offset delta) onMove;
  final Function(Offset delta, int corner) onResize;
  final VoidCallback onTap; // Main tap to select/deselect the rectangle
  final Function(String label)? onLabelChanged;

  final Function onMoveEnd;
  final Function onResizeEndEnd;

  const ResizeTarget({
    super.key,
    required this.rect,
    required this.isSelected,
    required this.rectIndex, // Required
    required this.onMove,
    required this.onResize,
    required this.onTap,
    required this.onMoveEnd,
    this.onLabelChanged,
    required this.onResizeEndEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Main tap to select/deselect the rectangle
      onPanUpdate: (details) => onMove(details.delta),
      onPanEnd: (details) => onMoveEnd(),
      child: Stack(
        clipBehavior:
            Clip.none, // Allow handles to overflow the rectangle's bounds
        children: [
          // The rectangle itself
          Container(
            width: rect.width,
            height: rect.height,
            decoration: BoxDecoration(
              color: isSelected
                  ? rect.label.color.withAlpha(10)
                  : rect.label.color.withAlpha(10),
              border: Border.all(
                color: isSelected
                    ? rect.label.color
                    : rect.label.color.withAlpha(100),
                width: isSelected ? 3 : 2,
              ),
            ),
            // ignore: unnecessary_null_comparison
            child: rect.label != null
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      color: rect.label.color.withAlpha(100),
                      child: Text(
                        rect.label.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                : null,
          ),
          // Resize and Rotate Handles (only visible when selected)
          if (isSelected) ...[
            _buildResizeHandle(
                0, Alignment.topLeft, onResize, onResizeEndEnd), // Top-left
            _buildResizeHandle(
                1, Alignment.topRight, onResize, onResizeEndEnd), // Top-right
            _buildResizeHandle(2, Alignment.bottomLeft, onResize,
                onResizeEndEnd), // Bottom-left
            _buildResizeHandle(3, Alignment.bottomRight, onResize,
                onResizeEndEnd), // Rotation handle
          ],
        ],
      ),
    );
  }

  // Helper function to build a resize handle
  Widget _buildResizeHandle(int corner, Alignment alignment,
      Function(Offset, int) onResize, Function onResizeEnd) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: GestureDetector(
          onPanUpdate: (details) => onResize(details.delta, corner),
          onPanEnd: (details) => onResizeEnd(),
          child: Container(
            width: 20,
            height: 20,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: rect.label.color,
            ),
            child: const Icon(
              Icons.open_with,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build the rotation handle
}
