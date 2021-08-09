import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class AllConfettiWidget extends StatefulWidget {
  final Widget child;

  const AllConfettiWidget({
    required this.child,
    required Key key,
}) : super(key: key);
  @override
  _AllConfettiWidgetState createState() => _AllConfettiWidgetState();
}

class _AllConfettiWidgetState extends State<AllConfettiWidget> {
  late ConfettiController controller;
  @override
  void initState() {
    super.initState();

    controller = ConfettiController(duration: Duration(seconds: 3));
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
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
            ],
          ),
        ),
        widget.child,
      ],
    );
  }
}
