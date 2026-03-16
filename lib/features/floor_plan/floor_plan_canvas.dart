import 'package:flutter/material.dart';

class FloorPlanCanvas extends StatelessWidget {
  const FloorPlanCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth * 0.6;
        final height = constraints.maxHeight * 0.4;

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
          ),
          alignment: Alignment.center,
          child: const Text('Living Room'),
        );
      },
    );
  }
}
