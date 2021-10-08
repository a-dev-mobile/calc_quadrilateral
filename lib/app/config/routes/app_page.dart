
import 'package:calc_quadrilateral/app/features/calculate/controllers/scalene_c.dart';

import 'package:calc_quadrilateral/app/features/calculate/view/scalene/calculate_scalene.dart';
import 'package:calc_quadrilateral/app/features/select_shape/controller/select_shape_c.dart';
import 'package:calc_quadrilateral/app/features/select_shape/select_shape_p.dart';

import 'package:calc_quadrilateral/app/features/setting/controller/setting_c.dart';
import 'package:calc_quadrilateral/app/features/setting/view/setting_p.dart';
import 'package:calc_quadrilateral/app/features/welcome/welcome_p.dart';

import 'package:get/get.dart';

abstract class Routes {
  static const initial = welcome;
  static const welcome = '/welcome';
  static const selectShape = '/selectShape';


  static const calculateScalene = '/calculateScalene';


  static const setting = '/setting';
}

class AppPage {
  static final pages = [
    GetPage(
        name: Routes.welcome,
        page: () => const WelcomePage(),
        binding: BindingsBuilder(() {
          Get.put<SettingContrl>(SettingContrl());
        })),
    GetPage(
        name: Routes.selectShape,
        page: () => const SelectShapePage(),
        binding: BindingsBuilder(() {
          Get.put<SelectShapeController>(SelectShapeController(),
              permanent: true);
        })),
   
    GetPage(
        name: Routes.calculateScalene,
        transition: Transition.leftToRight,
        page: () => const CalculateScalenePage(),
        binding: BindingsBuilder(() {
          Get.put<ScalenequadrilateralController>(
              ScalenequadrilateralController(),
              permanent: true);
        })),
  

    GetPage(
        name: Routes.setting,
        page: () => SettingPage(),
        transition: Transition.leftToRight,
        binding: BindingsBuilder(() {
          Get.put<SettingContrl>(SettingContrl());
        })),
  ];
}
