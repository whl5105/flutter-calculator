import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.name,
    required this.axisSet,
    required this.bgColor,
    required this.onButtonPressed,
  }) : super(key: key);

  final String name;
  final List<int> axisSet;
  final Color bgColor;
  final Function onButtonPressed;
  @override
  Widget build(BuildContext context) {
    return StaggeredGridTile.count(
      crossAxisCellCount: axisSet[0],
      mainAxisCellCount: axisSet[1],
      child: FilledButton(
        onPressed: () => onButtonPressed(),
        style: OutlinedButton.styleFrom(
          backgroundColor: bgColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(0),
            ),
          ),
        ),
        child: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
