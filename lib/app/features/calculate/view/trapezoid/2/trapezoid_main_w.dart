import 'package:calc_quadrilateral/app/config/theme/app_color.dart';
import 'package:calc_quadrilateral/app/config/theme/app_size.dart';
import 'package:calc_quadrilateral/app/config/theme/app_style.dart';
import 'package:calc_quadrilateral/app/config/theme/light_dark_theme.dart';

import 'package:calc_quadrilateral/app/constants/const_color.dart';

import 'package:calc_quadrilateral/app/features/calculate/controllers/trapezoid_c.dart';
import 'package:calc_quadrilateral/app/features/calculate/view/trapezoid/2/draw_shape.dart';

import 'package:calc_quadrilateral/app/translations/translate_helper.dart';

import 'package:calc_quadrilateral/app/shared_components/custom_snakbar_w.dart';

import 'package:calc_quadrilateral/app/utils/app_utils.dart';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'trapezoid_detail_w.dart';
import 'trapezoid_image_input_w.dart';

import 'trapezoid_numpad_w.dart';

late TrapezoidController c;

class TrapezoidMain extends StatelessWidget {
  const TrapezoidMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    c = TrapezoidController.to;

    settingBar();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              return c.isActiveImageInfo.value
                  ? const TrapezoidDetail()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InteractiveViewer(
                            child: const TrapezoidImageInputWidget()),
                        //показываем если не инфо
                        Obx(() {
                          return Visibility(
                              visible: !c.isActiveImageInfo.value,
                              child: const AreaAndPerimeterWidget());
                        }),
                        Obx(() {
                          return Visibility(
                              visible: !c.isActiveImageInfo.value,
                              child: const MessageWidget());
                        }),

                        const Expanded(child: NumPadTrapezoidWidget()),
                      ],
                    );
            }),

            //иконка вверху справа
            Obx(() {
              return c.isActiveImageInfo.value
                  ? const IconInputInfoWidget(icon: Icons.description_outlined)
                  : const IconInputInfoWidget(icon: Icons.calculate_outlined);
            }),

            Positioned(
              top: 5.h,
              left: 20.w,
              child: SizedBox(width: 30.w, height: 30.w, child: DrawShape()),
            ),
          ],
        ),
      ),
    );
  }
}

class IconInputInfoWidget extends StatelessWidget {
  const IconInputInfoWidget({
    Key? key,
    required this.icon,
  }) : super(key: key);
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 10.h,
        right: 20.w,
        child: InkResponse(
          onTap: () {
            c.isActiveImageInfo.value = !(c.isActiveImageInfo.value);
          },
          child: Container(
            color: AppColors.content(context),
            child: Icon(
              icon,
              size: AppSize.iconSize * 1.2,
              color: AppColors.text(context),
            ),
          ),
        ));
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // показ если что то не то))
      return Visibility(
        visible: c.isActiveSnackBar.value,
        child: CustomMessageView(message: c.messageSnackBar.value),
      );
    });
  }
}

class AreaAndPerimeterWidget extends StatelessWidget {
  const AreaAndPerimeterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Visibility(
        visible: !c.isActiveSnackBar.value,
        child: SizedBox(
          width: 1.sw,
          height: AppUtils.getHeight(context) * 0.06,
          child: Stack(
            children: [
              Positioned(
                left: 20.w,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      TranslateHelper.area,
                      style: AppStyleText.titleText(context),
                    ),
                    Text(
                      c.area.value,
                      style: AppStyleText.subText(context),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: Icon(
                  Icons.done,
                  color: ConstColor.secondary,
                  size: 50.sp,
                ),
              ),
              Positioned(
                right: 20.w,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      TranslateHelper.perimeter,
                      style: AppStyleText.titleText(context),
                    ),
                    Text(
                      c.perimeter.value,
                      style: AppStyleText.subText(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
