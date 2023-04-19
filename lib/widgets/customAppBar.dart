import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Row(
          children: [
            SizedBox(width: 25,),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Icon(
                Icons.double_arrow_rounded,
                color: Colors.black45,
                size: 30,
              ),
            ),
          ],
        ),
    );
  }
}
