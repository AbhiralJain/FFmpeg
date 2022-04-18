import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Config {
  static Color backgroundColor = const Color.fromRGBO(240, 235, 230, 1);
  static Color tilesColor = const Color.fromRGBO(255, 255, 255, 1);
  static Color textcolor = const Color.fromRGBO(50, 50, 50, 1);
  static Color bbcolor = const Color.fromRGBO(40, 45, 50, 1);

  static changeColor(dtheme) {
    dtheme = !dtheme;
    if (dtheme) {
      backgroundColor = const Color.fromRGBO(0, 0, 0, 1);
      tilesColor = const Color.fromRGBO(35, 35, 35, 1);
      textcolor = const Color.fromRGBO(255, 255, 255, 1);
      bbcolor = const Color.fromRGBO(230, 225, 220, 1);
    } else {
      backgroundColor = const Color.fromRGBO(240, 235, 230, 1);
      tilesColor = const Color.fromRGBO(255, 255, 255, 1);
      textcolor = const Color.fromRGBO(50, 50, 50, 1);
      bbcolor = const Color.fromRGBO(40, 45, 50, 1);
    }
  }

  static Future<bool> requestpermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  static createfolder(String folderName) async {
    Directory? dir = await getExternalStorageDirectory();
    String newpath = "/storage/emulated/0/Pictures/$folderName";
    dir = Directory(newpath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    } else {
      return;
    }
  }

  static AlertStyle get alertConfig {
    return AlertStyle(
      backgroundColor: Config.tilesColor,
      alertAlignment: Alignment.center,
      animationType: AnimationType.shrink,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(
        color: Config.textcolor,
        fontWeight: FontWeight.normal,
        fontFamily: 'Montserrat',
        fontSize: 15,
      ),
      titleStyle:
          TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Montserrat', color: Config.textcolor),
      descTextAlign: TextAlign.left,
      animationDuration: const Duration(milliseconds: 100),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
    );
  }
}
