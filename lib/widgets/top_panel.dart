import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../game.dart';
import '../spref/spref.dart';

class TopPanelWidget extends StatefulWidget {
  static const String id = "Score";
  final TebeFallGame gameRef;

  const TopPanelWidget({
    Key? key,
    required this.gameRef,
  }) : super(key: key);

  @override
  State<TopPanelWidget> createState() => _TopPanelWidgetState();
}

class _TopPanelWidgetState extends State<TopPanelWidget> {
  int? timeRemaining;

  late Timer timer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      int? seconds = await SPref.instance.getInt("seconds");

      if (seconds == null) {
        SPref.instance.setInt("seconds", 15);
        seconds = 15;
      }

      timeRemaining = seconds * 1000;

      timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        setState(() {
          timeRemaining = timeRemaining! - 10;
        });

        if (timeRemaining! <= 0) {
          timer.cancel();
          widget.gameRef.endGame();
        }
      });
    });
  }

  @override
  void dispose() {
    if (timer.isActive) {
      // print("cancelling timer");
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      "assets/images/clock.json",
                      height: 60,
                    ),
                    Text(
                      timeRemaining == null
                          ? "0.00"
                          : "${(timeRemaining! / 1000).toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SCORE\n${widget.gameRef.score}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset(
                  'assets/images/home_btn.png',
                  width: 40,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
