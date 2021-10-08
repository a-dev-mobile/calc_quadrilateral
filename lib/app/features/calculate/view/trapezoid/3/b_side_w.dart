// ignore_for_file: invalid_use_of_protected_member

import 'dart:math';

import 'package:calc_quadrilateral/app/config/theme/app_style.dart';
import 'package:calc_quadrilateral/app/features/calculate/controllers/trapezoid_c.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

late var c = TrapezoidController.to;

class BsideWidget extends StatelessWidget {
  const BsideWidget(
      {Key? key,
      required this.posX,
      required this.posY,
      required this.angle,
      required this.minSizeImage})
      : super(key: key);

  final double posX;
  final double posY;
  final double angle;
  final double minSizeImage;

  // ====change====
  void onTap() {
    c.isaSide.value = false;
    c.isbSide.value = true;
    c.iscSide.value = false;
    c.ishHeight.value = false;
    c.isaAngle.value = false;
    c.isbAngle.value = false;
    c.isyAngle.value = false;
    c.showMessage();
  }

  //===============
  @override
  Widget build(BuildContext context) {
    TextStyle styleText;

    bool isActiveInput;
    bool isActiveParam;
    Trapezoid elementFigure;
    String activeValue;
    return Transform.translate(
        offset:
            Offset((posX / 100) * minSizeImage, (posY / 100) * minSizeImage),
        child: Transform.rotate(
            angle: angle * pi / 180,
            child: Obx(() {
              // ====change====
              activeValue = c.bSide.value;
              isActiveInput = c.isbSide.value;
              elementFigure = Trapezoid.bSide;
              //===============
              isActiveParam =
                  c.activeParamMap.value.containsValue(elementFigure);
              if (isActiveInput) {
                styleText = AppStyleTextImage.activeInput(context);
              } else if (isActiveParam) {
                styleText = AppStyleTextImage.activeParam(context);
              } else {
                styleText = AppStyleTextImage.inActive(context);
              }

              return GestureDetector(
                  onTap: () {
                    onTap();
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
                    color: Colors.transparent,
                    child: Text(
                      activeValue,
                      style: styleText,
                    ),
                  ));
            })));
  }
}
