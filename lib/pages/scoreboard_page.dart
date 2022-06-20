import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fruit_catcher_oz/pages/game_page.dart';

import '../spref/spref.dart';

class HightScorePage extends StatefulWidget {
  const HightScorePage({Key? key}) : super(key: key);

  @override
  State<HightScorePage> createState() => _HightScorePageState();
}

class _HightScorePageState extends State<HightScorePage> {
  int? top1;
  int? top2;
  int? top3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      top1 = await SPref.instance.getInt("top1") ?? 0;

      top2 = await SPref.instance.getInt("top2") ?? 0;
      top3 = await SPref.instance.getInt("top3") ?? 0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SCOREBOARD"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => GamePage()));
            },
            icon: Icon(Icons.gamepad),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.gif"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ScoreItem(
                  score: top1,
                  top: 1,
                  color: Colors.red,
                ),
                ScoreItem(
                  score: top2,
                  top: 2,
                  color: Colors.green,
                ),
                ScoreItem(
                  score: top3,
                  top: 3,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScoreItem extends StatelessWidget {
  const ScoreItem({
    Key? key,
    required this.score,
    required this.top,
    required this.color,
  }) : super(key: key);

  final int? score;
  final int top;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 80),
      child: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.green.withOpacity(0.3),
            ),
            child: ListTile(
              title: Row(
                children: [
                  for (int i = 0; i < top; i++)
                    Icon(
                      Icons.person,
                      color: color,
                    ),
                ],
              ),
              trailing: Text(
                "${score == null ? 0 : score}",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
