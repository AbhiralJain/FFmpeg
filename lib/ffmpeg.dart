import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'config.dart';
import 'exportprogress.dart';
import 'getinfo.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:shared_preferences/shared_preferences.dart';

class FFmpegTerminal extends StatefulWidget {
  const FFmpegTerminal({Key? key}) : super(key: key);

  @override
  _FFmpegTerminalState createState() => _FFmpegTerminalState();
}

class _FFmpegTerminalState extends State<FFmpegTerminal> {
  final ScrollController _contr = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await getStoreversion();
      final prefs = await SharedPreferences.getInstance();
      final bool? tut = prefs.getBool('tut');
      if (tut == null) {
        Alert(
          style: Config.alertConfig,
          context: context,
          title: 'Note',
          desc: '''Please do not mention the input and output commands as it is handled by the app.

Use " " to insert spaces.

This app cannot process audio files as an output format.

Font config and vid.stab will be supported soon.''',
          buttons: [
            DialogButton(
              highlightColor: const Color.fromRGBO(0, 0, 0, 0),
              splashColor: const Color.fromRGBO(0, 0, 0, 0),
              radius: const BorderRadius.all(Radius.circular(20)),
              color: Config.bbcolor,
              child: Text(
                "Next",
                style: TextStyle(color: Config.backgroundColor, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                Alert(
                  style: Config.alertConfig,
                  context: context,
                  title: 'Usage',
                  desc: 'Pressing space bar on keyboard will do the work.',
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Image.asset('assets/wr.png'),
                            const Icon(
                              Icons.close_rounded,
                              size: 75,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Image.asset('assets/ri.png'),
                          const Icon(
                            Icons.done_rounded,
                            size: 75,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                  buttons: [
                    DialogButton(
                      highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                      splashColor: const Color.fromRGBO(0, 0, 0, 0),
                      radius: const BorderRadius.all(Radius.circular(20)),
                      color: Config.bbcolor,
                      child: Text(
                        "OK",
                        style: TextStyle(color: Config.backgroundColor, fontSize: 20),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await prefs.setBool('tut', true);
                      },
                      width: 120,
                    )
                  ],
                ).show();
              },
              width: 120,
            )
          ],
        ).show();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final FocusNode _focus = FocusNode();
  final FocusNode _focus1 = FocusNode();

  bool editmode = false;
  var videoinfo = GetMediaInfo();
  double tduration = 0;
  int dinvcma = 0;
  TextEditingController tct = TextEditingController();
  TextEditingController exn = TextEditingController();
  int cindex = -1;
  List<String> finalarg = [];
  List<Map> displayarg = [
    {'command': 'ffmpeg', 'allowedit': false, 'iscommand': false}
  ];
  int listlength = 1;
  getStoreversion() async {
    String localVersion = '1.1.6';
    final uri = Uri.https("play.google.com", "/store/apps/details", {"id": "com.crossplat.ffmpegmobile"});
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      return null;
    }
    final document = parse(response.body);
    final additionalInfoElements = document.getElementsByClassName('hAyfc');
    final versionElement = additionalInfoElements.firstWhere(
      (elm) => elm.querySelector('.BgcNfc')!.text == 'Current Version',
    );
    final storeVersion = versionElement.querySelector('.htlgb')!.text;
    final sectionElements = document.getElementsByClassName('W4P4ne');
    final releaseNotesElement = sectionElements.firstWhere(
      (elm) => elm.querySelector('.wSaTQd')!.text == 'What\'s New',
    );
    final releaseNotes = releaseNotesElement.querySelector('.PHBdkd')?.querySelector('.DWPxHb')?.text;
    String rNotes = '';
    for (int i = 0; i < releaseNotes!.length; i++) {
      if (releaseNotes[i] == '.') {
        rNotes += releaseNotes[i];
        if (!(i == releaseNotes.length - 1)) {
          rNotes += '\n\n';
        }
      } else {
        rNotes += releaseNotes[i];
      }
    }
    if (localVersion != storeVersion) {
      await Alert(
        style: Config.alertConfig,
        context: context,
        title: "Update Availible",
        desc: rNotes,
        buttons: [
          DialogButton(
            highlightColor: const Color.fromRGBO(0, 0, 0, 0),
            splashColor: const Color.fromRGBO(0, 0, 0, 0),
            radius: const BorderRadius.all(Radius.circular(20)),
            color: Config.bbcolor,
            child: Text(
              "Update",
              style: TextStyle(color: Config.backgroundColor, fontSize: 20),
            ),
            onPressed: () {
              launch('https://play.google.com/store/apps/details?id=com.crossplat.ffmpegmobile');
              Navigator.pop(context);
            },
            width: 120,
          ),
          DialogButton(
            highlightColor: const Color.fromRGBO(0, 0, 0, 0),
            splashColor: const Color.fromRGBO(0, 0, 0, 0),
            radius: const BorderRadius.all(Radius.circular(20)),
            color: Config.bbcolor,
            child: Text(
              "Cancel",
              style: TextStyle(color: Config.backgroundColor, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          ),
        ],
      ).show();
    }
  }

  shortcutbutton(button) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            tct.text += button;
            tct.selection = TextSelection.fromPosition(
              TextPosition(
                offset: tct.text.length,
              ),
            );
          });
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 2, right: 2),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Config.bbcolor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Text(
            button,
            style: TextStyle(
                color: Config.backgroundColor, fontFamily: 'Montserrat', fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  comwidget(index) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (!editmode) cindex = index;
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: (cindex == index)
                ? displayarg[index]['allowedit']
                    ? Colors.blueGrey.withOpacity(0.3)
                    : Colors.red.withOpacity(0.3)
                : Config.backgroundColor,
            padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
            child: Text(
              displayarg[index]['command'],
              style: TextStyle(
                color: displayarg[index]['iscommand'] ? Colors.purple.shade400 : Config.textcolor,
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (cindex == index && displayarg[index]['allowedit'])
          Row(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: InkWell(
                    onTap: () {
                      if (displayarg[cindex - 1]['allowedit']) {
                        setState(() {
                          var temp = displayarg[cindex];
                          var temp2 = finalarg[cindex - 1];
                          displayarg[cindex] = displayarg[cindex - 1];
                          finalarg[cindex - 1] = finalarg[cindex - 2];
                          displayarg[cindex - 1] = temp;
                          finalarg[cindex - 2] = temp2;
                          cindex--;
                        });
                      }
                    },
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.blue.shade500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: RotatedBox(
                  quarterTurns: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (!(cindex == displayarg.length - 1)) {
                          if (displayarg[cindex + 1]['allowedit']) {
                            var temp = displayarg[cindex];
                            var temp2 = finalarg[cindex - 1];
                            displayarg[cindex] = displayarg[cindex + 1];
                            finalarg[cindex - 1] = finalarg[cindex];
                            displayarg[cindex + 1] = temp;
                            finalarg[cindex] = temp2;
                            cindex++;
                          }
                        }
                      });
                    },
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.orange.shade500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    if (editmode) {
                      setState(() {
                        tct.text = '';
                        FocusScope.of(context).unfocus();
                        editmode = false;
                        cindex = -1;
                      });
                    } else {
                      setState(() {
                        FocusScope.of(context).requestFocus();
                        tct.text = displayarg[index]['command'];
                        editmode = true;
                      });
                    }
                  },
                  child: Icon(
                    editmode ? Icons.cancel_outlined : Icons.edit_outlined,
                    color: Colors.teal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      displayarg.removeAt(cindex);
                      finalarg.removeAt(cindex - 1);
                      listlength = displayarg.length;
                      tct.text = '';
                      FocusScope.of(context).unfocus();
                      cindex = -1;
                      editmode = false;
                    });
                  },
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red.shade300,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  importmedia() async {
    bool storagepermisson = await Config.requestpermission(Permission.storage);
    if (!storagepermisson) {
      Alert(
        style: Config.alertConfig,
        context: context,
        title: "Please give media and storage permission",
        buttons: [
          DialogButton(
            highlightColor: const Color.fromRGBO(0, 0, 0, 0),
            splashColor: const Color.fromRGBO(0, 0, 0, 0),
            radius: const BorderRadius.all(Radius.circular(20)),
            color: Config.bbcolor,
            child: Text(
              "OK",
              style: TextStyle(color: Config.backgroundColor, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    } else {
      await Config.createfolder("FFmpeg");
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();

        for (int i = 0; i < files.length; i++) {
          var info = await videoinfo.getfileinfo(result.files[i].path.toString());
          if (info['duration'] != null) {
            tduration += double.parse(info['duration']) * 1000;
          }
          finalarg.add('-i');
          finalarg.add(result.files[i].path!);
          displayarg.add({'command': '-i', 'allowedit': false, 'iscommand': true});
          displayarg.add({'command': result.files[i].name, 'allowedit': false, 'iscommand': false});
        }
        setState(() {
          listlength = displayarg.length;
        });
      } else {
        Alert(
          style: Config.alertConfig,
          context: context,
          title: "No files selected",
          buttons: [
            DialogButton(
              highlightColor: const Color.fromRGBO(0, 0, 0, 0),
              splashColor: const Color.fromRGBO(0, 0, 0, 0),
              radius: const BorderRadius.all(Radius.circular(20)),
              color: Config.bbcolor,
              child: Text(
                "OK",
                style: TextStyle(color: Config.backgroundColor, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }
    }
  }

  stol(command) {
    if (!editmode) {
      dinvcma = '"'.allMatches(command).length;
      if (command.isNotEmpty) {
        if (command.endsWith("'") && dinvcma % 2 == 0) {
          setState(() {
            tct.text = "${command.replaceAll("'", "\"")}''";
          });
        }
        if (command.endsWith(" ") && dinvcma % 2 == 0) {
          setState(() {
            if (command.trim() != '' && command.trim() != ' ') {
              finalarg.add(command.trim().replaceAll("\"", ""));
              if (command.toString().startsWith('-')) {
                displayarg.add({'command': command.trim(), 'allowedit': true, 'iscommand': true});
              } else {
                displayarg.add({'command': command.trim(), 'allowedit': true, 'iscommand': false});
              }

              listlength = displayarg.length;
              tct.text = '';
            }
            _contr.jumpTo(_contr.position.maxScrollExtent);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool dtheme = MediaQuery.of(context).platformBrightness == Brightness.light ? true : false;
    Config.changeColor(dtheme);
    return Scaffold(
      backgroundColor: Config.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 225),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                controller: _contr,
                itemCount: listlength,
                itemBuilder: (BuildContext context, int index) => comwidget(index),
              ),
            ),
            Column(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Config.tilesColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Config.shadowcolor,
                        offset: const Offset(0, -10),
                        spreadRadius: 0,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MaterialButton(
                        elevation: 0,
                        padding: const EdgeInsets.all(10),
                        color: Config.bbcolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        onPressed: () => importmedia(),
                        child: Text(
                          'Import Media',
                          style: TextStyle(
                            color: Config.backgroundColor,
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: Config.backgroundColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: TextField(
                          focusNode: _focus,
                          onEditingComplete: () {
                            String command = tct.text;
                            if (editmode) {
                              setState(() {
                                if (tct.text == '') {
                                  displayarg.removeAt(cindex);
                                  finalarg.removeAt(cindex - 1);
                                  listlength = displayarg.length;
                                } else {
                                  displayarg[cindex]['command'] = tct.text;
                                  finalarg[cindex - 1] = tct.text.replaceAll("\"", "");
                                }
                                tct.text = '';
                                cindex = -1;
                                editmode = false;
                                _contr.jumpTo(_contr.position.maxScrollExtent);
                              });
                            } else {
                              setState(() {
                                _focus.unfocus();
                                _focus1.requestFocus();
                                if (command.trim() != '' && command.trim() != ' ') {
                                  finalarg.add(command.trim().replaceAll("\"", ""));
                                  if (command.toString().startsWith('-')) {
                                    displayarg.add({'command': command.trim(), 'allowedit': true, 'iscommand': true});
                                  } else {
                                    displayarg.add({'command': command.trim(), 'allowedit': true, 'iscommand': false});
                                  }
                                  listlength = displayarg.length;
                                  tct.text = '';
                                }
                                _contr.jumpTo(_contr.position.maxScrollExtent);
                              });
                            }
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (command) => stol(command),
                          style: TextStyle(
                              color: Config.textcolor,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          controller: tct,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: 'Enter your commands here',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              decoration: BoxDecoration(
                                  color: Config.backgroundColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(15))),
                              child: TextField(
                                focusNode: _focus1,
                                onChanged: (value) {},
                                style: TextStyle(
                                  color: Config.textcolor,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                controller: exn,
                                decoration: InputDecoration(
                                  counterText: "",
                                  hintText: 'Output format',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            height: 50,
                            elevation: 0,
                            padding: const EdgeInsets.fromLTRB(35, 10, 35, 10),
                            color: Config.bbcolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            onPressed: () {
                              if (exn.text != '') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExportProgress(
                                      arguments: finalarg,
                                      duration: tduration.toString(),
                                      exten: exn.text.replaceAll('.', ''),
                                    ),
                                  ),
                                );
                              } else {
                                Alert(
                                  style: Config.alertConfig,
                                  context: context,
                                  title: 'Please enter the output format',
                                  buttons: [
                                    DialogButton(
                                      highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                                      splashColor: const Color.fromRGBO(0, 0, 0, 0),
                                      radius: const BorderRadius.all(Radius.circular(20)),
                                      color: Config.bbcolor,
                                      child: Text(
                                        "OK",
                                        style: TextStyle(color: Config.backgroundColor, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      width: 120,
                                    )
                                  ],
                                ).show();
                              }
                            },
                            child: Text(
                              'Execute',
                              style: TextStyle(
                                color: Config.backgroundColor,
                                fontFamily: 'Montserrat',
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                      SizedBox(
                        child: (MediaQuery.of(context).viewInsets.bottom > 125)
                            ? Row(
                                children: [
                                  shortcutbutton('-'),
                                  shortcutbutton('='),
                                  shortcutbutton(':'),
                                  shortcutbutton(';'),
                                  shortcutbutton('"'),
                                  shortcutbutton('/'),
                                  shortcutbutton('('),
                                  shortcutbutton(')'),
                                  shortcutbutton('['),
                                  shortcutbutton(']'),
                                ],
                              )
                            : Container(),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
