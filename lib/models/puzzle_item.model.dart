import 'package:flutter/material.dart';

class PuzzleItem {
  PuzzleItem(this.value, {this.color}) {
    color ??= Colors.yellow.shade900;
  }

  int value = 0;
  double width = 75.0;
  double height = 75.0;
  Curve? animationCurve;
  Color? color ;
}


// Transform.translate(
//                       offset: Offset(animationT.value, 0.0),
//                       child: GestureDetector(
//                     onTap: () {
//                         print("Animation ${controllerT.status.name}");
//                       if (!controllerT.isCompleted) {
//                         controllerT.forward();
//                       } else {
//                         print("Animation completed");
//                         controllerT.reverse(from: 500);
//                       }
//                     },
//                     child:Container(
//                         width: 150.0,
//                         height: 150.0,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ),
//  late AnimationController controllerT;
//   late Animation<Offset> animationT;

//  controllerT =
//         AnimationController(duration: const Duration(seconds: 3), vsync: this)
//           ..addListener(() => setState(() {}));
//     animationT = Tween(begin:const Offset(0.0, 0.0), end:const Offset(0.0, 500.0) ).animate(controllerT);
