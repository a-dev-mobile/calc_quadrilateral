import 'package:calc_quadrilateral/app/services/global_serv.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app/config/routes/app_page.dart';
import 'app/config/theme/light_dark_theme.dart';
import 'app/constants/const_string.dart';
import 'app/translations/app_translations.dart';

void main() async {
  // Logger.level = Level.nothing; //TODO on LOG
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();
  Get.putAsync<GlobalServ>(() async => GlobalServ());

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static GlobalKey<NavigatorState> materialKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: () {
          return GetMaterialApp(
            navigatorKey: MyApp.materialKey,

            //���� ������ ������ �� ��������� � ���������� ������������ �� ��������
            initialRoute: GlobalServ.to.isFirstStartApp
                ? Routes.welcome
                : GlobalServ.to.isShowLaunchScreen.value
                    ? Routes.welcome
                    : Routes.selectShape,

            defaultTransition: Transition.rightToLeft,
            getPages: AppPage.pages,
            themeMode: GlobalServ.to.isDarkTheme.value
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: lightThemeData(context),
            darkTheme: darkThemeData(context),
            translations: AppTranslation(),
            locale: GlobalServ.to.appLocale() == ConstString.localeRu
                ? const Locale(ConstString.localeRu)
                : const Locale(ConstString.localeEn),

            debugShowCheckedModeBanner: false,
          );
        });
  }
}
