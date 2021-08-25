import 'dart:math';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:confetti/confetti.dart';
// ignore: import_of_legacy_library_into_null_safe
//import 'package:confetti/src/enums/confetti_controller_state.dart';

class AllConfettiWidget extends StatefulWidget {
  final Widget child;

  const AllConfettiWidget({
    required this.child,
    Key? key,
  }) : super(key: key);
  @override
  _AllConfettiWidgetState createState() => _AllConfettiWidgetState();
}

class _AllConfettiWidgetState extends State<AllConfettiWidget> {
  ConfettiController controller = ConfettiController(duration: Duration(seconds: 3));
  @override
  void initState() {
    super.initState();

    controller = ConfettiController(duration: Duration(seconds: 3));
    controller.play();
  }


  static final double right = 0;
  static final double down = pi/2;
  static final double left = pi;
  static final double top = -pi/2;

  final double blastDirection = top;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // behavior: HitTestBehavior.deferToChild,
      onTap: () {
        if(controller.state == ConfettiControllerState.playing){
          controller.stop();
        } else{
          controller.play();
        }
      },
      child: Stack(
        children: [
          widget.child,
          buildConfetti(),
        ],
      ),
    );
  }

  Widget buildConfetti() => Align(
    alignment: Alignment.center,
    child: ConfettiWidget(
      confettiController: controller,
      colors: [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.pinkAccent,
        Colors.purple,
        Colors.deepOrangeAccent,
        
      ],
      // blastDirection: blastDirection,
      blastDirectionality: BlastDirectionality.explosive,
      shouldLoop: true,
      emissionFrequency: 0,
      numberOfParticles: 75,
      gravity: 1,
    ),
  );


}
