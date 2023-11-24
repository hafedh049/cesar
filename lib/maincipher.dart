import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sidebarx/sidebarx.dart';

class MainCipher extends StatefulWidget {
  const MainCipher({super.key});

  @override
  State<MainCipher> createState() => _MainCipherState();
}

class _MainCipherState extends State<MainCipher> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 42, 76),
      body: /* WindowBorder(
        width: .01,
        color: Colors.white,
        child: 
      ), */
          LeftSide(),
    );
  }
}

class LeftSide extends StatefulWidget {
  const LeftSide({super.key});

  @override
  State<LeftSide> createState() => _LeftSideState();
}

class _LeftSideState extends State<LeftSide> {
  int state = 1;
  SidebarXController sidebarXController = SidebarXController(selectedIndex: 0);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SidebarX(
          extendedTheme: SidebarXTheme(
            width: 200,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.lightGreenAccent,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          theme: SidebarXTheme(
            hoverColor: Colors.white,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.lightGreenAccent,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          controller: sidebarXController,
          items: [
            SidebarXItem(
              label: "Encode",
              icon: FontAwesomeIcons.bolt,
              onTap: () {
                setState(() {
                  state = 1;
                });
              },
            ),
            SidebarXItem(
              label: "Decode",
              icon: FontAwesomeIcons.ghost,
              onTap: () {
                setState(() {
                  state = 2;
                });
              },
            ),
            SidebarXItem(
              label: "Bruteforce",
              icon: FontAwesomeIcons.snowflake,
              onTap: () {
                setState(() {
                  state = 3;
                });
              },
            ),
          ],
        ),
        Expanded(
          child: RightSide(state: state),
        ),
      ],
    );
  }
}

class RightSide extends StatefulWidget {
  const RightSide({super.key, required this.state});
  final int state;
  @override
  State<RightSide> createState() => _RightSideState();
}

class _RightSideState extends State<RightSide> {
  List<String> alphabeticLetters =
      List.generate(26, (index) => String.fromCharCode(97 + index));
  TextEditingController cipherTextController = TextEditingController(text: "");
  TextEditingController shiftController = TextEditingController(text: "1");
  TextEditingController outputController = TextEditingController(text: "");
  @override
  void dispose() {
    cipherTextController.dispose();
    shiftController.dispose();
    outputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 1, 53, 95),
      child: Column(
        children: [
          WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(
                  child: MoveWindow(),
                ), //const Spacer(),
                MinimizeWindowButton(
                  animate: true,
                  colors: WindowButtonColors(
                    normal: Colors.transparent,
                    iconNormal: Colors.white,
                  ),
                ),
                MaximizeWindowButton(
                  animate: true,
                  colors: WindowButtonColors(
                    normal: Colors.transparent,
                    iconNormal: Colors.white,
                  ),
                ),
                CloseWindowButton(
                  animate: true,
                  colors: WindowButtonColors(
                    normal: Colors.lightGreenAccent,
                    iconNormal: Colors.black,
                    mouseOver: Colors.pinkAccent,
                    iconMouseOver: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.state == 1
                      ? "Encode"
                      : widget.state == 2
                          ? "Decode"
                          : "Bruteforce",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 45,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .2,
                ),
                Container(
                  width: 300,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        if (shiftController.text == "") {
                          shiftController.text = "1";
                        }
                        outputController.text = widget.state == 1
                            ? encode(cipherTextController.text.trim(),
                                int.parse(shiftController.text))
                            : decode(cipherTextController.text.trim(),
                                int.parse(shiftController.text));
                      });
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: cipherTextController,
                    decoration: InputDecoration(
                      labelText:
                          "Text to ${widget.state == 1 ? 'Encode' : "Decode"}",
                      labelStyle: const TextStyle(
                        color: Colors.lightGreenAccent,
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                if (widget.state <= 2)
                  Container(
                    width: MediaQuery.of(context).size.height * .1,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(2),
                        FilteringTextInputFormatter(
                          RegExp(r"^\d+$"),
                          allow: true,
                        )
                      ],
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() {
                          outputController.text = widget.state == 1
                              ? encode(
                                  cipherTextController.text.trim(),
                                  shiftController.text == ""
                                      ? 1
                                      : int.parse(shiftController.text))
                              : decode(
                                  cipherTextController.text.trim(),
                                  shiftController.text == ""
                                      ? 1
                                      : int.parse(shiftController.text));
                        });
                      },
                      controller: shiftController,
                      decoration: const InputDecoration(
                        labelText: "Shift",
                        labelStyle: TextStyle(
                          color: Colors.lightGreenAccent,
                        ),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                if (widget.state <= 2)
                  IgnorePointer(
                    ignoring: true,
                    child: Container(
                      width: 300,
                      child: TextField(
                        maxLines: 7,
                        decoration: const InputDecoration(
                          labelText: "Output",
                          labelStyle: TextStyle(
                            color: Colors.lightGreenAccent,
                          ),
                          border: UnderlineInputBorder(),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        controller: outputController,
                        readOnly: true,
                      ),
                    ),
                  )
                else
                  Container(
                    width: 400,
                    height: 200,
                    child: ListView.builder(
                      itemCount:
                          bruteForce(cipherTextController.text.trim()).length,
                      itemBuilder: (context, index) {
                        List<String> result =
                            bruteForce(cipherTextController.text.trim());
                        return Card(
                          color: Colors.lightGreenAccent,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            title: Text(
                              result[index],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> bruteForce(String bruteforce) {
    List<String> result = <String>[];
    for (int shift = 1; shift <= 26; shift++) {
      result.add(decode(bruteforce, shift));
    }
    return result;
  }

  String decode(String textToDecode, int shift) {
    List<String> result = <String>[];
    for (String char in textToDecode.toLowerCase().split("")) {
      result.add((char.codeUnits[0] < 122 && char.codeUnits[0] > 97)
          ? alphabeticLetters[
              (alphabeticLetters.indexWhere((element) => element == char) -
                          shift)
                      .abs() %
                  26]
          : char);
    }
    return result.join();
  }

  String encode(String textToEncode, int shift) {
    List<String> result = <String>[];
    for (String char in textToEncode.toLowerCase().split("")) {
      result.add((char.codeUnits[0] < 122 && char.codeUnits[0] > 97)
          ? alphabeticLetters[
              (alphabeticLetters.indexWhere((element) => element == char) +
                      shift) %
                  26]
          : char);
    }
    return result.join();
  }
}
