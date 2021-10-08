import 'package:calc_quadrilateral/app/constants/const_color.dart';
import 'package:calc_quadrilateral/app/constants/const_string.dart';

import 'package:calc_quadrilateral/app/services/global_serv.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SettingContrl extends GetxController {
  static SettingContrl get to => Get.find();

  void setRusLocation() {
    GlobalServ.to.appLocale.value = ConstString.localeRu;
  }

  void setEnLocation() {
    GlobalServ.to.appLocale.value = ConstString.localeEn;
  }

  // =====================================

  // =====================================
  void setDarkTheme() {
    if (GlobalServ.to.isDarkTheme.value == true) return;

    Get.changeThemeMode(ThemeMode.dark);
    GlobalServ.to.setStorageIsDarkTheme(true);

    setThemeAppBar();
  }

  void setLightTheme() {
    if (GlobalServ.to.isDarkTheme.value == false) return;

    Get.changeThemeMode(ThemeMode.light);
    GlobalServ.to.setStorageIsDarkTheme(false);

    setThemeAppBar();
  }

  void setThemeAppBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarIconBrightness: GlobalServ.to.isDarkTheme.value
            ? Brightness.light
            : Brightness.dark,
        statusBarColor: GlobalServ.to.isDarkTheme.value
            ? ConstColor.scaffoldDarkTheme
            : ConstColor.scaffoldLightTheme, // Color for Android
        statusBarBrightness: GlobalServ.to.isDarkTheme.value
            ? Brightness.dark
            : Brightness.light // Dark == white status bar -- for IOS.
        ));
  }

  @override
  void onClose() async {
    GlobalServ.to.startIfCloseSetiing();

// todo обновление точности расчета нужно сделать
//! not work
    // var c1 = RightquadrilateralController.to;
    // var c2 = TrapezoidController.to;
    // var c3 = EquilateralquadrilateralController.to;
    // var c4 = IsoscelesquadrilateralController.to;

    // c1.calculate();
    // c2.calculate();
    // c3.calculate();
    // c4.calculate();

    //сохранил чтобы локально не считывать
    super.onClose();
  }
}
