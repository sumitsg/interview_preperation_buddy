import 'dart:async';
import 'package:flutter/material.dart';

class AppTimer extends StatefulWidget {
  const AppTimer({super.key, required this.seconds, required this.onCompleted});

  final int seconds;
  final VoidCallback onCompleted;

  @override
  State<AppTimer> createState() => _AppTimerState();
}

class _AppTimerState extends State<AppTimer> {
  late int remaining;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    remaining = widget.seconds;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remaining <= 1) {
        timer.cancel();
        widget.onCompleted();
      } else {
        setState(() {
          remaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String get formatted {
    final min = remaining ~/ 60;
    final sec = remaining % 60;

    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Text(formatted, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
  }
}
