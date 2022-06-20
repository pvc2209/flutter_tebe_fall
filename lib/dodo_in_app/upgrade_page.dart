import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';

import 'in_app.dart';
import 'in_app_constant.dart';

class UpgradePage extends StatefulWidget {
  const UpgradePage({Key? key}) : super(key: key);

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  final DodoInApp _inApp = Get.put(
    DodoInApp(
      useAmazon: false,
    ),
  );

  @override
  void initState() {
    super.initState();
    _inApp.init();
  }

  @override
  void dispose() {
    _inApp.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double borderRadius = 8.0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Upgrade"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.gif"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView.builder(
            itemCount: kConsumables.length,
            itemBuilder: (context, index) {
              return Container(
                margin:
                    const EdgeInsets.only(top: 12.0, left: 20.0, right: 20.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Obx(
                    () => Container(
                      padding: const EdgeInsets.all(4),
                      foregroundDecoration: index % 3 == 0
                          ? RotatedCornerDecoration(
                              color: Colors.red,
                              geometry: BadgeGeometry(
                                width: 32,
                                height: 32,
                                alignment: BadgeAlignment.topLeft,
                                cornerRadius: borderRadius,
                              ),
                              textSpan: const TextSpan(
                                text: 'NEW',
                                style: TextStyle(
                                  fontSize: 8,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              labelInsets: const LabelInsets(baselineShift: 3),
                            )
                          : null,
                      child: ListTile(
                        title: Text(
                          "⏳ ${index + 1}s",
                          style: const TextStyle(fontSize: 24),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.pink,
                          ),
                          onPressed: _inApp.isProductReady(kConsumables[index])
                              ? () {
                                  _inApp.buyById(kConsumables[index]);
                                }
                              : null,
                          child: const Text("Upgrade"),
                        ),
                        subtitle: Text(_inApp.getPrice(kConsumables[index])),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
