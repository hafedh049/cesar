import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cipher/maincipher.dart';
import 'package:flutter/material.dart';

void main() {
  /*doWhenWindowReady((){appWindow.size = Size(600,450);}) */
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Cipher());
  doWhenWindowReady(
    () {
      appWindow.title = "Cipher";
      appWindow.alignment = Alignment.center;
      appWindow.minSize = const Size(600, 600);
      appWindow.show();
    },
  );
}

class Cipher extends StatefulWidget {
  const Cipher({super.key});

  @override
  State<Cipher> createState() => _CipherState();
}

class _CipherState extends State<Cipher> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainCipher(),
    );
  }
}
