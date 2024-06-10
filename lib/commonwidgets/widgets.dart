import 'package:chatapplication/color/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Commonwidgets {
  static void ShowSanckbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static String imageurl =
      "https://images.unsplash.com/photo-1549740425-5e9ed4d8cd34?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
  static void Getalertbox(
    String message,
    Color? bgcolor,
    List<Widget>? actionbuttons,
    bool? barrierDismissible,
    BuildContext context,
    Widget? contentmessage,
  ) {
    Get.defaultDialog(
      content: contentmessage,
      title: message,
      backgroundColor: bgcolor ?? Colors.white,
      actions: actionbuttons,
      barrierDismissible: barrierDismissible ?? false,
    );
  }

  static void GetSnackbar(
    String? title,
    String message,
    Color? bgcolor,
    SnackStyle? snackStyle,
    ImageProvider? Widget,
    BuildContext context,
  ) {
    Get.snackbar("${title}", "${message}",
        icon: CircleAvatar(
          backgroundImage: Widget,
        ),
        backgroundColor: bgcolor ?? Colors.white,
        snackStyle: snackStyle ?? SnackStyle.FLOATING);
  }

  static progressindicator(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  static void showbottomsheet(BuildContext context, Widget widget, Color? color,
      var elevation, ShapeBorder shapeBorder, bool? drag, bool? iscontrolled) {
    Get.bottomSheet(
      widget,
      backgroundColor: color ?? whiteColor,
      elevation: elevation ?? 5,
      shape: shapeBorder,
      enableDrag: drag ?? true,
      isScrollControlled: iscontrolled ?? false,
    );
  }

  static void show(
    BuildContext context, {
    String? message,
    String? content,
    Color? color,
  }) {
    final displayMessage = message ?? 'Default Message';
    final displayContent = content ?? 'Default Content';
    final displayColor = color ?? darkcolor;

    final snackBar = SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (displayMessage.isNotEmpty)
            Text(displayMessage, style: TextStyle(fontWeight: FontWeight.bold)),
          if (displayContent.isNotEmpty) Text(displayContent),
        ],
      ),
      backgroundColor: displayColor,
    );

    // Show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
