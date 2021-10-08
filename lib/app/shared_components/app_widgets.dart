import 'dart:io';

import 'package:calc_quadrilateral/app/config/theme/app_color.dart';
import 'package:calc_quadrilateral/app/config/theme/app_size.dart';
import 'package:calc_quadrilateral/app/translations/translate_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppWidgets {
  static Widget dividerWelcome() {
    return Divider(
      color: Colors.grey,
      height: 30.h,
      indent: 50.w,
      endIndent: 50.w,
    );
  }

  static Widget dividerDrawer() {
    return Divider(
      color: Colors.grey,
      height: 30.h,
      indent: 20.w,
      endIndent: 20.w,
    );
  }

  static viewDialogExit(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: AppColors.content(context),
            content: Text(
              TranslateHelper.exitWarning,
              style: TextStyle(color: AppColors.text(context)),
            ),
            title: Text(
              TranslateHelper.warning,
              style: TextStyle(
                  fontSize: AppSize.fontSizeHeadline6(context),
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                child: Text(TranslateHelper.yes),
                onPressed: () {
                  // SystemNavigator.pop();
                  exit(0);
                  //             Future.delayed(const Duration(milliseconds: 1000), () {
                  //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  // });
                },
              ),
              TextButton(
                child: Text(TranslateHelper.no),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
