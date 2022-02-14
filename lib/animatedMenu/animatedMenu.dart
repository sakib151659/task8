import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedMenu extends StatefulWidget {
  const AnimatedMenu({Key? key}) : super(key: key);

  @override
  _AnimatedMenuState createState() => _AnimatedMenuState();
}

class _AnimatedMenuState extends State<AnimatedMenu>
with SingleTickerProviderStateMixin{

  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 250),
        vsync: this,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final double buttonSize = 80;
  @override
  Widget build(BuildContext context) => Flow(
    delegate: FlowMenuDelegate(controller: controller),
    children: <IconData>[
      Icons.mail,
      Icons.call,
      Icons.notifications,
      Icons.sms,
      Icons.menu
    ].map<Widget>(buildFab).toList(),
  );

  Widget buildFab(IconData icon) => SizedBox(
    width: buttonSize,
    height: buttonSize,
    child: FloatingActionButton(
        elevation: 0,
        splashColor: Colors.black,
        child: Icon(icon, color: Colors.white, size: 45,),
        onPressed: (){
          if(controller.status == AnimationStatus.completed){
            controller.reverse();
          }else {
            controller.forward();
          }
        }
    ),
  );
}

class FlowMenuDelegate extends FlowDelegate {
  final Animation<double> controller;
  const FlowMenuDelegate({required this.controller})
  : super (repaint: controller);
  @override
  void paintChildren(FlowPaintingContext context){
    final double buttonSize = 80;
    final size = context.size;
    final xStart = size.width - buttonSize;
    final yStart = size.height - buttonSize;
    final n = context.childCount;
    for(int i= 0; i < n; i++){
      final isLastItem = i == context.childCount - 1;
      final setValue = (value) => isLastItem ? 0.0 : value;
      final radius = 180* controller.value;
      final theta = i * pi * 0.5 / (n-2);
      final x = xStart - setValue(radius * cos(theta));
      final y = yStart - setValue(radius * sin(theta));
      context.paintChild(
        i,
        transform: Matrix4.identity()
          ..translate(x, y, 0)
          ..translate(buttonSize/2, buttonSize/2)
          ..rotateZ(isLastItem? 0.0: 180 * (1- controller.value)* pi / 180)
          ..scale(isLastItem? 1.0: max(controller.value,0.5))
          ..translate(-buttonSize/2, -buttonSize/2),
      );
    }
  }

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) => false;
}

