import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/log.dart';
import 'package:share_plus/share_plus.dart';
import 'config.dart';

class ExportProgress extends StatefulWidget {
  final String duration;
  final List arguments;
  final String? fontfile;
  final String? exten;
  const ExportProgress({
    Key? key,
    required this.arguments,
    required this.duration,
    this.exten,
    this.fontfile,
  }) : super(key: key);
  @override
  _ExportProgressState createState() => _ExportProgressState();
}

class _ExportProgressState extends State<ExportProgress> {
  final FocusNode _focus = FocusNode();
  String btntext = 'Save';
  int filecount = 1;
  String filepath = "/storage/emulated/0/Pictures/FFmpeg/";
  bool direx = true;
  File? dir1;
  String dt = "";
  Color txtcolor = Colors.black54;
  FontWeight txtw = FontWeight.normal;
  late double vdr;
  late List args;
  late String exten;
  double getlastpercent = 0;
  double progressValue = 0;
  String outputfilename = '';
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  final FlutterFFmpegConfig _flutterFFmpegConfig = FlutterFFmpegConfig();
  TextEditingController tctrl = TextEditingController();
  double _opacity = 0;
  double progressBar = 0;
  String logcats = '';

  final ScrollController _listctrl = ScrollController();

  initarg() async {
    _focus.requestFocus();
    args = widget.arguments;
    vdr = double.parse(widget.duration) / 1000;
  }

/*   initFont() async {
    final filename = widget.fontfile;
    var bytes = await rootBundle.load("fonts/$filename");
    String dir = (await getApplicationDocumentsDirectory()).path;
    final path = '$dir/$filename';
    final buffer = bytes.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    File ffile = File('$dir/$filename');
    _flutterFFmpegConfig.setFontDirectory(ffile.path, null);
    String targ = args.removeLast();
    String fpath = ffile.path;
    targ += ":fontfile=$fpath";
    args.add(targ);
    return ffile.path;
  } */

  performaction() async {
    setState(() {
      _flutterFFmpegConfig.enableLogCallback(this.logCallback);
    });
    if (btntext == 'Save') {
      setState(() {
        btntext = 'Cancel';
      });
      if (tctrl.text == '') {
        setState(() {
          btntext = 'Save';
          dt = "Please enter the name\nof the output file";
          txtcolor = Colors.red;
          txtw = FontWeight.bold;
        });
      } else {
        if (widget.exten == null) {
          outputfilename = tctrl.text + '.mp4';
        } else {
          outputfilename = tctrl.text + '.${widget.exten}';
        }
        args.add('$filepath$outputfilename');

        await chkexst('$filepath$outputfilename');
        txtcolor = const Color.fromRGBO(75, 75, 75, 1);
        txtw = FontWeight.bold;
        setState(() {
          dt = 'Initializing...';
        });
        _flutterFFmpeg.executeWithArguments(args).then((rc) {
          setState(() {
            logcats += 'FFmpeg exited with rc: $rc';
          });
          args.removeLast();
          if (rc == 0) {
            setState(() {
              btntext = 'Share';
              progressValue = 100;
              txtcolor = const Color.fromRGBO(0, 95, 115, 1);
              txtw = FontWeight.bold;
              dt = "File saved at\n\"Storage/Pictures/FFmpeg\"\nAs $outputfilename";
            });
          } else if (rc == 255) {
            setState(() {
              btntext = 'Save';
              progressValue = 0;
              dt = "Cancelled by user";
              txtcolor = Colors.red;
              txtw = FontWeight.bold;
            });
          } else {
            setState(() {
              btntext = 'Save';
              dt = "Execution failed!";
              txtcolor = Colors.red;
              txtw = FontWeight.bold;
            });
          }
        });
        _flutterFFmpegConfig.enableStatisticsCallback((x) {
          double percentage = ((x.time / 1000) / vdr) * 100;
          setState(() {
            dt = 'Processing...';
            if (percentage < 100) {
              progressValue = percentage;
              progressBar = ((MediaQuery.of(context).size.width / 100) * progressValue);
            }
            _listctrl.jumpTo(0);
          });
        });
      }
    } else if (btntext == 'Cancel') {
      setState(() {
        dt = "Canceling...";
        txtcolor = Colors.red;
        txtw = FontWeight.bold;
      });
      _flutterFFmpeg.cancel();
    } else if (btntext == 'Go back') {
      Navigator.pop(context);
    } else {
      Share.shareFiles(
        ['$filepath$outputfilename'],
      );
    }
  }

  chkexst(String fpath) async {
    File vfile = File(fpath);
    bool chk = await vfile.exists();

    if (chk) {
      args.removeLast();
      outputfilename = tctrl.text + '($filecount)';
      if (widget.exten == null) {
        outputfilename += '.mp4';
      } else {
        outputfilename += '.${widget.exten}';
      }
      args.add('$filepath$outputfilename');
      filecount++;
      await chkexst('$filepath$outputfilename');
    }
  }

  void logCallback(Log log) {
    logcats += log.message + '\n\n';
  }

  @override
  void initState() {
    super.initState();
    initarg();
    //initFont();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool dtheme = MediaQuery.of(context).platformBrightness == Brightness.light ? true : false;
    Config.changeColor(dtheme);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Config.backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 7.5, bottom: 7.5),
                    height: 5,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(30, 125, 145, 0.5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(2.5),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: progressBar,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(30, 125, 145, 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${progressValue.toStringAsFixed(0)}%',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromRGBO(30, 125, 145, 1),
                fontFamily: 'Montserrat',
                fontSize: 35,
              ),
            ),
            Text(
              dt,
              textAlign: TextAlign.center,
              style: TextStyle(color: Config.textcolor, fontFamily: 'Montserrat', fontSize: 20, fontWeight: txtw),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
              decoration: BoxDecoration(
                color: Config.tilesColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: TextField(
                onChanged: (value) {
                  if (value == '') {
                    setState(() {
                      _opacity = 0;
                    });
                  } else {
                    setState(() {
                      _opacity = 1;
                    });
                  }
                },
                focusNode: _focus,
                maxLength: 15,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  color: Config.bbcolor,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                controller: tctrl,
                decoration: InputDecoration.collapsed(
                  hintText: 'Enter the output file name',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: _opacity,
              child: Container(
                margin: const EdgeInsets.fromLTRB(25, 0, 25, 25),
                child: MaterialButton(
                  elevation: 0,
                  padding: const EdgeInsets.all(10),
                  color: Config.bbcolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  onPressed: () {
                    performaction().then((_) {
                      setState(() {
                        _listctrl.jumpTo(0);
                      });
                    });
                  },
                  child: Text(
                    btntext,
                    style: TextStyle(color: Config.backgroundColor, fontFamily: "Montserrat", fontSize: 20),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: ListView(
                  controller: _listctrl,
                  reverse: true,
                  children: [
                    Text(
                      logcats,
                      style: TextStyle(color: Config.textcolor, fontFamily: 'Montserrat', fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
